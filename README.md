# pivotaltrackR: An R Client for the PivotalTracker API

[![Build Status](https://travis-ci.org/nealrichardson/pivotaltrackR.png?branch=master)](https://travis-ci.org/nealrichardson/pivotaltrackR)  [![codecov](https://codecov.io/gh/nealrichardson/pivotaltrackR/branch/master/graph/badge.svg)](https://codecov.io/gh/nealrichardson/pivotaltrackR)
[![Build status](https://ci.appveyor.com/api/projects/status/87n5pncwov3jyfab/branch/master?svg=true)](https://ci.appveyor.com/project/nealrichardson/pivotaltrackr/branch/master)
[![cran](https://www.r-pkg.org/badges/version-last-release/pivotaltrackR)](https://cran.r-project.org/package=pivotaltrackR)

[Pivotal Tracker](https://www.pivotaltracker.com/) is a tool for project management. This package lets you communicate with its API from R. The package is very much a work in progress, and not many API endpoints are yet supported, but more are coming. If you find this useful and want to see more, make an issue or (even better!) a pull request.

## Installing

<!-- If you're putting `pivotaltrackR` on CRAN, it can be installed with

    install.packages("pivotaltrackR") -->

The pre-release version of the package can be pulled from GitHub using the [devtools](https://github.com/hadley/devtools) package:

    # install.packages("devtools")
    devtools::install_github("nealrichardson/pivotaltrackR")

## Getting started

To access the Pivotal Tracker API, you'll need to get an API token, and then you'll need to provide the token and your project ID as "options". Set them in your current session with

    options(pivotal.token="SOMEBIGLONGHASH", pivotal.project="12345")

or put that in your `.Rprofile` for use in every session.

### Endpoints supported

* `getStories`: GET [Stories](https://www.pivotaltracker.com/help/api/rest/v5#Stories)

[Pagination](https://www.pivotaltracker.com/help/api#Paginating_List_Responses) of large responses is handled automatically: no need to make special requests to fetch all.

## For developers

The repository includes a Makefile to facilitate some common tasks.

### Running tests

`$ make test`. Requires the [httptest](https://github.com/nealrichardson/httptest) package. You can also specify a specific test file or files to run by adding a "file=" argument, like `$ make test file=api`. `test_package` will do a regular-expression pattern match within the file names. See its documentation in the [testthat](https://github.com/hadley/testthat) package.

### Updating documentation

`$ make doc`. Requires the [roxygen2](https://github.com/klutometis/roxygen) package.
