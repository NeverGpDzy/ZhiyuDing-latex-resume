# LaTeX Resume Makefile
# Supports both English and Chinese versions

# Source files
EN_SRC = resume.tex
PHOTO_SRC = resume_photo.tex
ZH_SRC = resume-zh_CN.tex
ALL_SRC = $(wildcard *.tex)

# Output PDF files
EN_PDF = $(EN_SRC:.tex=.pdf)
PHOTO_PDF = $(PHOTO_SRC:.tex=.pdf)
ZH_PDF = $(ZH_SRC:.tex=.pdf)
ALL_PDFS = $(ALL_SRC:.tex=.pdf)

# LaTeX compiler
LATEX = xelatex

# Determine OS for clean command
ifeq ($(OS),Windows_NT)
    # Windows
    RM = cmd //C del
    RM_RF = cmd //C rmdir /s /q
    FILE_EXISTS = if exist
else
    # Unix/Linux/macOS
    RM = rm -f
    RM_RF = rm -rf
    FILE_EXISTS = test -f
endif

# Default target
.PHONY: all clean clean-all en photo zh_CN pdf help install-deps force-en force-photo force-zh list-files dev-en dev-photo dev-zh watch-en watch-photo watch-zh

all: help

# List available files
list-files:
	@echo "Available LaTeX files:"
	@ls -la *.tex 2>/dev/null || echo "No .tex files found"
	@echo ""
	@echo "Available PDF files:"
	@ls -la *.pdf 2>/dev/null || echo "No .pdf files found"

# Build all PDFs
pdf: $(ALL_PDFS)

# Build English version (with file check)
en:
	@if [ ! -f $(EN_SRC) ]; then \
		echo "Error: $(EN_SRC) not found!"; \
		echo "Available .tex files:"; \
		ls -1 *.tex 2>/dev/null || echo "No .tex files found"; \
		exit 1; \
	fi
	@$(MAKE) $(EN_PDF)

# Build photo version (with file check)  
photo:
	@if [ ! -f $(PHOTO_SRC) ]; then \
		echo "Error: $(PHOTO_SRC) not found!"; \
		echo "Available .tex files:"; \
		ls -1 *.tex 2>/dev/null || echo "No .tex files found"; \
		exit 1; \
	fi
	@$(MAKE) $(PHOTO_PDF)

# Build Chinese version (with file check)
zh_CN:
	@echo "Warning: $(ZH_SRC) not found in current directory."
	@echo "Available .tex files:"
	@ls -1 *.tex 2>/dev/null || echo "No .tex files found"
	@echo ""
	@echo "Note: resume-zh_CN.pdf already exists (possibly from another source)"
	@echo "Available options:"
	@echo "  make en     - Build English version"
	@echo "  make photo  - Build photo version"

# Force rebuild English version
force-en:
	@if [ ! -f $(EN_SRC) ]; then \
		echo "Error: $(EN_SRC) not found!"; \
		exit 1; \
	fi
	$(RM) $(EN_PDF)
	@$(MAKE) $(EN_PDF)

# Force rebuild photo version
force-photo:
	@if [ ! -f $(PHOTO_SRC) ]; then \
		echo "Error: $(PHOTO_SRC) not found!"; \
		exit 1; \
	fi
	$(RM) $(PHOTO_PDF)
	@$(MAKE) $(PHOTO_PDF)

# Force rebuild Chinese version
force-zh:
	@echo "Cannot force rebuild: $(ZH_SRC) not found!"
	@echo "Available options: force-en, force-photo"

# Pattern rule for PDF generation
%.pdf: %.tex
	@echo "Building $@..."
	$(LATEX) $<
	@echo "Successfully built $@"

# Install dependencies (for Ubuntu/Debian)
install-deps:
	@echo "Installing LaTeX dependencies..."
	sudo apt-get update
	sudo apt-get install -y texlive-xetex texlive-fonts-recommended texlive-fonts-extra
	@echo "Dependencies installed successfully"

# Clean temporary files (keep PDFs)
clean:
	@echo "Cleaning temporary files..."
	$(RM) *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.fls *.fdb_latexmk

# Clean everything including PDFs
clean-all: clean
	@echo "Cleaning all generated files..."
	$(RM) *.pdf

# Development target - build and open English version
dev-en: en
	@echo "Opening $(EN_PDF)..."
ifeq ($(OS),Windows_NT)
	start $(EN_PDF)
else ifeq ($(shell uname),Darwin)
	open $(EN_PDF)
else
	xdg-open $(EN_PDF) 2>/dev/null || echo "Please manually open $(EN_PDF)"
endif

# Development target - build and open photo version
dev-photo: photo
	@echo "Opening $(PHOTO_PDF)..."
ifeq ($(OS),Windows_NT)
	start $(PHOTO_PDF)
else ifeq ($(shell uname),Darwin)
	open $(PHOTO_PDF)
else
	xdg-open $(PHOTO_PDF) 2>/dev/null || echo "Please manually open $(PHOTO_PDF)"
endif

# Development target - build and open Chinese version
dev-zh: zh_CN

# Watch and rebuild on file changes (requires inotify-tools on Linux)
watch-en:
	@echo "Watching for changes to $(EN_SRC)..."
	@while true; do \
		make en; \
		inotifywait -qe modify $(EN_SRC); \
	done

watch-photo:
	@echo "Watching for changes to $(PHOTO_SRC)..."
	@while true; do \
		make photo; \
		inotifywait -qe modify $(PHOTO_SRC); \
	done

watch-zh:
	@echo "Cannot watch: $(ZH_SRC) not found!"

# Help target
help:
	@echo "LaTeX Resume Build System"
	@echo "========================="
	@echo ""
	@echo "Available targets:"
	@echo "  list-files  - List available .tex and .pdf files"
	@echo "  en          - Build English resume ($(EN_PDF))"
	@echo "  photo       - Build photo resume ($(PHOTO_PDF))"
	@echo "  zh_CN       - Show info about Chinese version"
	@echo "  force-en    - Force rebuild English version"
	@echo "  force-photo - Force rebuild photo version"
	@echo "  pdf         - Build all PDF files"
	@echo "  clean       - Remove temporary files (keep PDFs)"
	@echo "  clean-all   - Remove all generated files including PDFs"
	@echo "  dev-en      - Build and open English version"
	@echo "  dev-photo   - Build and open photo version"
	@echo "  watch-en    - Watch English file and rebuild on changes"
	@echo "  watch-photo - Watch photo file and rebuild on changes"
	@echo "  install-deps- Install LaTeX dependencies (Ubuntu/Debian)"
	@echo "  help        - Show this help message"
	@echo ""
	@echo "Your available source files:"
	@echo "  ✓ $(EN_SRC) → $(EN_PDF)"
	@echo "  ✓ $(PHOTO_SRC) → $(PHOTO_PDF)"
	@echo "  ✗ $(ZH_SRC) (not available)"
	@echo ""
	@echo "Examples:"
	@echo "  make list-files            # See what files are available"
	@echo "  make en                    # Build English version"
	@echo "  make photo                 # Build photo version" 
	@echo "  make force-en              # Force rebuild English version"
	@echo "  make dev-photo             # Build and open photo version"
	@echo ""
	@echo "Troubleshooting:"
	@echo "  - If 'Nothing to be done', try force-en or force-photo"
	@echo "  - If file not found, check with list-files first"

# Make sure PDF targets depend on their source files
$(EN_PDF): $(EN_SRC)
$(PHOTO_PDF): $(PHOTO_SRC)