# 一个简洁优雅的 XeLaTeX 简历模板

如果你只需要英文简历，请使用 [master](https://github.com/billryan/resume/tree/master) 分支。

这个仓库基于 Bill Ryan 的简历模板，使用 `XeLaTeX` 编译，支持英文、中文和带照片版本。

## 分支说明

- `master`: 英文简历分支，主要入口文件为 `resume.tex` 和 `resume_photo.tex`
- `zh_CN`: 中文分支，是 `master` 的超集，额外包含 `resume-zh_CN.tex` 和 `resume-zh_Slim.tex`

## 主要特性

- 基于 `XeLaTeX`，支持 Unicode 和中英文混排
- 自带字体资源，开箱即用
- 提供英文、中文、精简中文、带照片等多个模板入口
- 支持 FontAwesome 图标字体

## 在线使用

- Overleaf 模板: <https://www.overleaf.com/latex/templates/bill-ryans-elegant-latex-resume/xcqmhktmzmsw>
- LaTeX.Online: <https://latexonline.cc/>

## 本地编译

确保本机已经安装可用的 `xelatex`。

```tex
xelatex resume.tex
xelatex resume_photo.tex
xelatex resume-zh_CN.tex
xelatex resume-zh_Slim.tex
```

如果启用了参考文献，可以继续运行 `bibtex` 并重复执行 `xelatex`。

## Windows 本机构建

仓库包含 PowerShell 构建脚本 `scripts/build-resume.ps1`，用于在 Windows 下直接构建并在需要时切换分支。

环境要求:

- Git
- PowerShell 5.1 或更高版本
- TeX Live 或其他包含 `xelatex`、`latexmk` 的发行版，并确保它们在 `PATH` 中可用

在仓库根目录执行:

```powershell
.\scripts\build-resume.ps1 -Branch master -Target en
.\scripts\build-resume.ps1 -Branch master -Target photo
.\scripts\build-resume.ps1 -Branch zh_CN -Target zh
.\scripts\build-resume.ps1 -Branch zh_CN -Target zh-slim
.\scripts\build-resume.ps1 -Branch zh_CN -Target all
```

脚本行为:

- 如果当前分支与 `-Branch` 指定的分支不同，脚本会先自动切换到目标分支再编译
- 切换分支前会先清理 LaTeX 临时文件
- 默认只保留生成出的 PDF，传入 `-KeepTemp` 时保留中间文件

目标映射:

- `master`: `en`, `photo`
- `zh_CN`: `en`, `photo`, `zh`, `zh-slim`

## Linux 下使用 make

Linux 和其他类 Unix 环境可以继续使用仓库自带的 `Makefile`。

常用命令:

```bash
make en
make photo
make zh_CN
make zh_slim
make pdf
make clean
make distclean
```

说明:

- `master` 分支主要使用 `make en` 和 `make photo`
- `zh_CN` 分支支持 `make zh_CN`、`make zh_slim`、`make en`、`make photo`、`make pdf`
- 如果启用了参考文献，还可以在 `zh_CN` 分支使用 `make full`

## 中文字体说明

中文模板默认使用仓库内的外部字体配置:

```tex
\usepackage{zh_CN-Adobefonts_external}
\usepackage{linespacing_fix}
```

如果你的系统已经安装了对应 Adobe 中文字体，也可以改用:

```tex
\usepackage{zh_CN-Adobefonts_internal}
```

## License

[The MIT License (MIT)](http://opensource.org/licenses/MIT)

Copyrighted fonts are not subjected to this License.
