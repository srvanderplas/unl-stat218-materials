TARGETLIST       = $()
CLEANLIST        = $()

# --- Slides -------------------------------------------------------------------
SLIDESOURCE      = $(filter-out slides/index.Rmd, $(wildcard slides/*.Rmd))
SLIDETARGET      = $(SLIDESOURCE:%.Rmd=%.html)
SLIDEPDFTARGET   = $(SLIDESOURCE:%.Rmd=%.pdf)
SLIDEPDFPGTARGET = $(SLIDESOURCE:%.Rmd=%-4.pdf) $(SLIDESOURCE:%.Rmd=%-3.pdf) $(SLIDESOURCE:%.Rmd=%-2.pdf)
TARGETLIST      += $(SLIDETARGET) $(SLIDEPDFTARGET) $(SLIDEPDFPGTARGET)

%.pdf: %.html
	Rscript -e "pagedown::chrome_print('$<', '$@')"
%-4.pdf: %.pdf
	pdfnup --nup 2x2 --frame true --paper letterpaper --noautoscale false \
	       --scale 0.92 --suffix 4 --outfile slides $<
%-3.pdf: %.pdf
	pdfjam-slides3up --suffix 3 --paper letterpaper --outfile slides $<
%-2.pdf: %.pdf
	pdfnup --nup 1x2 --frame true --paper letterpaper --noautoscale false \
	       --no-landscape --scale 0.92 --suffix 2 --outfile slides $<

# --- Handouts -----------------------------------------------------------------
HANDOUTSOURCE    = $(filter-out handouts/index.Rmd, $(wildcard handouts/*.Rmd))
HANDOUTKEY       = $(shell grep -l 'params.key' $(HANDOUTSOURCE))
HANDOUTOUTPUT		 = $(subst handouts/%.Rmd, %, $(HANDOUTSOURCE))
HANDOUTTARGET    = $(HANDOUTOUTPUT:handouts/%.Rmd=handouts/%.pdf)
HANDOUTTARGETKEY = $(HANDOUTKEY:handouts/%.Rmd=handouts/%_key.pdf)
TARGETLIST      += $(HANDOUTTARGET) $(HANDOUTTARGETKEY)

#all:
#	@echo "HANDOUTSOURCE is $(HANDOUTSOURCE)"
#	@echo "grep -l 'params.key' $(HANDOUTSOURCE)"
#	@echo "HANDOUTTARGETKEY is $(HANDOUTTARGETKEY)"


%.pdf: %.Rmd
	Rscript -e "rmarkdown::render('$<')"
	rm -f $*.tex $*.log
handouts/%.pdf: handouts/%.Rmd
	Rscript -e "rmarkdown::render('$<', output_file = '$*', \
	                              output_dir = '$(@D)', \
	                              params = list(key = F))"
	rm -f handouts/$*.tex handouts/$*.log
handouts/%_key.pdf: handouts/%.Rmd
	Rscript -e "rmarkdown::render('$<', output_file = '$*_key', \
	                              output_dir = '$(@D)', \
	                              params = list(key = T))"
	rm -f handouts/$*_key.tex
	rm -f handouts/$*_key.log

# --- Exam Practice ------------------------------------------------------------
PEXAMSOURCE      = $(filter-out exam_practice/index.Rmd, $(wildcard exam_practice/*.Rmd))
PEXAMOUTPUT      = $(subst exam_practice/%.Rmd, %, $(PEXAMSOURCE))
PEXAMTARGET      = $(PEXAMOUTPUT:exam_practice/%.Rmd=exam_practice/%.pdf)
PEXAMTARGETKEY   = $(PEXAMOUTPUT:exam_practice/%.Rmd=exam_practice/%_key.pdf)
TARGETLIST      += $(PEXAMTARGET) $(PEXAMTARGETKEY)

exam_practice/%.pdf: exam_practice/%.Rmd
	Rscript -e "rmarkdown::render('$<', output_file = '$*', \
	                              output_dir = '$(@D)', \
	                              params = list(key = F))"
	rm -f exam_practice/$*.tex exam_practice/$*.log
exam_practice/%_key.pdf: exam_practice/%.Rmd
	Rscript -e "rmarkdown::render('$<', output_file = '$*_key', \
	                              output_dir = '$(@D)', \
	                              params = list(key = T))"
	rm -f exam_practice/$*_key.tex
	rm -f exam_practice/$*_key.log

# --- Index Files --------------------------------------------------------------
INDEXSOURCE     := $(shell find . -name 'index.Rmd')
INDEXTARGET      = $(INDEXSOURCE:%.Rmd=%.html)
TARGETLIST      += $(INDEXTARGET)

%.html: %.Rmd
	Rscript -e "rmarkdown::render('$<', output_file = '$*', \
	                              output_dir = '$(@D)')

# ------------------------------------------------------------------------------

default: $(TARGETLIST)
