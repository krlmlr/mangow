
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mangow

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/krlmlr/mangow.svg?branch=master)](https://travis-ci.org/krlmlr/mangow)
[![codecov.io](https://codecov.io/github/krlmlr/mangow/coverage.svg?branch=master)](https://codecov.io/github/krlmlr/mangow?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/mangow)](https://CRAN.R-project.org/package=mangow)
<!-- badges: end -->

The goal of mangow is to normalize provide a transformation from Gower
to Manhattan distance. The only exported function in this package
converts a data frame to an equivalent matrix where the pairwise Gower
distances in the input data frame are identical to the pairwise
Manhattan distances in the resulting matrix. With this transformation,
efficient algorithms for the Manhattan distance, such as
nearest-neighbor for L1, can be extended to work with Gower distances.

## Installation

You can install the released version of mangow from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("mangow")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("krlmlr/mangow")
```

## Example

This basic example computes a Gower dissimilarity matrix on a subset of
the Iris data and compares it with the L1 dissimilarity matrix of the
transformed data.

``` r
iris_sub <- iris[c(1:2, 50:51, 100:101), ]
row.names(iris_sub) <- NULL
iris_sub
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1          5.1         3.5          1.4         0.2     setosa
#> 2          4.9         3.0          1.4         0.2     setosa
#> 3          5.0         3.3          1.4         0.2     setosa
#> 4          7.0         3.2          4.7         1.4 versicolor
#> 5          5.7         2.8          4.1         1.3 versicolor
#> 6          6.3         3.3          6.0         2.5  virginica

cluster::daisy(iris_sub, metric = "gower")
#> Dissimilarities :
#>            1          2          3          4          5
#> 2 0.16190476                                            
#> 3 0.06666667 0.09523810                                 
#> 4 0.71449275 0.70496894 0.66687371                      
#> 5 0.67018634 0.54637681 0.62256729 0.27287785           
#> 6 0.77142857 0.81904762 0.72380952 0.44741201 0.58695652
#> 
#> Metric :  mixed ;  Types = I, I, I, I, N 
#> Number of objects : 6
```

The transformation returns a matrix with the same number of rows, but
potentially more columns, depending on the data types of the input
columns.

``` r
library(mangow)

mangow_iris_sub <- mangow(iris_sub)
mangow_iris_sub
#>      Sepal.Length Sepal.Width Petal.Length Petal.Width
#> [1,]   0.01904762  0.20000000    0.0000000  0.00000000
#> [2,]   0.00000000  0.05714286    0.0000000  0.00000000
#> [3,]   0.00952381  0.14285714    0.0000000  0.00000000
#> [4,]   0.20000000  0.11428571    0.1434783  0.10434783
#> [5,]   0.07619048  0.00000000    0.1173913  0.09565217
#> [6,]   0.13333333  0.14285714    0.2000000  0.20000000
#>      Species.setosa.versicolor Species.virginica
#> [1,]                       0.1               0.0
#> [2,]                       0.1               0.0
#> [3,]                       0.1               0.0
#> [4,]                      -0.1               0.0
#> [5,]                      -0.1               0.0
#> [6,]                       0.0               0.1
```

The resulting dissimilarity matrix for the Manhattan metric is the same
as the Gower dissimilarity matrix on the input.

``` r
cluster::daisy(mangow_iris_sub, metric = "manhattan")
#> Dissimilarities :
#>            1          2          3          4          5
#> 2 0.16190476                                            
#> 3 0.06666667 0.09523810                                 
#> 4 0.71449275 0.70496894 0.66687371                      
#> 5 0.67018634 0.54637681 0.62256729 0.27287785           
#> 6 0.77142857 0.81904762 0.72380952 0.44741201 0.58695652
#> 
#> Metric :  manhattan 
#> Number of objects : 6
```
