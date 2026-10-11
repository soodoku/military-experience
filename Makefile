.PHONY: install build test check

install:
	Rscript -e 'install.packages(c("ggplot2", "knitr"), repos = "https://cloud.r-project.org")'

build:
	Rscript scripts/build.R

test:
	Rscript tests/check.R

check: test build
