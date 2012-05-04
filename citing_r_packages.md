


[code lang='r']
require(socialR)
[/code]
[code lang='r']
Loading required package: socialR
[/code]
[code lang='r']
render_wordpress()
[/code]




Many studies using R require additional packages, but citations to R often fail to cite the packages seperately, even when they mention the base R. R makes it rather easy to get the citation information for any package
[code lang='r']
citation("ouch")
[/code]
[code lang='r']

To cite the ouch package in publications
use:

  Aaron A. King and Marguerite A. Butler
  (2009), ouch: Ornstein-Uhlenbeck models
  for phylogenetic comparative hypotheses (R
  package),
  http://ouch.r-forge.r-project.org

  Butler, M. A. and King, A. A. (2004)
  Phylogenetic comparative analysis: a
  modeling approach for adaptive evolution
  Am. Nat. 164:683--695

As ouch is continually evolving, you may
want to cite its version number. Find it
with 'help(package=ouch)'.

[/code]



Can I have that in bibtex format please?
[code lang='r']
toBibtex(citation("ouch"))
[/code]
[code lang='r']
@Manual{,
  title = {ouch: Ornstein-Uhlenbeck models for phylogenetic comparative hypotheses},
  author = {Aaron A. King and Marguerite A. Butler},
  year = {2009},
  url = {http://ouch.r-forge.r-project.org},
}

@Article{,
  author = {Marguerite A. Butler and Aaron A. King},
  title = {Phylogenetic comparative analysis: a modeling approach for adaptive evolution},
  journal = {American Naturalist},
  year = {2004},
  volume = {164},
  pages = {683--695},
  url = {http://www.journals.uchicago.edu/AN/journal/issues/v164n6/40201/40201.html},
}
[/code]



Notice that this package provides the citation information for both the package and the associated journal article simultaneously, and R has successfully identified the formats as 'Manual' and 'Article' respectively. 


After running your code, consider creating a custom bibtex file containing the citation information for all the packages you have just used.  (The file can abe imported into most citation managers, if LaTeX isn't your thing).
[code lang='r']
sink("test.bib")
out <- sapply(names(sessionInfo()$otherPkgs), 
    function(x) print(citation(x), style = "Bibtex"))
[/code]
[code lang='r']
@Manual{,
  title = {socialR: Social functions for R},
  author = {Carl Boettiger},
  year = {2010},
  note = {R package version 0.0-1},
}
@Manual{,
  title = {knitr: A general-purpose package for dynamic report
generation in R},
  author = {Yihui Xie},
  year = {2012},
  note = {R package version 0.3.2},
  url = {http://yihui.name/knitr/},
}
[/code]
[code lang='r']
sink()
[/code]



A list of the loaded packages in LaTeX format can be loaded using
[code lang='r']
toLatex(sessionInfo(), locale = FALSE)
[/code]
[code lang='r']
\begin{itemize}\raggedright
  \item R version 2.14.2 (2012-02-29), \verb|x86_64-pc-linux-gnu|
  \item Base packages: base, datasets,
    grDevices, graphics, stats, utils
  \item Other packages: knitr~0.3.2,
    socialR~0.0-1
  \item Loaded via a namespace (and not
    attached): RCurl~1.91-1,
    RWordPress~0.2-1, Rcpp~0.9.10,
    Rflickr~0.2-1, XML~3.9-4, XMLRPC~0.2-5,
    codetools~0.2-8, digest~0.5.1,
    evaluate~0.4.1, formatR~0.3-4,
    highlight~0.3.1, methods~2.14.2,
    parser~0.0-14, plyr~1.7.1, stringr~0.6,
    tools~2.14.2
\end{itemize}
[/code]




### For package authors
R will attempt to automatically construct the citation information for the package automatically from the description file, so it is not strictly necessary to do anything to your package to create it. Note that R has recently adopted a new syntax to specify the authors, which is a bit more precise.  Instead of `Authors:` in the description, use `Authors@R:` followed by R code such as
[code lang='r']
c(person("Carl", "Boettiger", 
    role = c("aut", "cre"), email = "cboettig@gmail.com"), 
    person("Duncan", "Temple Lang", role = "aut"))
[/code]
[code lang='r']
[1] "Carl Boettiger <cboettig@gmail.com> [aut, cre]"
[2] "Duncan Temple Lang [aut]"                      
[/code]


This defines the roles (author, creator, etc, see `?person` for details), and 'creator' takes the place of the `Maintainer:` designation, and requires an email address. If you wish to add an additional publication as part of the citation information (such as the example from `ouch` above, 
you can specify this in the CITATION file. For the example this looks like:
[code lang='r']
citHeader("To cite the ouch package in publications use:")
[/code]
[code lang='r']
[1] "To cite the ouch package in publications use:"
attr(,"class")
[1] "citationHeader"
[/code]
[code lang='r']

citEntry(entry = "Manual", 
    title = "ouch: Ornstein-Uhlenbeck models for phylogenetic comparative hypotheses", 
    author = personList(as.person("Aaron A. King"), 
        as.person("Marguerite A. Butler")), 
    year = 2009, url = "http://ouch.r-forge.r-project.org", 
    textVersion = paste("Aaron A. King and Marguerite A. Butler (2009),", 
        "ouch: Ornstein-Uhlenbeck models for phylogenetic comparative hypotheses (R package),", 
        "http://ouch.r-forge.r-project.org"))
[/code]
[code lang='r']
King AA and Butler MA (2009). _ouch: Ornstein-Uhlenbeck models for
phylogenetic comparative hypotheses_. <URL:
http://ouch.r-forge.r-project.org>.
[/code]
[code lang='r']

citEntry(entry = "Article", 
    author = personList(as.person("Marguerite A. Butler"), 
        as.person("Aaron A. King")), title = "Phylogenetic comparative analysis: a modeling approach for adaptive evolution", 
    journal = "American Naturalist", year = 2004, 
    volume = 164, pages = "683--695", 
    url = "http://www.journals.uchicago.edu/AN/journal/issues/v164n6/40201/40201.html", 
    textVersion = paste("Butler, M. A. and King, A. A. (2004)", 
        "Phylogenetic comparative analysis: a modeling approach for adaptive evolution", 
        "Am. Nat. 164:683--695"))
[/code]
[code lang='r']
Butler MA and King AA (2004). "Phylogenetic comparative analysis: a
modeling approach for adaptive evolution." _American Naturalist_,
*164*, pp. 683-695. <URL:
http://www.journals.uchicago.edu/AN/journal/issues/v164n6/40201/40201.html>.
[/code]
[code lang='r']
citFooter("As ouch is continually evolving, you may want to cite its version number. Find it with 'help(package=ouch)'.")
[/code]
[code lang='r']
[1] "As ouch is continually evolving, you may want to cite its version number. Find it with 'help(package=ouch)'."
attr(,"class")
[1] "citationFooter"
[/code]



(It seems like there should be a simple way to generate this automatically from the bibtex format, but I haven't discovered it.)

### R as a citation tool
 * OAI-Harvester
 * Crossref API -- format as an R bibentry 

 * knitr citations: identify dois and pull citation info.  Or run through bibtex and convert to html?


