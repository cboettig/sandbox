#Use the current working directory
#$ -cwd
## use bash commands
#$ -S /bin/bash
## combine error and output files
#$ -j y
## Parallel for openmp:
##$ -pe threaded 16
## Launch parallel mpi threads
#$ -pe mpi 16
## Output file name
#$ -o test.log 
## Name for queue job
#$ -N test

module load gcc openmpi R 
Rscript -e "source('~/.Rprofile'); library('knitr'); knit('parallel.Rmd')" 


