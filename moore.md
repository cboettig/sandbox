

Consider a quick example matrix


```r
M <- matrix(rnorm(96), nrow = 8)  #  12 by 8
```


The neighborhood you describe is what we call the [Moore Neighborhood]()  We can generalize it to a Manhattan radius `r` giving the number of cells to go out.  Implementing from the definition, first let us grab a random cell:




```r
i <- sample(1:dim(M)[1], 1)  # 1 random number between 1 and 12
j <- sample(1:dim(M)[2], 1)  # another random number between 1 and 8
```


And then grab all the points in the Moore neighborhood 


```r
r <- 1
neighborhood <- cbind(c(i - r, i, i + r, i - r, i, i + r, i - r, i, i + r), 
    c(j - r, j - r, j - r, j, j, j, j + r, j + r, j + r))
```


We can then access the cells from M in our neighborhood.  We tell R to display these points as a matrix 


```r
matrix(M[neighborhood], nrow = 3)
```

```
## Error: subscript out of bounds
```


 In general there are concerns about what to do when `i,j` sits at the boundary.  One option is to wrap that around the edge (effectively treating things like a torus).  We use the modulus function, `%%`.  We add and subtract `1` because this trick works by indexing vectors starting with 0, not 1:


```r
wrapped_neighborhood <- neighborhood
wrapped_neighborhood[, 1] <- (neighborhood[, 1] - 1)%%dim(M)[1] + 1
wrapped_neighborhood[, 2] <- (neighborhood[, 2] - 1)%%dim(M)[2] + 1
```



This can be extended to $r > 1$. 


```r
r_max <- 3
rows <- numeric(0)
cols <- numeric(0)

for (r in 1:r_max) {
    rows <- c(rows, c(i - r, i, i + r, i - r, i, i + r, i - r, i, i + r))
    cols <- c(cols, c(j - r, j - r, j - r, j, j, j, j + r, j + r, j + r))
}

neighborhood <- cbind(rows, cols)
neighborhood
```

```
##       rows cols
##  [1,]    7    3
##  [2,]    8    3
##  [3,]    9    3
##  [4,]    7    4
##  [5,]    8    4
##  [6,]    9    4
##  [7,]    7    5
##  [8,]    8    5
##  [9,]    9    5
## [10,]    6    2
## [11,]    8    2
## [12,]   10    2
## [13,]    6    4
## [14,]    8    4
## [15,]   10    4
## [16,]    6    6
## [17,]    8    6
## [18,]   10    6
## [19,]    5    1
## [20,]    8    1
## [21,]   11    1
## [22,]    5    4
## [23,]    8    4
## [24,]   11    4
## [25,]    5    7
## [26,]    8    7
## [27,]   11    7
```


Once again we have to deal with boundary cases, e.g. wrapping as before:  


```r
wrapped_neighborhood <- neighborhood
wrapped_neighborhood[, 1] <- (neighborhood[, 1] - 1)%%dim(M)[1] + 1
wrapped_neighborhood[, 2] <- (neighborhood[, 2] - 1)%%dim(M)[2] + 1
wrapped_neighborhood
```

```
##       rows cols
##  [1,]    7    3
##  [2,]    8    3
##  [3,]    1    3
##  [4,]    7    4
##  [5,]    8    4
##  [6,]    1    4
##  [7,]    7    5
##  [8,]    8    5
##  [9,]    1    5
## [10,]    6    2
## [11,]    8    2
## [12,]    2    2
## [13,]    6    4
## [14,]    8    4
## [15,]    2    4
## [16,]    6    6
## [17,]    8    6
## [18,]    2    6
## [19,]    5    1
## [20,]    8    1
## [21,]    3    1
## [22,]    5    4
## [23,]    8    4
## [24,]    3    4
## [25,]    5    7
## [26,]    8    7
## [27,]    3    7
```




What if we wanted to wrap just the neighborhood if we hit the boundary?


```r
wrap <- function(k, r, n) {
    if (k < 1) 
        k <- k + r - (k - 1)
    if (k > n) 
        k <- k - r - (k - n)
    k
}
```


Apply this function to the rows/columns


```r
wrapped_neighborhood <- neighborhood
wrapped_neighborhood[, 1] <- sapply(neighborhood[, 1], wrap, r, dim(M)[1])
wrapped_neighborhood[, 2] <- sapply(neighborhood[, 2], wrap, r, dim(M)[2])
wrapped_neighborhood
```

```
##       rows cols
##  [1,]    7    3
##  [2,]    8    3
##  [3,]    5    3
##  [4,]    7    4
##  [5,]    8    4
##  [6,]    5    4
##  [7,]    7    5
##  [8,]    8    5
##  [9,]    5    5
## [10,]    6    2
## [11,]    8    2
## [12,]    5    2
## [13,]    6    4
## [14,]    8    4
## [15,]    5    4
## [16,]    6    6
## [17,]    8    6
## [18,]    5    6
## [19,]    5    1
## [20,]    8    1
## [21,]    5    1
## [22,]    5    4
## [23,]    8    4
## [24,]    5    4
## [25,]    5    7
## [26,]    8    7
## [27,]    5    7
```



Note that this does not handle the case of a neighborhood that is larger than the matrix in some dimension; e.g. we don't guarentee `i+r+1<n`, etc.  

