#' Internal functions
#' @keywords internal
#' @noRd
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
