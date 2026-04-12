[CmdletBinding()]
param(
    [ValidateSet('master', 'zh_CN')]
    [string]$Branch,

    [ValidateSet('en', 'photo', 'zh', 'zh-slim', 'all')]
    [string]$Target = 'all',

    [switch]$KeepTemp
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$branchTargets = @{
    'master' = [ordered]@{
        'en' = 'resume.tex'
        'photo' = 'resume_photo.tex'
    }
    'zh_CN' = [ordered]@{
        'en' = 'resume.tex'
        'photo' = 'resume_photo.tex'
        'zh' = 'resume-zh_CN.tex'
        'zh-slim' = 'resume-zh_Slim.tex'
    }
}

$tempPatterns = @(
    '*.aux',
    '*.log',
    '*.out',
    '*.bbl',
    '*.blg',
    '*.fdb_latexmk',
    '*.fls',
    '*.synctex.gz',
    '*.xdv'
)

function Invoke-Tool {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter()]
        [string[]]$Arguments = @()
    )

    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        $argumentText = if ($Arguments.Count -gt 0) { $Arguments -join ' ' } else { '' }
        throw "Command failed: $FilePath $argumentText".Trim()
    }
}

function Get-TrimmedOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter()]
        [string[]]$Arguments = @()
    )

    $output = & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        $argumentText = if ($Arguments.Count -gt 0) { $Arguments -join ' ' } else { '' }
        throw "Command failed: $FilePath $argumentText".Trim()
    }

    return ($output | Out-String).Trim()
}

function Remove-LatexTemps {
    foreach ($pattern in $tempPatterns) {
        $matches = Get-ChildItem -Path (Join-Path $repoRoot $pattern) -Force -ErrorAction SilentlyContinue
        if ($matches) {
            $matches | Remove-Item -Force -ErrorAction Stop
        }
    }
}

function Get-TargetsForBranch {
    param(
        [Parameter(Mandatory = $true)]
        [string]$BranchName
    )

    if (-not $branchTargets.ContainsKey($BranchName)) {
        throw "Unsupported branch '$BranchName'. Supported branches: $($branchTargets.Keys -join ', ')."
    }

    return $branchTargets[$BranchName]
}

Push-Location $repoRoot
try {
    $git = (Get-Command git -ErrorAction Stop).Source
    $latexmk = (Get-Command latexmk -ErrorAction Stop).Source
    $null = Get-Command xelatex -ErrorAction Stop

    $currentBranch = Get-TrimmedOutput -FilePath $git -Arguments @('branch', '--show-current')
    if ([string]::IsNullOrWhiteSpace($currentBranch)) {
        throw 'Unable to determine the current Git branch.'
    }

    $desiredBranch = if ($PSBoundParameters.ContainsKey('Branch')) { $Branch } else { $currentBranch }
    $availableTargets = Get-TargetsForBranch -BranchName $desiredBranch

    if ($Target -eq 'all') {
        $targetsToBuild = @($availableTargets.Keys)
    }
    else {
        if (-not $availableTargets.Contains($Target)) {
            throw "Target '$Target' is not available on branch '$desiredBranch'. Available targets: $($availableTargets.Keys -join ', ')."
        }

        $targetsToBuild = @($Target)
    }

    Remove-LatexTemps

    if ($currentBranch -ne $desiredBranch) {
        $status = Get-TrimmedOutput -FilePath $git -Arguments @('status', '--porcelain')
        if (-not [string]::IsNullOrWhiteSpace($status)) {
            throw "Working tree is not clean after removing LaTeX temporary files. Commit, stash, or clean your changes before switching to '$desiredBranch'."
        }

        Write-Host "Switching branch: $currentBranch -> $desiredBranch"
        Invoke-Tool -FilePath $git -Arguments @('switch', '--quiet', $desiredBranch)
        $availableTargets = Get-TargetsForBranch -BranchName $desiredBranch
    }

    $builtPdfs = New-Object System.Collections.Generic.List[string]
    foreach ($targetName in $targetsToBuild) {
        $texFile = $availableTargets[$targetName]
        $texPath = Join-Path $repoRoot $texFile
        if (-not (Test-Path -LiteralPath $texPath)) {
            throw "Source file not found for target '$targetName': $texFile"
        }

        Write-Host "Building target '$targetName' from $texFile"
        Invoke-Tool -FilePath $latexmk -Arguments @(
            '-xelatex',
            '-interaction=nonstopmode',
            '-halt-on-error',
            '-file-line-error',
            $texFile
        )

        $builtPdfs.Add(([System.IO.Path]::GetFileNameWithoutExtension($texFile) + '.pdf'))
    }

    if (-not $KeepTemp) {
        Remove-LatexTemps
    }

    Write-Host 'Build complete.'
    foreach ($pdf in $builtPdfs) {
        Write-Host "  $pdf"
    }
}
finally {
    Pop-Location
}
