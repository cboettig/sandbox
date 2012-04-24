# Parallelization on High-Performance Clusters in R


## RMPI

The direct Rmpi way:



```r
library(Rmpi)
mpi.spawn.Rslaves(nslaves = 3)
```



```
## 	3 slaves are spawned successfully. 0 failed.
## master (rank 0, comm 1) of size 4 is running on: c0-18 
## slave1 (rank 1, comm 1) of size 4 is running on: c0-18 
## slave2 (rank 2, comm 1) of size 4 is running on: c0-18 
## slave3 (rank 3, comm 1) of size 4 is running on: c0-18 
```



```r
slavefn <- function() {
    print(paste("Hello from", foldNumber))
}
mpi.bcast.cmd(foldNumber <- mpi.comm.rank())
mpi.bcast.Robj2slave(slavefn)
result <- mpi.remote.exec(slavefn())
print(result)
```



```
## $slave1
## [1] "Hello from 1"
## 
## $slave2
## [1] "Hello from 2"
## 
## $slave3
## [1] "Hello from 3"
## 
```



```r
mpi.close.Rslaves()
```



```
## [1] 1
```




## SNOW



```r
library(snow)
cluster <- makeCluster(4, type = "MPI")
```



```
## 	4 slaves are spawned successfully. 0 failed.
```



```r
clusterEvalQ(cluster, library(utils))  # load a library
```



```
## [[1]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[2]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[3]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[4]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
```



```r
clusterExport(cluster, ls())  # export everything
out <- parSapply(cluster, 1:4, function(x) print(paste("snow hello from ", 
    x)))
print(out)
```



```
## [1] "snow hello from  1" "snow hello from  2" "snow hello from  3"
## [4] "snow hello from  4"
```



```r
stopCluster(cluster)
```



```
## [1] 1
```




## SNOWFALL 
(default "SOCK" type, for multicore machines).



```r
library(snowfall)
sfInit(parallel = TRUE, cpus = 4)
```



```
## R Version:  R version 2.15.0 (2012-03-30) 
## 
```



```
## snowfall 1.84 initialized (using snow 0.3-8): parallel execution on 4 CPUs.
## 
```



```r
sfExportAll()
sfLibrary(utils)
```



```
## Library utils loaded.
```



```
## Library utils loaded in cluster.
## 
```



```
## Warning message: 'keep.source' is deprecated and will be ignored
```



```r
out <- sfSapply(1:4, function(x) print(paste("snow hello from ", 
    x)))
print(out)
```



```
## [1] "snow hello from  1" "snow hello from  2" "snow hello from  3"
## [4] "snow hello from  4"
```



```r
sfStop()
```



```
## 
## Stopping cluster
## 
```




Snowfall using MPI mode, for distributing across nodes in a cluster (that use a shared hard disk but don't share memory).



```r
library(snowfall)
sfInit(parallel = TRUE, cpus = 4, type = "MPI")
sfExportAll()
sfLibrary(utils)
out <- sfSapply(1:4, function(x) print(paste("snow hello from ", 
    x)))
print(out)
sfStop()
```



For reasons unknown to me, this last command does not work on farm, though it works fine on NERSC cluster.  

snow's close command, which shuts down and quits from script.   



```r
mpi.quit(save = "no")
```



