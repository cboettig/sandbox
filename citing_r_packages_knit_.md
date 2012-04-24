<!--roptions comment=NA-->


<!--begin.rcode setup
require(socialR)
render_wordpress()  
end.rcode-->


Many studies using R require additional packages, but citations to R often fail to cite the packages seperately, even when they mention the base R. R makes it rather easy to get the citation information for any package
<!--begin.rcode
citation("ouch")
end.rcode-->

Can I have that in bibtex format please?
<!--begin.rcode
toBibtex(citation("ouch"))
end.rcode-->

Notice that this package provides the citation information for both the package and the associated journal article simultaneously, and R has successfully identified the formats as 'Manual' and 'Article' respectively. 


After running your code, consider creating a custom bibtex file containing the citation information for all the packages you have just used.  (The file can abe imported into most citation managers, if LaTeX isn't your thing).
<!--begin.rcode
sink("test.bib") 
out <- sapply(names(sessionInfo()$otherPkgs), function(x) print(citation(x), style="Bibtex"))
sink()
end.rcode-->

A list of the loaded packages in LaTeX format can be loaded using
<!--begin.rcode
   toLatex(sessionInfo(), locale=FALSE)
end.rcode-->


### For package authors
R will attempt to automatically construct the citation information for the package automatically from the description file, so it is not strictly necessary to do anything to your package to create it. Note that R has recently adopted a new syntax to specify the authors, which is a bit more precise.  Instead of `Authors:` in the description, use `Authors@R:` followed by R code such as
<!--begin.rcode
c(person("Carl", "Boettiger", role = c("aut", "cre"),
    email = "cboettig@gmail.com"),
  person("Duncan", "Temple Lang", role = "aut"))
end.rcode-->
This defines the roles (author, creator, etc, see `?person` for details), and 'creator' takes the place of the `Maintainer:` designation, and requires an email address. If you wish to add an additional publication as part of the citation information (such as the example from `ouch` above, 
you can specify this in the CITATION file. For the example this looks like:
<!--begin.rcode
citHeader("To cite the ouch package in publications use:")

citEntry(
         entry="Manual",
         title="ouch: Ornstein-Uhlenbeck models for phylogenetic comparative hypotheses",
         author=personList(
     as.person("Aaron A. King"),
     as.person("Marguerite A. Butler")
     ),    
   year=2009,
   url="http://ouch.r-forge.r-project.org",
   textVersion=paste(
     "Aaron A. King and Marguerite A. Butler (2009),",
     "ouch: Ornstein-Uhlenbeck models for phylogenetic comparative hypotheses (R package),",
     "http://ouch.r-forge.r-project.org"
     )     
         )

citEntry(
         entry="Article",
         author=personList(
           as.person("Marguerite A. Butler"),
           as.person("Aaron A. King")
           ),
         title="Phylogenetic comparative analysis: a modeling approach for adaptive evolution",
         journal="American Naturalist",
         year=2004,
         volume=164,
         pages="683--695",
         url="http://www.journals.uchicago.edu/AN/journal/issues/v164n6/40201/40201.html",
         textVersion=paste(
           "Butler, M. A. and King, A. A. (2004)",
           "Phylogenetic comparative analysis: a modeling approach for adaptive evolution",
           "Am. Nat. 164:683--695"
           )
         )
citFooter("As ouch is continually evolving, you may want to cite its version number. Find it with 'help(package=ouch)'.")
end.rcode-->

(It seems like there should be a simple way to generate this automatically from the bibtex format, but I haven't discovered it.)

### R as a citation tool
 * OAI-Harvester
 * Crossref API -- format as an R bibentry 

 * knitr citations: identify dois and pull citation info.  Or run through bibtex and convert to html?


