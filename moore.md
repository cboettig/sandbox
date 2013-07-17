

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

```
r <- 1
neighborhood <- 
cbind(c(i-r, i,   i+r, i-r, i,  i+r,  i-r, i,   i+r),
      c(j-r, j-r, j-r, j,   j,  j,    j+r, j+r, j+r))
```

We can then access the cells from M in our neighborhood.  We tell R to display these points as a matrix 


```r
matrix(M[neighborhood], nrow = 3)
```

```
## Error: object 'neighborhood' not found
```


 In general there are concerns about what to do when `i,j` sits at the boundary.  One option is to wrap that around the edge (effectively treating things like a torus).  We use the modulus function, `%%`.  We add and subtract `1` because this trick works by indexing vectors starting with 0, not 1:


```r
wrapped_neighborhood <- neighborhood
```

```
## Error: object 'neighborhood' not found
```

```r
wrapped_neighborhood[, 1] <- (neighborhood[, 1] - 1)%%dim(M)[1] + 1
```

```
## Error: object 'neighborhood' not found
```

```r
wrapped_neighborhood[, 2] <- (neighborhood[, 2] - 1)%%dim(M)[2] + 1
```

```
## Error: object 'neighborhood' not found
```



Clearly this can be extended to $r > 1$. 

```
r_max <- 3
rows <- numeric(0)
cols <- numeric(0)

for(r in 1:r_max){
 rows <- c(rows, c(i-r, i,   i+r, i-r, i,  i+r,  i-r, i,   i+r))
 cols <- c(cols, c(j-r, j-r, j-r, j,   j,  j,    j+r, j+r, j+r))
} 

neighborhood <- cbind(rows, cols)
```







