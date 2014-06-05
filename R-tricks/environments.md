


Instead of 


```r
options(FlickrKey = "XXXXXX-XXX-XXXX")
key = getOption("FlickrKey")
```



We can use environments


```r
Sys.setenv(FlickrKey = "XXXXXX-XXX-XXXX")
key = Sys.getenv("FlickrKey")
```


Note that it seems the object needs to be a string (otherwise is coaxed into one):


```r
f = function(x) 2 * x
b = 5
Sys.setenv(test_function = f, a = b)
Sys.getenv("test_function")
```

```
## [1] "function (x) \n2 * x"
```

```r
class(g)
```

```
## Error: object 'g' not found
```

```r
Sys.getenv("a")
```

```
## [1] "5"
```


A much better way to do this:


```r
myenv <- new.env(hash = TRUE)
assign("test_function", f, envir = myenv)
get("test_function", envir = myenv)
```

```
## function(x) 2 * x
```


Create environment for the package by adding scripts (rather than functions) to a `zzz.R` file in R.  Will be run when the package is loaded.  

