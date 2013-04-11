

# Segue = MapReduce + Hadoop + Amazon EC2 + R

`Segue` is an R package by JD Long which will let you run your script across hundreds of computers in the Amazon compute cloud.  
This parallel execution uses Amazon's Elastic Map Reduce to work across many clusters, but that's all behind the scenes.  


## Install

JD hosts the project on [GoogleCode](http://code.google.com/p/segue/), but since we're focused on git in this class I've [created a copy on github](https://github.com/cboettig/segue).  Clone and install the copy using:

```
git clone https://cboettig@github.com/cboettig/segue.git
cd segue
R CMD INSTALL .
```

Or if you have the [`devtools` package](https://github.com/hadley/devtools) installed,

```
library(devtools)
install_github("segue", "cboettig")
```

You'll also need to setup a cloud computing account with Amazon if you haven't done so yet.  Instructions for this are below, but let's first take a quick look at how easy this makes it to launch an Amazon cloud instance and run some code.  If you're already familiar with creating Amazon instances, logging into them, and running R, this will actually seem even more impressive:



## A simple R example

(All R code here is in knitr, so it is actually run and generates the output you see).  
Let's illustrate this with a little likelihood routine.  Create some data, a likelihood function, and two possible parameter values we want to try out.  




```r
X <- rnorm(20, 2, 5)
loglik <- function(pars) {
    sum(dnorm(X, mean = pars[1], sd = pars[2], log = TRUE))
}
prior <- function(pars) {
    1/pars[2]^2
}
pars <- list(c(mu = 1, sigma = 2), c(mu = 2, sigma = 3))
```




Let's make sure method works locally before we go testing this on the cloud.  



```r
local <- lapply(list(1, 2), function(i) {
    loglik(pars[[i]])
})
```




Load the library and establish our login credentials.  



```r
library(segue)
```



```
Loading required package: rJava
```



```
Loading required package: caTools
```



```
Loading required package: bitops
```



```
Segue did not find your AWS credentials. Please run the setCredentials() function.
```



```r
source("~/.Ramazon_keys")
setCredentials(getOption("amazon_key"), getOption("amazon_secret"))
```



```

Enter a frame number, or 0 to exit   

 1: knit("segue.Rmd")
 2: process_file(text)
 3: try((if (tangle) process_tangle else process_group)(group), silent = T
 4: tryCatch(expr, error = function(e) {
    call <- conditionCall(e)
    if
 5: tryCatchList(expr, classes, parentenv, handlers)
 6: tryCatchOne(expr, names, parentenv, handlers[[1]])
 7: doTryCatch(return(expr), name, parentenv, handler)
 8: (if (tangle) process_tangle else process_group)(group)
 9: process_group.block(group)
10: call_block(x)
11: block_exec(params)
12: evaluate(code, envir = env)
13: unlist(mapply(eval.with.details, parsed$expr, parsed$src, MoreArgs = l
14: mapply(eval.with.details, parsed$expr, parsed$src, MoreArgs = list(env
15: function (expr, envir = parent.frame(), enclos = NULL, src = NULL, deb
16: try(ev <- withCallingHandlers(withVisible(eval(expr, envir, enclos)), 
17: tryCatch(expr, error = function(e) {
    call <- conditionCall(e)
    if
18: tryCatchList(expr, classes, parentenv, handlers)
19: tryCatchOne(expr, names, parentenv, handlers[[1]])
20: doTryCatch(return(expr), name, parentenv, handler)
21: withCallingHandlers(withVisible(eval(expr, envir, enclos)), warning = 
22: withVisible(eval(expr, envir, enclos))
23: eval(expr, envir, enclos)
24: eval(expr, envir, enclos)
25: setCredentials(getOption("amazon_key"), getOption("amazon_secret"))
26: new(com.amazonaws.auth.BasicAWSCredentials, awsAccessKeyText, awsSecre

```



```
Error: error in evaluating the argument 'Class' in selecting a method for function 'new': Error: object 'com.amazonaws.auth.BasicAWSCredentials' not found

```






Create a cluster on Amazon -- this will start charge your account by the hour.  
Note that we have to specify in this call the R objects we want to load onto the Amazon computers, along with any packages we might need 





```r
myCluster <- createCluster(numInstances = 2, cranPackages = c("sde"), 
    rObjectsOnNodes = list(X = X, pars = pars, loglik = loglik))
```




The "Elastic Map Reduce" version of the `lapply` function works in almost same way as the standard `lapply`:



```r
cloud <- emrlapply(myCluster, as.list(1, 2), function(i) {
    loglik(pars[[i]])
})

stopCluster(myCluster)
```




The final command stop the cluster to make sure we're not being billed after the our task is done.  That's all there is to it.  Let's compare the results:



```r
local
```



```
[[1]]
[1] -73.19

[[2]]
[1] -59.94

```



```r
# cloud
```





## Configure Amazon
If you've already set up an Amazon EC2 account, the easiest thing to do is do store your Amazon key and Amazon secret key in a secure R script on your computer which stores these as `options`. 


