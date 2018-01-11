function (response) {
    require(magrittr, quietly=TRUE)
    response %>%
        redact_headers("X-TrackerToken") %>%
        gsub_response("https://www.pivotaltracker.com/services/v5/", "") %>%
        gsub_response(getOption("pivotal.project"), "123")
}
