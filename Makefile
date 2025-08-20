# 指定主要的简历文件，而不是所有 .tex 文件
MAIN_FILES = resume.tex resume-zh_CN.tex resume_photo.tex
PDFS = $(MAIN_FILES:.tex=.pdf)

# 默认编译中文简历
all: zh_CN

# 编译英文简历
en: clean
	xelatex resume.tex

# 编译中文简历  
zh_CN: clean
	xelatex resume-zh_CN.tex

# 编译带照片的简历
photo: clean
	xelatex resume_photo.tex

# 编译所有主要简历文件
pdf: clean $(PDFS)

# 编译规则
%.pdf: %.tex
	xelatex $<

# 完整编译（包含参考文献）
full: clean
	xelatex resume-zh_CN.tex
	-bibtex resume-zh_CN
	xelatex resume-zh_CN.tex
	xelatex resume-zh_CN.tex

# 跨平台删除命令
ifeq ($(OS),Windows_NT)
  # Windows
  RM = cmd //C del //Q
else
  # Unix/Linux/macOS
  RM = rm -f
endif

# 清理临时文件
clean:
	$(RM) *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.xdv *.fdb_latexmk *.fls

# 深度清理（包括 PDF）
distclean: clean
	$(RM) *.pdf

# 帮助信息
help:
	@echo "可用的编译选项："
	@echo "  make         - 编译中文简历 (默认)"
	@echo "  make zh_CN   - 编译中文简历"
	@echo "  make en      - 编译英文简历"
	@echo "  make photo   - 编译带照片的简历"
	@echo "  make pdf     - 编译所有主要简历"
	@echo "  make full    - 完整编译（包含参考文献）"
	@echo "  make clean   - 清理临时文件"
	@echo "  make distclean - 清理所有生成文件"
	@echo "  make help    - 显示此帮助信息"

.PHONY: all en zh_CN photo pdf full clean distclean help