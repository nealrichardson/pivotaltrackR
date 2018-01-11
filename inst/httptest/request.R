function (request) {
    require(magrittr, quietly=TRUE)
    request %>%
        gsub_request("https://www.pivotaltracker.com/services/v5/", "") %>%
        gsub_request(getOption("pivotal.project"), "123")
}
