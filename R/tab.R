#' Create tables of frequencies
#'
#' @description
#' `tab()` and `ta()` are synonyms and create one-way and two-way tables of frequencies in the `R` console, similar to those created by Stata's `tabulate` function. When three or more variables are provided, these functions print flat tables of frequencies.
#'
#' `ftab()` creates only flat tables of frequencies.
#'
#' The convenience functions `tab1()` and `tab2()` are inspired by functions of the same name in Stata. They allow rapid tabulation of a set of variables during interactive data analysis. `tab1()` creates one-way tables of frequencies for each listed variable. `tab2()` creates two-way tables of frequencies for all listed variable combinations.
#'
#' @usage
#' tab(x, ..., m = TRUE)
#'
#' ta(x, ..., m = TRUE)
#'
#' ftab(x, ..., m = TRUE)
#'
#' tab1(x, ..., m = TRUE)
#'
#' tab2(x, ..., m = TRUE)
#'
#' @param x A vector, data.frame, or tibble.
#' @param ... Comma separated list of unquoted variable names.
#' @param m If `TRUE` the tables will report missing values.
#'
#' @details
#' If a single variable is passed to `tab()`, a table of frequencies is printed (with a total row and columns 'Freq.', 'Percent', and 'Cum.').
#'
#' If two variables are passed to `tab()`, a 2x2 contingency table is printed (with a total row and a total column).
#'
#' If three or more variables are passed to `tab()`, a flat contingency table is printed (with columns 'Freq.', 'Percent', and 'Cum.').
#'
#' Invisibly returned tibbles exclude total rows and columns to avoid collision of variable classes.
#'
#' @return
#' A tibble containing a table of frequencies for the variables listed in `...`
#'
#' @seealso
#' `statar::tab()` by Matthieu Gomez is similar to `tabr::ftab()` yet is implemented differently and provides different arguments. Like `tabr`, `statar` uses a variant of [`statascii()`](https://github.com/gvelasq2/statascii) to format tables for display in the `R` console.
#'
#' `janitor::tabyl()` creates SPSS-like tabulations and adornments that are displayed using `tibble::tibble()` in the `R` console.
#'
#' `base::ftable()`, `stats::xtabs()` are base `R` solutions for creating tables of frequencies.
#'
#' @examples
#' # setup
#' library(dplyr)
#'
#' # one-way table of frequencies
#' mtcars %>% tab(cyl)
#'
#' # two-way table of frequencies (a 2x2 contingency table)
#' mtcars %>% tab(cyl, gear)
#'
#' # flat contingency tables of three or more variables
#' mtcars %>% tab(cyl, gear, am)
#' mtcars %>% tab(cyl, gear, am, vs)
#'
#' # ftab() creates only flat contingency tables (here, with two variables)
#' mtcars %>% ftab(cyl, gear)
#'
#' # tab1() produces one-way tables for each variable
#' mtcars %>% tab1(cyl, gear)
#'
#' # tab2() creates two-way tables for all variable combinations
#' mtcars %>% tab2(cyl, gear, am)
#'
#' # ta() is an even shorter alias for tab(), inspired by Stata
#' mtcars %>% ta(gear)
#'
#' @aliases
#' ta
#' ftab
#' tab1
#' tab2

#' @rdname tab
#' @export
tab <- function(x, ..., m = TRUE) {
  vars <- rlang::quos(...)
  if (length(vars) == 0L | length(vars) == 1L | length(vars) > 2L) {
    # ftab(x, ..., m = m)
    df_to_return <- ftab(x, ..., m = m)
  }
  if (length(vars) == 2L) {
    # ctab(x, ..., m = m)
    df_to_return <- ctab(x, ..., m = m)
  }
  invisible(df_to_return)
}

#' @export
ta <- function(...) {
  tab(...)
}

#' @export
ftab <- function(x, ..., m = TRUE) {
  if (m == FALSE) {
    x <- na.omit(x)
  }
  vars <- rlang::quos(...)
  if (length(vars) == 0L) {
    if (rlang::is_atomic(x) == TRUE) {
      x_name <- rlang::quo_name("vector")
      x <- dplyr::as_tibble(x)
      x <- dplyr::count(x, value)
      x <- dplyr::rename(x, !! x_name := value, Freq. = n)
    }
  }
  else {
    groups <- dplyr::group_vars(x)
    x <- dplyr::group_by(x, ...)
    x <- dplyr::summarize(x, Freq. = n())
    x <- dplyr::group_by(x, !!! rlang::syms(groups))
  }
  x <- dplyr::mutate(x, Percent = formatC(Freq. / sum(Freq.) * 100, digits = 1L, format = "f"), Cum. = formatC(cumsum(Percent), digits = 1L, format = "f"))
  df_to_return <- x
  if (ncol(x) == 4 & colnames(x)[2] == "Freq.") {
    total_freq <- formatC(sum(x[, 2]), digits = 0L, format = "f")
    x <- sapply(x, as.character)
    x <- rbind(x, c("Total", total_freq, "100.0", "\u00a0"))
    x[nrow(x) - 1L, ncol(x)] <- "100.0"
    x <- dplyr::as_tibble(x)
    statascii(x, flavor = "oneway")
  }
  else if (ncol(x) > 4) {
    x <- dplyr::as_tibble(x)
    statascii(x, flavor = "summary", separators = TRUE)
  }
  invisible(df_to_return)
}

#' @export
tab1 <- function(x, ..., m = TRUE) {
  vars <- rlang::quos(...)
  if (length(vars) == 0L) {
    ftab(x, ..., m = m)
  } else {
    for (i in 1L:length(vars)) {
      tab(x = x, UQ(vars[[i]]), m = m)
      if (i < length(vars)) {
        cat("\n")
      }
    }
  }
}

#' @export
tab2 <- function(x, ..., m = TRUE) {
  vars <- rlang::quos(...)
  filter <- function(x, y) {
    x >= y
  }
  tab_sequence <- purrr::cross2(1L:length(vars), 1L:length(vars), .filter = filter)
  for (i in 1L:length(tab_sequence)) {
    tab(x = x, UQ(vars[[purrr::as_vector(tab_sequence[[i]])[1]]]), UQ(vars[[purrr::as_vector(tab_sequence[[i]])[2]]]), m = m)
    cat("\n")
  }
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
