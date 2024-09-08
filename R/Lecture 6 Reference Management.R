install.packages(c("bibtex", "RefManageR"))

#Generate citation text for rmarkdown package by using the following command
citation("rmarkdown")

#Just examine first citation in the list
citation("rmarkdown")[1]

knitr::write_bib("rmarkdown", file = "my-refs.bib")

list.files()


