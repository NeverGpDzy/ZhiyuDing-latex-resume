# Résumé

Hit branch [zh_CN](https://github.com/billryan/resume/tree/zh_CN) if you want a Simplified Chinese résumé.

中文用户请前往 [zh_CN](https://github.com/billryan/resume/tree/zh_CN) 分支。

An elegant \LaTeX\ résumé template, compiled with \XeLaTeX. Inspired by 

- [zachscrivena/simple-resume-cv](https://github.com/zachscrivena/simple-resume-cv)
- [res](https://www.ctan.org/pkg/res)
- [JianXu's CV](http://www.jianxu.net/en/files/JianXu_CV.pdf)
- [paciorek's CV/Resume template](http://www.stat.berkeley.edu/~paciorek/computingTips/Latex_template_creating_CV_.html)
- [How to write a LaTeX class file and design your own CV (Part 1) - ShareLaTeX](https://www.sharelatex.com/blog/2011/03/27/how-to-write-a-latex-class-file-and-design-your-own-cv.html)

## Features

- Easy to further customize or extend
- Full support for unicode characters (e.g. CJK) with \XeLaTeX\
- Perfect Simplified Chinese fonts supported with Adobefonts
- FontAwesome 4.6.3 support

## Quick Start
- Fork this repository
- Add information about you directly in GitHub
- Compile TeX file to PDF with [LaTeX.Online](https://latexonline.cc/)
- Can also use Overleaf for online compilation with [template](https://www.overleaf.com/latex/templates/bill-ryans-elegant-latex-resume/xcqmhktmzmsw)

### Sample Output

![English](https://user-images.githubusercontent.com/25968335/131621921-65ab1862-1f56-47ef-9d58-8d5149bec841.png)
![English with photo](https://user-images.githubusercontent.com/25968335/131621960-1cafb3c2-114b-4e90-8b04-bd9b949a6e9d.png)
![简体中文](https://user-images.githubusercontent.com/25968335/131621980-c004f2a6-4199-4676-8a97-5d2cb165402f.png)

- [English PDF](https://github.com/billryan/resume/files/3463503/resume.pdf)
- [English with photo PDF](https://github.com/billryan/resume/files/3463501/resume_photo.pdf)
- [简体中文 PDF](https://github.com/billryan/resume/files/3463502/resume-zh_CN.pdf)

## Usage

1. Edit in Overleaf online Web [template](https://www.overleaf.com/latex/templates/bill-ryans-elegant-latex-resume/xcqmhktmzmsw)
2. Compile tex on your Computer

If you only need a résumé in English or have installed Adobe Simplified Chinese on your OS, **It would be better to clone only the master branch,** since the Simplified Chinese fonts files are too large.

```
git clone https://github.com/billryan/resume.git --branch master --depth 1 --single-branch <folder>
```

## Branches

- `master`: English resume sources only. Use `resume.tex` or `resume_photo.tex`.
- `zh_CN`: Superset branch with bundled Chinese fonts and additional sources `resume-zh_CN.tex` and `resume-zh_Slim.tex`.

## Windows Local Build

This repository now includes a Windows PowerShell build entrypoint at `scripts/build-resume.ps1`.

Requirements:

- Git
- PowerShell 5.1 or newer
- TeX Live (or another XeLaTeX distribution) with both `xelatex` and `latexmk` on `PATH`

Examples from the repository root:

```powershell
.\scripts\build-resume.ps1 -Branch master -Target en
.\scripts\build-resume.ps1 -Branch master -Target photo
.\scripts\build-resume.ps1 -Branch zh_CN -Target zh
.\scripts\build-resume.ps1 -Branch zh_CN -Target zh-slim
.\scripts\build-resume.ps1 -Branch zh_CN -Target all
```

Behavior:

- If the current branch does not match `-Branch`, the script switches to the target branch before building.
- It removes LaTeX temporary files before branch switching and after successful builds.
- It keeps the generated PDF files and removes temporary files unless `-KeepTemp` is passed.

Target mapping:

- `master`: `en`, `photo`
- `zh_CN`: `en`, `photo`, `zh`, `zh-slim`

## Linux Build With make

On Linux and other Unix-like environments, you can continue using the repository `Makefile`.

Common commands on `master`:

```bash
make en
make photo
make pdf
make clean
make clean-all
```

Notes:

- `master` is intended for English builds, so the practical targets are `en`, `photo`, and `pdf`.
- If you need Chinese builds on Linux, switch to the `zh_CN` branch and use its additional targets there.

## License

[The MIT License (MIT)](http://opensource.org/licenses/MIT)

Copyrighted fonts are not subjected to this License.
