#' @keywords internal
#' @noRd
#' @importFrom rlang .data := %|%

globalVariables("n")

helpers <- tidyselect::vars_select_helpers

x_env <- new.env(parent = emptyenv())

get_x_name <- function() {
  get0("x_name", envir = x_env)
}

set_x_name <- function(value) {
  x_env$x_name <- value
}

reset_x_name <- function() {
  suppressWarnings(rm("x_name", envir = x_env))
}

ctab <- function(x, ..., m = TRUE) {
  vars <- rlang::quos(...)
  vars <- lapply(vars, rlang::env_bury, !!!helpers)
  varnames <- tidyselect::vars_select(names(x), !!!vars)
  if (length(varnames) == 2L) {
    x <- dplyr::select(x, !!!varnames)
    x <- dplyr::group_by_at(x, names(varnames))
    x <- dplyr::summarize(x, n = n())
    if (m == FALSE) {
      x <- stats::na.omit(x)
    }
    topvar <- rlang::quo_name(colnames(x[2]))
    x <- tidyr::spread(x, 2, 3, fill = 0L)
    colnames(x) <- stringr::str_replace(colnames(x), "<NA>", "NA")
    df_to_return <- tibble::as_tibble(x)
    attr(df_to_return, "topvar") <- topvar
    total_col <- rowSums(x[-1L], na.rm = TRUE)
    x <- cbind(x, Total = total_col)
    total_row <- colSums(x[-1L], na.rm = TRUE)
    x <- rbind(x, total_row)
    x <- purrr::map_df(x, as.character)
    x[nrow(x), 1] <- "Total"
    statascii(x, flavor = "contingency", topvar = topvar)
    invisible(df_to_return)
  } else {
    stop("ctab() must have exactly two variables for a 2x2 contingency table")
  }
}

color_grey <- function(x) {
  crayon::make_style("darkgrey")(x)
}

color_red <- function(x) {
  crayon::red(x)
}
