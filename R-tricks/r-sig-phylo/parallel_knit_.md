<!--roptions dev="png", fig.width=7, fig.height=5, tidy=FALSE, warning=FALSE, comment=NA, message=FALSE-->

## Parellelize Diversitree 
(an r-sig-phylo question)


<!--begin.rcode echo=FALSE 
render_gfm()
opts_knit$set(upload = TRUE)
## use flickr to upload with these options
require(socialR)
opts_knit$set(upload.fun = flickr.url)
end.rcode-->




Start up some parallelization.  Note that we need to export any variables we have to the cluster, as well as the function library: 
<!--begin.rcode 
library(snowfall)
sfInit(parallel=TRUE, cpu=4)
sfLibrary(diversitree)
end.rcode-->
This sets us up to run on a 4 core machine. If we instead had a cluster of, say, 4 machines each with 4 cores, we'd do the same command but with the MPI mode, for clusters, now with 16 cpus:
<!--begin.rcode eval=FALSE
sfInit(parallel=TRUE, cpu=16, type="MPI")
end.rcode-->


Now we can use the parallel versions of the apply commands to send our job across many nodes on different clusters, etc.


Imagine we have a list of phylogenies, `phy_list`, to which we want to fit the basic bisse model.

<!--begin.rcode 
  set.seed(4)
  pars <- c(0.1, 0.2, 0.03, 0.03, 0.01, 0.01)
  phy <- tree.bisse(pars, max.t=30, x0=0)
  phy2 <- tree.bisse(pars, max.t=60, x0=0)
  phy_list <- list(phy, phy2)
end.rcode-->

We export this data to the cluster,
<!--begin.rcode 
sfExportAll()
end.rcode-->

and we can loop over every element in this list in parallel: 
<!--begin.rcode 
sfLapply(phy_list, function(phy){
     lik <- make.bisse(phy, phy$tip.state)
     ## Heuristic guess at a starting point, based on the constant-rate
     ## birth-death model 
     p <- starting.point.bisse(phy)
     ## Start an ML search from this point.  
     fit <- find.mle(lik, p, method="subplex")
     })
end.rcode-->

(Since there are only two trees in this example, only two cores are useful). 


## endmatter
 * Author: Carl Boettiger <cboettig@gmail.com>
 * License: CC0

brought to you with knitr for markdown and github.
