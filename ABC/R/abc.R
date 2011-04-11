# @file: abc.R
# @author: Carl Boettiger <cboettig@gmail.com>
# @date: 11 April, 2011
# Description: A trivial example of Approximate Bayesian Computing
# We will simulate under a Gaussian process to determine 

# The target data:
TrueMean <- 0     ## irrelivant note: This is rather a frequentist name, the Bayesian believes these things come from distributions
TrueSD <- 1
Npts <- 100
X <- rnorm(Npts, mean=TrueMean, sd= TrueSD)

# set the target 
s <- c(ObservedMean <- mean(X), ObservedSD <- sd(X))

# This should be done m times, and we then do a regression of these pairs of means and sds: 

# Prior distributions on both parameters 
PriorMean <- rnorm(1, mean=4, sd=100)
PriorSD <- rnorm(1, mean=6, sd=100)

# simulate the process
X_prime <- rnorm(Npts, PriorMean, PriorSD)

# Evaluate summary statistics
s_prime <- c(mean(X_prime), sd(X_prime)) 

# set tolerance
delta <- 0.1

# compute the difference
diff <- sqrt( (s[1]-s_prime[1])^2+(s[2]-s[2])^2 )

# reject
if (diff > delta){ 
    # draw new values 
}
else {
    # accept: decrease delta and repeat?
    
}



