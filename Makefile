
PAPER=thesis
all: pdf
pdf: $(PAPER).pdf
pdf-missing-graphics: $(PAPER).pdf-without-pdflatex
dvi: $(PAPER).dvi

SECTIONS = \
	**/*.tex \
	*.bib \

TEXT =  $(SECTIONS) 

TEX   = $(PAPER).tex \
        $(TEXT)

FIGS = $(wildcard figures/*.*)

PS2PDF = ps2pdf

$(PAPER).ps: $(PAPER).dvi
	dvips -e 0 -Pcmz -Pamz -G0 -D 600 -t letter $(PAPER) -o $@

$(PAPER).dvi: $(PAPER).tex $(TEX) $(FIGS) $(PAPER).bbl 
	export TEXINPUTS=.:./latex-styles:; \
	latex $(PAPER)
	latex $(PAPER)
	latex $(PAPER)

$(PAPER).bbl-without-pdflatex: bibliography.bib-without-pdflatex
	export TEXINPUTS=.:./latex-styles:; \
	latex $(PAPER); bibtex $(PAPER); latex $(PAPER); latex $(PAPER)

$(PAPER).bbl: bibdata.bib
	export TEXINPUTS=.:./latex-styles:; \
	pdflatex $(PAPER); bibtex $(PAPER); pdflatex $(PAPER); pdflatex $(PAPER)

$(PAPER).pdf-without-pdflatex: $(PAPER).ps 
	$(PS2PDF) $^ $(PAPER).pdf

$(PAPER).pdf: $(TEX) $(FIGS) $(PAPER).bbl
	pdflatex $(PAPER); bibtex $(PAPER); pdflatex $(PAPER); pdflatex $(PAPER)

again:
	/bin/rm $(PAPER).dvi; $(MAKE)

DELATEX = detex -l -n 

html: $(PAPER).ps
	-/bin/rm -rf html
	latex2html  -image_type gif -split 0 -show_section_numbers \ 
	-local_icons -dir html -transparent -info 0 -antialias_text \
	-white -antialias -mkdir $(PAPER).tex

viewhtml:
	firefox file://$$PWD/html/index.html


count:
	$(DELATEX)  $(TEXT) | wc -w

count1:
	countwords $(TEXT)
 

count2:
	delatex $(TEX) | wc -w

spell:
	ispell $(SECTIONS)

clean:
	/bin/rm -f $(PAPER).aux $(PAPER).bbl $(PAPER).blg $(PAPER).dvi \
	$(PAPER).log $(PAPER).ps $(PAPER).pdf $(PAPER).out

