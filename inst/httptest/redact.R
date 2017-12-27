function (response) {
    require(magrittr)
    response %>%
        redact_headers("X-TrackerToken") %>%
        gsub_response(getOption("pivotal.project"), "123")
}
