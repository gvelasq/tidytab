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
br <- function(x, title) {
  x_expr <- quo_name(enexpr(x))
  title_expr <- quo_name(enexpr(title))
  if(title_expr == "") {
    get("View", envir = as.environment("package:utils"))(x, title = x_expr)
  } else {
    get("View", envir = as.environment("package:utils"))(x, title = title_expr)
  }
}
