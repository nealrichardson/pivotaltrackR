function (response) {
    require(magrittr, quietly=TRUE)
    response %>%
        gsub_response("https://www.pivotaltracker.com/services/v5/", "", fixed=TRUE) %>%
        gsub_response(getOption("pivotal.project"), "123")
}
