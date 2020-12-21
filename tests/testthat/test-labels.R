context("Story labels")

public({
    with_mock_api({
        nolabels <- createStory(name="A test story", story_type="chore")
        twolabels <- getStories(label="really common label")[[4]]

        test_that("labels() method", {
            expect_identical(labels(nolabels), character(0))
            expect_identical(labels(twolabels), c("deployed", "passed"))
        })

        test_that("addLabel(s) methods", {
            expect_PUT(addLabel(nolabels, "a label"),
                "https://www.pivotaltracker.com/services/v5/projects/123/stories/154111570/",
                '{"labels":["a label"]}'
            )
            expect_no_request(addLabel(nolabels))
            expect_PUT(addLabels(twolabels, "a label"),
                "https://www.pivotaltracker.com/services/v5/projects/123/stories/989/",
                '{"labels":["deployed","passed","a label"]}'
            )
            expect_no_request(addLabels(twolabels, "passed"))
        })
    })
})
