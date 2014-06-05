

## Parellelize Diversitree 
(an r-sig-phylo question)








Start up some parallelization.  Note that we need to export any variables we have to the cluster, as well as the function library: 


```r
library(snowfall)
sfInit(parallel=TRUE, cpu=4)
sfLibrary(diversitree)
```



```
Library diversitree loaded.
```



This sets us up to run on a 4 core machine. If we instead had a cluster of, say, 4 machines each with 4 cores, we'd do the same command but with the MPI mode, for clusters, now with 16 cpus:


```r
sfInit(parallel=TRUE, cpu=16, type="MPI")
```





Now we can use the parallel versions of the apply commands to send our job across many nodes on different clusters, etc.


Imagine we have a list of phylogenies, `phy_list`, to which we want to fit the basic bisse model.



```r
  set.seed(4)
  pars <- c(0.1, 0.2, 0.03, 0.03, 0.01, 0.01)
  phy <- tree.bisse(pars, max.t=30, x0=0)
  phy2 <- tree.bisse(pars, max.t=60, x0=0)
  phy_list <- list(phy, phy2)
```




We export this data to the cluster,


```r
sfExportAll()
```




and we can loop over every element in this list in parallel: 


```r
sfLapply(phy_list, function(phy){
     lik <- make.bisse(phy, phy$tip.state)
     ## Heuristic guess at a starting point, based on the constant-rate
     ## birth-death model 
     p <- starting.point.bisse(phy)
     ## Start an ML search from this point.  
     fit <- find.mle(lik, p, method="subplex")
     })
```



```
[[1]]
$par
  lambda0   lambda1       mu0       mu1       q01       q10 
1.351e-01 1.778e-01 1.233e-01 3.613e-02 1.472e-06 1.877e-02 

$lnLik
[1] -158.7

$counts
[1] 447

$convergence
[1] 0

$message
NULL

$hessian
NULL

$func
BiSSE likelihood function:
function (pars, condition.surv = TRUE, root = ROOT.OBS, root.p = NULL, 
    intermediates = FALSE) 
{
    check.pars.bisse(pars)
    if (!is.null(root.p) && root != ROOT.GIVEN) 
        warning("Ignoring specified root state")
    if (!is.null(cache$unresolved)) 
        cache$preset <- branches.unresolved.bisse(pars, cache$unresolved)
    if (backend == "CVODES") 
        ll.xxsse.C(pars, all.branches, condition.surv, root, 
            root.p, intermediates)
    else ll.xxsse(pars, cache, initial.conditions.bisse, branches, 
        condition.surv, root, root.p, intermediates)
}
<environment: 0x4369998>

$method
[1] "subplex"

attr(,"class")
[1] "fit.mle.bisse" "fit.mle"      

[[2]]
$par
lambda0 lambda1     mu0     mu1     q01     q10 
0.07586 0.24583 0.03164 0.08693 0.01800 0.00971 

$lnLik
[1] -1122

$counts
[1] 724

$convergence
[1] 0

$message
NULL

$hessian
NULL

$func
BiSSE likelihood function:
function (pars, condition.surv = TRUE, root = ROOT.OBS, root.p = NULL, 
    intermediates = FALSE) 
{
    check.pars.bisse(pars)
    if (!is.null(root.p) && root != ROOT.GIVEN) 
        warning("Ignoring specified root state")
    if (!is.null(cache$unresolved)) 
        cache$preset <- branches.unresolved.bisse(pars, cache$unresolved)
    if (backend == "CVODES") 
        ll.xxsse.C(pars, all.branches, condition.surv, root, 
            root.p, intermediates)
    else ll.xxsse(pars, cache, initial.conditions.bisse, branches, 
        condition.surv, root, root.p, intermediates)
}
<environment: 0x4355e28>

$method
[1] "subplex"

attr(,"class")
[1] "fit.mle.bisse" "fit.mle"      

```






## endmatter
 * Author: Carl Boettiger <cboettig@gmail.com>
 * License: CC0

brought to you with knitr for markdown and github
