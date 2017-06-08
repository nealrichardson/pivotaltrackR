#' Get stories
#' @param ... "Filter" terms to refine the query. See `https://www.pivotaltracker.com/help/articles/advanced_search/`
#' @param search A search string
#' @param query List of query parameters. See `https://www.pivotaltracker.com/help/api/rest/v5#Stories`. Most are not valid when filter terms are used.
#' @return A list of Stories
#' @export
getStories <- function (..., search=NULL, query=list()) {
    filter <- list(...)
    if (length(filter) || !is.null(search)) {
        ## Use "filter" list() for searching stories:
        ## https://www.pivotaltracker.com/help/faq#howcanasearchberefined
        query$filter <- buildFilter(filter, search)
    }
    return(ptGET(pivotalURL("stories"), query=query))
}

buildFilter <- function (terms, search=NULL) {
    # Given a list of search terms, make a Pivotal search string

    labels <- terms[["label"]]
    terms <- terms[setdiff(names(terms), "label")]
    f <- paste(names(terms), terms, sep=":", collapse=" ")
    if (!is.null(labels)) {
        ## Handle labels specially. Multiple labels have to enter separately
        ## And they need to be quoted
        labels <- paste0('label:"', labels, '"')
        if (length(labels) > 1) {
            ## Handle multiple labels together
            labels <- paste0("(", paste(labels, collapse=" OR "), ")")
        }
        f <- paste(f, labels)
    }
    if (!is.null(search)) {
        ## Use "search" for text searches. It goes on the "filter", but
        ## it's not key:value
        ## Trim leading whitespace if "search" is only thing passed in
        f <- sub("^ ", "", paste(f, search))
    }
    return(f)
}
