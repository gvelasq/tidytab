#' Browse data
#'
#' @description `br()` is an alias for `utils::View()` and invokes the data viewer. See `utils::View()` for details. `br()` invisibly returns its input so that it can be dropped into magrittr pipe chains.
#'
#' @usage
#' br(x, title)
#'
#' @param x An `R` object coercible into a data frame.
#' @param title Optional title for viewer window.
#'
#' @export
br <- function(x, title) {
  title_expr <- rlang::quo_name(rlang::enexpr(title))
  if (title_expr == "") {
    title_expr <- rlang::quo_name(rlang::enexpr(x))
  }
  if (!interactive()) return(invisible(x)) else get("View", envir = as.environment("package:utils"))(x, title = title_expr)
  invisible(x)
}
