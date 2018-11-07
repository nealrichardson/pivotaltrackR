#' Create, read, update, and delete a story
#'
#' @param story An id string or URL to a Story
#' @param ... Story attributes to either `createStory` or `editStory`. See a
#' list of valid attributes at
#' \url{https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_stories_post}.
#' `name` is required on creation; all other fields are optional.
#' @return `deleteStory` returns nothing, while the other functions all return
#' a 'story' object: either the requested story (`getStory`), the newly
#' created story (`createStory`), or the current state of the modified story
#' `editStory`.
#' @name story
#' @examples
#' \dontrun{
#' new_bug <- createStory(
#'     name="Flux capacitor hangs at 0.9 gigawatts",
#'     description="Please investigate and fix.",
#'     story_type="bug"
#' )
#' new_bug <- editStory(new_bug, current_state="started")
#' deleteStory(new_bug)
#' }
#' @export
getStory <- function (story) {
    return(as.story(ptGET(storyURL(story))))
}

storyURL <- function (story) {
    if (is.story(story)) {
        story <- story$id
    }
    if (is.whole(story)) {
        return(pivotalURL("stories", story, ""))
    } else if (is.character(story)) {
        template <- paste0("^", pivotalURL("stories", "[0-9]+", "$"))
        if (grepl(template, story)) {
            ## It's already a story URL
            return(story)
        } else if (grepl("^[0-9]+$", story)) {
            ## It's an ID
            return(pivotalURL("stories", story, ""))
        } else {
            halt("Invalid story: ", story)
        }
    } else {
        halt("Invalid story: object of class ", class(story))
    }
}

#' @rdname story
#' @export
createStory <- function (...) {
    invisible(as.story(ptPOST(pivotalURL("stories"), body=list(...))))
}

#' @rdname story
#' @export
editStory <- function (story, ...) {
    invisible(as.story(ptPUT(storyURL(story), body=list(...))))
}

#' @rdname story
#' @export
deleteStory <- function (story) {
    invisible(ptDELETE(storyURL(story)))
}

as.story <- function (x) structure(x, class="story")

is.story <- function (x) inherits(x, "story")

#' @export
#' @importFrom utils str
print.story <- function (x, ...) print(str(x))
