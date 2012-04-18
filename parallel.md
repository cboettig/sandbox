# Parallelization on High-Performance Clusters in R


## RMPI

The direct Rmpi way:



```r
library(Rmpi)
mpi.spawn.Rslaves(nslaves = 15)
```



```
## 	15 slaves are spawned successfully. 0 failed.
## master  (rank 0 , comm 1) of size 16 is running on: c0-9 
## slave1  (rank 1 , comm 1) of size 16 is running on: c0-9 
## slave2  (rank 2 , comm 1) of size 16 is running on: c0-9 
## slave3  (rank 3 , comm 1) of size 16 is running on: c0-9 
## ... ... ...
## slave14 (rank 14, comm 1) of size 16 is running on: c0-9 
## slave15 (rank 15, comm 1) of size 16 is running on: c0-9 
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
## $slave4
## [1] "Hello from 4"
## 
## $slave5
## [1] "Hello from 5"
## 
## $slave6
## [1] "Hello from 6"
## 
## $slave7
## [1] "Hello from 7"
## 
## $slave8
## [1] "Hello from 8"
## 
## $slave9
## [1] "Hello from 9"
## 
## $slave10
## [1] "Hello from 10"
## 
## $slave11
## [1] "Hello from 11"
## 
## $slave12
## [1] "Hello from 12"
## 
## $slave13
## [1] "Hello from 13"
## 
## $slave14
## [1] "Hello from 14"
## 
## $slave15
## [1] "Hello from 15"
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
cluster <- makeCluster(16, type = "MPI")
```



```
## 	16 slaves are spawned successfully. 0 failed.
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
## [[5]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[6]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[7]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[8]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[9]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[10]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[11]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[12]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[13]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[14]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[15]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
## [[16]]
## [1] "snow"      "Rmpi"      "methods"   "stats"     "graphics"  "grDevices"
## [7] "utils"     "datasets"  "base"     
## 
```



```r
clusterExport(cluster, ls())  # export everything
out <- parSapply(cluster, 1:16, function(x) print(paste("snow hello from ", 
    x)))
print(out)
```



```
##  [1] "snow hello from  1"  "snow hello from  2"  "snow hello from  3" 
##  [4] "snow hello from  4"  "snow hello from  5"  "snow hello from  6" 
##  [7] "snow hello from  7"  "snow hello from  8"  "snow hello from  9" 
## [10] "snow hello from  10" "snow hello from  11" "snow hello from  12"
## [13] "snow hello from  13" "snow hello from  14" "snow hello from  15"
## [16] "snow hello from  16"
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
sfInit(parallel = TRUE, cpus = 16)
```



```
## R Version:  R version 2.15.0 (2012-03-30) 
## 
```



```
## snowfall 1.84 initialized (using snow 0.3-8): parallel execution on 16 CPUs.
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
out <- sfSapply(1:16, function(x) print(paste("snow hello from ", 
    x)))
print(out)
```



```
##  [1] "snow hello from  1"  "snow hello from  2"  "snow hello from  3" 
##  [4] "snow hello from  4"  "snow hello from  5"  "snow hello from  6" 
##  [7] "snow hello from  7"  "snow hello from  8"  "snow hello from  9" 
## [10] "snow hello from  10" "snow hello from  11" "snow hello from  12"
## [13] "snow hello from  13" "snow hello from  14" "snow hello from  15"
## [16] "snow hello from  16"
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
sfInit(parallel = TRUE, cpus = 16, type = "MPI")
sfExportAll()
sfLibrary(utils)
out <- sfSapply(1:16, function(x) print(paste("snow hello from ", 
    x)))
print(out)
sfStop()
```




snow's close command, which shuts down and quits from script.   



```r
mpi.quit(save = "no")
```



