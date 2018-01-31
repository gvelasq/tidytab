#' Browse data
#'
#' @description `br()` is an alias for `utils::View()` and invokes the data viewer. See `utils::View()` for details.
#'
#' @usage
#' br(x, title)
#'
#' @param x An `R` object coercible into a data frame.
#' @param title Optional title for viewer window.
#'
#' @examples
#' mtcars$vs %>% br()
#' mtcars %>% br()
#'
#' @export
br <- function(x, title) {
  View(x, title)
}
