#' Get a story's labels
#'
#' @param story A `story` object, a story id, or URL to a story
#' @return A character vector of the names of the labels attached to the story
#' @export
labels <- function (story) {
    if (!is.story(story)) {
        story <- getStory(story)
    }
    return(vapply(story$labels, function (x) x$name, character(1)))
}

#' Add labels to a story
#'
#' @inheritParams labels
#' @param labels Character vector of names of labels to add to the story
#' @return Invisibly, the `story` object with the labels added. If the story
#' already has all of the labels you're trying to add, no request will be made.
#' @export
addLabel <- function (story, labels=character(0)) {
    if (length(labels)) {
        current_labels <- labels(story)
        new_labels <- union(current_labels, labels)
        if (!setequal(current_labels, new_labels)) {
            story <- editStory(story, labels=I(new_labels))
        }
    }
    invisible(story)
}

#' @rdname addLabel
#' @export
addLabels <- addLabel
