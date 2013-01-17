

One of the great things about knitr is its flexibility.  Here I set knitr up to publish to Wordpress.
I will then use RWordPress to publish the output automatically.   

I will base the wordpress format on the github-flavored markdown format.  I change the markup for output and source-code to use the nice codeblocks provided by the syntax highlighter plugin.  I also specify that images should use the html markup instead of github markup, and I will take advantage of knitr support for imgur to upload and host the image files automatically.   



```r
render_gfm()
options(width = 30)
opts_knit$set(upload = TRUE)
knit_hooks$set(output = function(x, options) paste("[code]\n", x, 
    "[/code]\n", sep = ""), source = function(x, options) paste("[code lang='r']\n", 
    x, "[/code]\n", sep = ""), plot = hook_plot_html)
```


Now we write some code chunks in this markdown file:


```r
## a simple calculator
1 + 1
```

```
## [1] 2
```

```r
## boring random numbers
set.seed(123)
rnorm(5)
```

```
## [1] -0.56048 -0.23018  1.55871  0.07051  0.12929
```


We can also produce plots which are uploaded to imgur.com:


```r
library(ggplot2)
qplot(hp, mpg, data = mtcars) + geom_smooth()
```

![plot of chunk md-cars](ex-out-md-cars1.png) 

```r
ggpcp(mtcars) + geom_line()
```

![plot of chunk md-cars](ex-out-md-cars2.png) 



We can then post the result using RWordPress:


```r
require(RWordPress)
text = paste(readLines("wordpress.md"), collapse = "\n")
title = "Using knitr and RWordPress to publish results directly from R"
newPost(list(description = text, title = title), publish = FALSE)
```


Above we specify publish = FALSE which will make the post upload as a draft where we can preview it.  To publish directly we could omit that command.  Giving a title is intuitive. Note that we have to read the text in and substitue newline characters for line-breaks.   

Note that this requires setting the login options securely in .Rprofile, for example:

```r
options(WordpressLogin = c(userid = "password"), WordpressURL = "http://www.yourdomain.com/xmlrpc.php")
```



It would be nice to use the uploadFile function from RWordPress to host the images, but that seems to be giving me trouble at the moment.  


