


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


Note that it seems the object needs to be a string:


```r
f = function(x) 2 * x
b = 5
Sys.setenv(test_function = f, a = b, m = 5)
Sys.getenv("test_function")
```

```
## [1] "function (x) \n2 * x"
```

```r
class(g)
```

```
## [1] "character"
```

```r
Sys.getenv("a", "m")
```

```
## [1] "5"
```

