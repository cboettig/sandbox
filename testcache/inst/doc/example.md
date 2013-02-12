# Example of authentication with caching credentials

* Create the file [zzz.R]() that initiates the cache:

```r
AuthCache <- new.env(hash=TRUE)
```


* Create the file [auth.R]() that provides the functions to assign and get from cache: 

```r
#' cache demo fn
#' @export
auth <- 
function(x){
  assign('x', x, envir=AuthCache)
  invisible(x)
} 
```

```r
#' cache demo extract fn
#' @export
get_auth <- 
function(){
  get('x', envir=AuthCache)
} 
```



Note that after loading the package, we can immediately assign and recall from the cache object:


```r
library(testcache)
auth(5)
get_auth()
```

```
## [1] 5
```


Note that while the internal functions can access this cache just fine, we cannot access the cache object directly ourselves (just as we cannot access internal functions without prepending the namespace).  

This fails:


```r
get("x", envir = AuthCache)
```

```
## Error: object 'AuthCache' not found
```


While this works.  


```r
get("x", envir = testcache:::AuthCache)
```

```
## [1] 5
```



