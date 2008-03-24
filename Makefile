#
# Makefile for nostarch package
#
# This file is in public domain
#
# $Id$
#

PACKAGE=nostarch

SAMPLES = nssample.tex


PDF = $(PACKAGE).pdf ${SAMPLES:%.tex=%.pdf}

all:  ${PDF}


%.pdf:  %.dtx   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done


%.cls:   %.ins %.dtx  
	pdflatex $<

%.pdf:  %.tex   $(PACKAGE).cls
	pdflatex $<
	- bibtex $*
	pdflatex $<
	- makeindex -s $(PACKAGE).ist -o $*.ind $*.idx
	pdflatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do pdflatex $<; done



.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).cls


clean:
	$(RM)  $(PACKAGE).cls *.log *.aux \
	*.glo *.idx *.toc *.tbc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.sty *.ist \
	*.dvi *.ps *.thm *.tgz *.zip

distclean: clean
	$(RM) $(PDF)

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	tar -czvf $(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS .

zip:  all clean
	zip -r  $(PACKAGE).zip * -x '*~' -x '*.tgz' -x '*.zip' -x CVS -x 'CVS/*'