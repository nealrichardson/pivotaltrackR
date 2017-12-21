Sys.setlocale("LC_COLLATE", "C") ## What CRAN does; affects sort order
set.seed(999) ## To ensure that tests that involve randomness are reproducible

options(
    pivotal.project=12345,
    pivotal.token="rekcarTlatoviP"
)

public({
    source("helper-setup.R")
})
