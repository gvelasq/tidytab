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
#' @export
br <- function(x, title = NULL) {
  title_expr <- rlang::quo_name(rlang::enexpr(x))
  if (!is.null(title)) {
    title_expr <- rlang::quo_name(rlang::enexpr(title))
  }
  get("View", envir = as.environment("package:utils"))(x, title = title_expr)
}
