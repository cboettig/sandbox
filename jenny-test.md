# Binding a list of lists
Jenny Bryan  
12 January, 2015  

I want to convert a list of lists into another list of lists through ... catenation or binding? Hard to describe in words -- easier to illustrate.

FWIW, in real life, I make a sequence of requests to an API, traversing all possible pages of results. Each `GET` request yields a list representing the data for one page, with components for the content, headers, status code, etc. I want to wrangle the resulting list of lists into something *closer to what I would have gotten in the absence of pagination*.

I illustrate with a simpler example that has nothing to do with an API. Here's a picture, but there's R code below:

![](/dates.png)

`x` is the input list of lists, with two conformable components, `april` and `july`.


```r
library(plyr)
library(magrittr)

x <-
  list(april = list(n_days = 30,
                    holidays = list(list("2015-04-01", "april fools"),
                                    list("2015-04-05", "easter")),
                    month_info = c(number = "4", season = "spring")),
       july = list(n_days = 31,
                   holidays = list(list("2014-07-04", "july 4th")),
                   month_info = c(number = "7", season = "summer"))) %T>% str
```

```
## List of 2
##  $ april:List of 3
##   ..$ n_days    : num 30
##   ..$ holidays  :List of 2
##   .. ..$ :List of 2
##   .. .. ..$ : chr "2015-04-01"
##   .. .. ..$ : chr "april fools"
##   .. ..$ :List of 2
##   .. .. ..$ : chr "2015-04-05"
##   .. .. ..$ : chr "easter"
##   ..$ month_info: Named chr [1:2] "4" "spring"
##   .. ..- attr(*, "names")= chr [1:2] "number" "season"
##  $ july :List of 3
##   ..$ n_days    : num 31
##   ..$ holidays  :List of 1
##   .. ..$ :List of 2
##   .. .. ..$ : chr "2014-07-04"
##   .. .. ..$ : chr "july 4th"
##   ..$ month_info: Named chr [1:2] "7" "summer"
##   .. ..- attr(*, "names")= chr [1:2] "number" "season"
```

`y`, below, is indicative of my desired output, though I'm flexible on details like (row) names, matrix vs. data.frame, etc. I want to catenate or bind each component, such as `n_days` or `holidays`, across all the months.


```r
y <- list(n_days = c(april = 30, july = 31),
          holidays = list(list("2015-04-01", "april fools"),
                          list("2015-04-05", "easter"),
                          list("2014-07-04", "july 4th")),
          month_info = cbind(april = c(number = "4", season = "spring"),
                             july = c(number = "7", season =
                                        "summer"))) %T>% str
```

```
## List of 3
##  $ n_days    : Named num [1:2] 30 31
##   ..- attr(*, "names")= chr [1:2] "april" "july"
##  $ holidays  :List of 3
##   ..$ :List of 2
##   .. ..$ : chr "2015-04-01"
##   .. ..$ : chr "april fools"
##   ..$ :List of 2
##   .. ..$ : chr "2015-04-05"
##   .. ..$ : chr "easter"
##   ..$ :List of 2
##   .. ..$ : chr "2014-07-04"
##   .. ..$ : chr "july 4th"
##  $ month_info: chr [1:2, 1:2] "4" "spring" "7" "summer"
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:2] "number" "season"
##   .. ..$ : chr [1:2] "april" "july"
```

I can of course do with brute force. But it isn't a great starting place for a general solution to the actual problem, which is catenating across pages returned by an API.


```r
brute_force_y <-
  list(n_days = laply(x, `[[`, "n_days"),
       holidays = llply(x, `[[`, "holidays") %>% unlist(recursive = FALSE),
       month_info = lapply(x, function(z) z[["month_info"]] %>% unlist) %>%
         do.call("cbind", .))

## agree up to naming stuff
all.equal(y, brute_force_y)
```

```
## [1] "Component \"n_days\": names for target but not for current"  
## [2] "Component \"holidays\": names for current but not for target"
```

Feels like there must be some way to do this with `mapply()` or `tidyr` or ???

Is there a (better) name for what I am trying to do? Is this close to some pre-existing  workflow that I could exploit by approaching differently?
