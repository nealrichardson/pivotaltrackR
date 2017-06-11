apiRoot <- "https://www.pivotaltracker.com/services/v5"

pivotalURL <- function (segment, project=getPivotalProject()) {
    file.path(apiRoot, "projects", project, segment)
}

getPivotalProject <- function () {
    p <- getOption("pivotal.project")
    if (is.null(p)) {
        stop("No PivotalTracker project ID set. Provide it with 'options(pivotal.project=YOURID)'")
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
    if (resp$status_code >= 400L)  {
        msg <- http_status(resp)$message
        msg2 <- try(content(resp), silent=TRUE)
        if (!inherits(msg2, "try-error")) {
            if (is.list(msg2)) {
                msg2 <- paste(names(msg2), msg2, sep=": ", collapse="\n")
            }
            msg <- paste(msg, msg2, sep=":\n")
        }
        stop(msg, call.=FALSE)
    } else {
        return(content(resp))
    }
}


ptGET <- function (url, ...) {
    ptAPI("GET", url, ...)
}

paginatedGET <- function (url, query=list(), ...) {
    query$envelope <- "true"
    resp <- ptGET(url, query=query, ...)
    out <- resp$data
    ## Handle pagination
    if ("pagination" %in% names(resp)) {
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
