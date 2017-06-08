# pivotaltrackR

[![Build Status](https://travis-ci.org/nealrichardson/pivotaltrackR.png?branch=master)](https://travis-ci.org/nealrichardson/pivotaltrackR)  [![codecov](https://codecov.io/gh/nealrichardson/pivotaltrackR/branch/master/graph/badge.svg)](https://codecov.io/gh/nealrichardson/pivotaltrackR)
[![Build status](https://ci.appveyor.com/api/projects/status/87n5pncwov3jyfab/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/pivotaltrackr/branch/master)
[![cran](https://www.r-pkg.org/badges/version-last-release/pivotaltrackR)](https://cran.r-project.org/package=pivotaltrackR)

## Installing

<!-- If you're putting `pivotaltrackR` on CRAN, it can be installed with

    install.packages("pivotaltrackR") -->

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("nealrichardson/pivotaltrackR", build_vignettes=TRUE)

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [httptest](https://github.com/nealrichardson/httptest) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=logging`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the [testthat](https://github.com/hadley/testthat) package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
