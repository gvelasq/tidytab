#' @keywords internal
#' @noRd
#' @importFrom crayon col_align col_nchar col_substr make_style red
#' @importFrom dplyr count group_by group_vars mutate rename summarize
#' @importFrom grDevices grey
#' @importFrom purrr as_vector cross2 map_chr map_df map2_chr modify
#' @importFrom rlang %|% abort as_character
#' @importFrom stats na.omit
#' @importFrom stringr str_c str_dup str_pad str_replace
#' @importFrom tibble as_tibble
#' @importFrom tidyr spread
#' @importFrom utils capture.output View

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
  if (length(vars) == 2L) {
    x <- dplyr::count(x, ...)
    if (m == FALSE) {
      x <- na.omit(x)
    }
    topvar <- rlang::quo_name(colnames(x[2]))
    x <- tidyr::spread(x, 2, 3, fill = 0L)
    colnames(x) <- stringr::str_replace(colnames(x), "<NA>", "NA")
    df_to_return <- tibble::as_tibble(x)
    attr(df_to_return, "topvar") <- topvar
    total_col <- rowSums(x[-1L], na.rm = TRUE)
    x <- cbind(x, total_col)
    total_row <- colSums(x[-1L], na.rm = TRUE)
    total_row <- c(NA, total_row)
    x <- rbind(x, total_row)
    x <- purrr::map_df(x, as.character)
    x[nrow(x), 1] <- "Total"
    colnames(x)[ncol(x)] <- "Total"
    statascii(x, flavor = "contingency", topvar = topvar)
    invisible(df_to_return)
  } else {
    stop("ctab() must have exactly two variables for a 2x2 contingency table")
  }
}

color_grey <- function(x) {
  crayon::make_style(grDevices::grey(0.6), grey = TRUE)(x)
}

color_red <- function(x) {
  crayon::red(x)
}
