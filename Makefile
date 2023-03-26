-include Makefile.local

PAPER_NAME:=Thesis



TEX := $(shell find ./ -type f -name "*.tex")
CLS := $(shell find ./ -type f -name "*.cls")
BIB := $(shell find ./ -type f -name "*.bib")
FIG := $(shell find ./Figures -type f -name "*.pdf")
GNUPLOTS := $(addsuffix .pdf,$(basename $(shell find ./Figures -type f -name "*.gnuplot" | grep -v common)))
PAPER_DEPS := $(TEX) $(CLS) $(BIB) $(FIG) $(GNUPLOTS)
LATEX := python3 ./bin/latexrun --color auto --bibtex-args="-min-crossrefs=9000"

all: $(PAPER_NAME).pdf 

%.eps: %.dia
	dia -e $@ -t eps $<

%.pdf: %.eps
	epspdf $< $@.tmp.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
	  -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH \
	  -sOutputFile=$@ $@.tmp.pdf
	rm -f $@.tmp.pdf

%.pdf: %.gnuplot %.dat figures/common.gnuplot
	(cd $(dir $@) ; gnuplot $(notdir $<)) | pdfcrop - $@


$(PAPER_NAME).pdf: $(PAPER_DEPS)
	$(LATEX) $(PAPER_NAME).tex -O .latex.out -o $@


clean:
	$(LATEX) --clean-all -O .latex.out
	@rm -frv .latex.out $(PDFS) $(GNUPLOTS) arxiv arxiv.tar.gz

include .devcontainer/rules.mk

help:
	@printf "Usage: make [target]\n"
	@printf "\n"
	@printf "Available targets:\n"
	@printf "\n"
	@printf "\thelp                          Show this help message\n"
	@printf "$(HELP_MSG)"
	@printf "\n"

#arxiv: arxiv.tar.gz
#
#arxiv.tar.gz: $(PAPER_NAME).pdf
#	rm -rf arxiv
#	mkdir -p arxiv
#	cp paper.tex arxiv/ms.tex
#	cp abstract.tex arxiv/
#	cp intro.tex arxiv/
#	cp background.tex arxiv/
#	cp design.tex arxiv/
#	cp impl.tex arxiv/
#	cp eval.tex arxiv/
#	cp discussion.tex arxiv/
#	cp related.tex arxiv/
#	cp conclusion.tex arxiv/
#	cp .latex.out/paper.bbl arxiv/ms.bbl
#	mkdir -p arxiv/figures
#	cp figures/*.pdf figures/*.tex arxiv/figures
#	cp usenix-2020-09.sty arxiv/
#	(cd arxiv && tar czf ../arxiv.tar.gz *)

# Additional dependencies
#figures/dctcp.pdf: figures/dctcp_ns3.dat
