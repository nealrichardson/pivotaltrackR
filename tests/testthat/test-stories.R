context("Get stories")

test_that("buildFilter query construction", {
    expect_identical(buildFilter(list(
            type="Release",
            state="accepted",
            includedone="true"
        )),
        "type:Release state:accepted includedone:true")
})

test_that("buildFilter query construction with labels", {
    expect_identical(buildFilter(list(
            state="started",
            label=c("important", "customer")
        )),
        'state:started (label:"important" OR label:"customer")')
    expect_identical(buildFilter(list(
            state="started",
            label="important"
        )),
        'state:started label:"important"')
})

without_internet({
    test_that("A valid request is made, with the right headers", {
        expect_header(
            expect_GET(getStories(),
                "https://www.pivotaltracker.com/services/v5/projects/12345/stories"),
            "X-TrackerToken: rekcarTlatoviP")
        expect_header(
            expect_GET(getStories(state="finished"),
                "https://www.pivotaltracker.com/services/v5/projects/12345/stories?filter=state%3Afinished"),
            "pivotaltrackR") # user-agent
    })
    test_that("Search term is passed through", {
        expect_GET(getStories(search="foo"),
            "https://www.pivotaltracker.com/services/v5/projects/12345/stories?filter=foo")
        expect_GET(getStories(state="finished", search="foo"),
            "https://www.pivotaltracker.com/services/v5/projects/12345/stories?filter=state%3Afinished%20foo")
    })
})

# with_mock_API({
#     test_that()
# })

# print(str(getStories(state="accepted", accepted="-2days..today")))
