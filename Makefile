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
	xelatex $<
	- bibtex $*
	xelatex $<
	- makeindex -s gind.ist -o $*.ind $*.idx
	- makeindex -s gglo.ist -o $*.gls $*.glo
	xelatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do xelatex $<; done


%.cls:   %.ins %.dtx  
	xelatex $<

%.pdf:  %.tex   $(PACKAGE).cls
	xelatex $<
	- bibtex $*
	- makeindex -s $(PACKAGE).ist -o $*.ind $*.idx
	xelatex $<
	xelatex $<
	- makeindex -s $(PACKAGE).ist -o $*.ind $*.idx
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do xelatex $<; done



.PRECIOUS:  $(PACKAGE).cfg $(PACKAGE).cls


clean:
	$(RM)  $(PACKAGE).cls *.log *.aux \
	*.glo *.idx *.toc *.tbc *.hd \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.sty *.ist \
	*.dvi *.ps *.thm *.tgz *.zip

distclean: clean
	$(RM) $(PDF)

#
# Archive for the distribution. Includes typeset documentation
#
archive:  all clean
	COPYFILE_DISABLE=1 tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS --exclude '.git*' $(PACKAGE); mv ../$(PACKAGE).tgz .


zip:  all clean
	zip -r  $(PACKAGE).zip * \
	-x 'debug*' -x '*~' -x '*.tgz' -x '*.zip' -x .git* -x '.git/*'
