apiRoot <- "https://www.pivotaltracker.com/services/v5"

pivotalURL <- function (..., project=getPivotalProject()) {
    paste(apiRoot, "projects", project, ..., sep="/")
}

getPivotalProject <- function () {
    p <- getOption("pivotal.project")
    if (is.null(p)) {
        halt("No PivotalTracker project ID set. Provide it with 'options(pivotal.project=YOURID)'")
    }
    return(p)
}

#' @importFrom httr GET content
ptAPI <- function (verb, url, config=list(), ...) {
    FUN <- get(verb, envir=asNamespace("httr"))
    x <- FUN(url, ..., config=c(ptConfig(), config))
    return(handlePTResponse(x))
}

#' @importFrom httr http_status
handlePTResponse <- function (resp) {
    status <- resp$status_code
    if (status >= 400L)  {
        msg <- http_status(resp)$message
        msg2 <- try(content(resp), silent=TRUE)
        if (!inherits(msg2, "try-error")) {
            if (is.list(msg2)) {
                msg2 <- paste(names(msg2), msg2, sep=": ", collapse="\n")
            }
            msg <- paste(msg, msg2, sep=":\n")
        }
        halt(msg)
    } else if (status == 204) {
        return(NULL)
    } else {
        return(content(resp))
    }
}

ptGET <- function (url, ...) {
    ptAPI("GET", url, ...)
}

ptPOST <- function (url, ...) {
    ptAPI("POST", url, encode="json", ...)
}

ptPUT <- function (url, ...) {
    ptAPI("PUT", url, encode="json", ...)
}

ptDELETE <- function (url, ...) {
    ptAPI("DELETE", url, ...)
}

paginatedGET <- function (url, query=list(), ...) {
    query$envelope <- "true"
    resp <- ptGET(url, query=query, ...)
    out <- resp$data
    ## Handle pagination
    if ("pagination" %in% names(resp) && !is.null(resp$pagination$total)) {
        requested <- resp$pagination$limit + resp$pagination$offset
        while (requested < resp$pagination$total) {
            query$offset <- requested
            resp <- ptGET(url, query=query, ...)
            out <- c(out, resp$data)
            requested <- resp$pagination$limit + resp$pagination$offset
        }
    }
    return(out)
}

#' @importFrom httr config add_headers
ptConfig <- function () {
    return(add_headers(`user-agent`=ptUserAgent(),
                       `X-TrackerToken`=getOption("pivotal.token")))
}

#' @importFrom utils packageVersion
#' @importFrom curl curl_version
ptUserAgent <- function () {
    ## Cf. httr:::default_ua
    versions <- c(
        libcurl = curl_version()$version,
        curl = as.character(packageVersion("curl")),
        httr = as.character(packageVersion("httr")),
        pivotaltrackR = as.character(packageVersion("pivotaltrackR"))
    )
    ua <- paste0(names(versions), "/", versions, collapse = " ")
    return(ua)
}
