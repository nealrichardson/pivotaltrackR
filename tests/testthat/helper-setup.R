redact_pivotal <- function (response) {
    redact_pivotal_token <- redact_headers("X-TrackerToken")
    remove_project <- function (x) gsub(getOption("pivotal.project"), "123", x)
    remove_project_from_body <- within_body_text(remove_project)

    # Remove token from special header
    response <- redact_pivotal_token(response)
    # Remove from URL--note that it appears twice!
    response$url <- remove_project(response$url)
    response$request$url <- remove_project(response$request$url)
    # Now remove from the response body
    response <- remove_project_from_body(response)
    return(response)
}

## For recording responses: use the custom redactor to purge sensitive information
capture_requests <- function (...) {
    httptest::capture_requests(redact=redact_pivotal, ...)
}
