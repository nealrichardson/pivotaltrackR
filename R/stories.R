#' Get stories
#' @param ... "Filter" terms to refine the query. See \url{https://www.pivotaltracker.com/help/articles/advanced_search/}.
#' This is how you search for stories in the Pivotal Tracker web app.
#' @param search A search string
#' @param query List of query parameters. See \url{https://www.pivotaltracker.com/help/api/rest/v5#Stories}. Most are not valid when filter terms are used.
#' @return A 'stories' object: a list of all stories matching the search.
#' @examples
#' \dontrun{
#' getStories(story_type="bug", current_state="unstarted",
#'     search="deep learning")
#' }
#' @export
getStories <- function (..., search=NULL, query=list()) {
    ## TODO: move search to first arg so unnamed search is supported
    filter <- list(...)
    if (length(filter) || !is.null(search)) {
        ## Use "filter" list() for searching stories:
        ## https://www.pivotaltracker.com/help/faq#howcanasearchberefined
        query$filter <- buildFilter(filter, search)
    }
    resp <- paginatedGET(pivotalURL("stories"), query=query)
    class(resp) <- "stories"
    return(resp)
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

#' @export
as.data.frame.stories <- function (x, row.names = NULL, optional = FALSE, ...) {
    if (length(x) == 0) {
        return(data.frame())
    }
    ## Some elements may be missing so identify them all
    allnames <- unique(unlist(lapply(x, names)))
    df <- do.call("rbind", lapply(x, function (story) {
        story$owner_ids <- paste(lapply(story$owner_ids, function (i) i), collapse=", ")
        story$labels <- paste(lapply(story$labels, "[[", i="name"), collapse=", ")
        story[setdiff(allnames, names(story))] <- NA
        return(as.data.frame(story[allnames], stringsAsFactors=FALSE))
    }))
    datevars <- intersect(names(df), c("created_at", "updated_at", "accepted_at"))
    df[datevars] <- lapply(df[datevars], strptime, format="%Y-%m-%dT%H:%M:%OS", tz="UTC")
    return(df)
}

#' @export
print.stories <- function (x, ...) {
    ## TODO: handle length 0 case
    out <- as.data.frame(x)[, c("kind", "id", "name", "current_state")]
    ## Truncate "name", allowing width for row index + kind + id + current_state
    ## (and a space between each)
    other_cols <- nchar(nrow(out)) + max(nchar(out$kind)) + 9 + 13 + 5
    max_name <- getOption("width") - other_cols
    too_wide <- nchar(out$name) > max_name
    out$name[too_wide] <- paste0(substr(out$name[too_wide], 1, max_name - 3), "...")
    print(out)
}

#' @export
"[.stories" <- function (x, i, ...) {
    x <- NextMethod()
    class(x) <- "stories"
    return(x)
}

#' @export
"[[.stories" <- function (x, i, ...) {
    x <- NextMethod()
    class(x) <- "story"
    return(x)
}
