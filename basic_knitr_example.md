

Knitr Basic Example
===================

How do I have a random number be reproducible?



```r
set.seed(123)
rnorm(10)
```



```
##  [1] -0.56048 -0.23018  1.55871  0.07051  0.12929  1.71506  0.46092
##  [8] -1.26506 -0.68685 -0.44566
```





Make cool graphics we can share the code for.  We'll use some inline code to turn on `knitr's` upload function: 




```r
library(ggplot2)
qplot(hp, mpg, data = mtcars) + geom_smooth()
```



```
## geom_smooth: method="auto" and size of largest group is <1000, so using loess. Use 'method = x' to change the smoothing method.
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-21.png) 

```r
ggpcp(mtcars) + geom_line()
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-22.png) 




## Libraries

These libraries will load without printing any messages to the output. 



```r
library(knitr)
library(geiger)
```




Check out [knitr home page](https://knitr.github.com) for details. 
