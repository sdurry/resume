.PHONY: build_html

build:
	docker build -t my-resume .

run:
	docker run -e PASSWORD=12345 --rm -p 8787:8787 -e ROOT=TRUE my-resume

render_html:
	R -e "rmarkdown::render('resume.Rmd',output_file='resume.html')"
	open resume.html
