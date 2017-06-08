apiRoot <- "https://www.pivotaltracker.com/services/v5"

pivotalURL <- function (segment, project=getOption("pivotal.project")) {
    file.path(apiRoot, "projects", project, segment)
}

#' @importFrom httr GET stop_for_status content
ptAPI <- function (verb, url, config=list(), ...) {
    FUN <- get(verb, envir=asNamespace("httr"))
    x <- FUN(url, ..., config=c(ptConfig(), config))
    stop_for_status(x)
    return(content(x))
}

ptGET <- function (url, ...) {
    ptAPI("GET", url, ...)
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
