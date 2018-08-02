#' Create tables of frequencies
#'
#' @description
#' `tab()` creates n-way tables of frequencies in the `R` console, similar to those created by Stata's `tabulate` function. When three or more variables are passed to `tab()`, only flat tables are displayed. `ta()` is a shortened alias for `tab()`.
#'
#' `ftab()` creates only flat tables of frequencies.
#'
#' The convenience functions `tab1()` and `tab2()` are inspired by functions of the same name in Stata. They allow rapid tabulation of a set of variables. `tab1()` creates one-way tables of frequencies for each listed variable. `tab2()` creates two-way tables of frequencies for all listed variable combinations.
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
#' @param ... A comma separated list of unquoted variable names.
#' @param m If `TRUE` (the default), missing values are reported.
#'
#' @details
#' If a single variable is passed to `tab()`, a table of frequencies is printed (with a total row and columns 'Freq.', 'Percent', and 'Cum.').
#'
#' If two variables are passed to `tab()`, a special 2x2 contingency table is printed (with a total row and a total column).
#'
#' If three or more variables are passed to `tab()`, a flat contingency table is printed (with columns 'Freq.', 'Percent', and 'Cum.').
#'
#' The invisibly returned tibble excludes total rows and columns to avoid collision of variable classes.
#'
#' @return
#' A tibble containing a table of frequencies for the variables listed in `...`
#'
#' @seealso
#' The statar package by Matthieu Gomez provides a `tab()` function with output similar to tidytab's `ftab()`. Both packages use a variant of [`statascii()`](https://github.com/g-velasq/statascii) to format tables for display in the `R` console. Differences between the packages include:
#'
#' * tidytab displays tables in tidyverse colors: grey for block drawing characters and red for `NA`s.
#' * tidytab allows for tabulation of named and unnamed vectors.
#' * tidytab implements automatic table wrapping for tables wider than the `R` console.
#' * tidytab's `tab()` and `ftab()` display a total row with total frequencies for one-way tabulations.
#' * tidytab's `tab()` displays a special 2x2 contingency table for two-way tabulations (flat two-way tables are available with `ftab()`).
#' * tidytab's convenience functions `tab1()` and `tab2()` allow for rapid tabulation of a set of variables into either one- or two-way tables.
#'
#' The janitor package by Sam Firke provides the `tabyl()` function for SPSS-like tables of frequencies and adornments.
#'
#' Base `R` provides the `base::ftable()` and `stats::xtabs()` functions for unadorned tables of frequencies.
#'
#' @examples
#' # one-way table of frequencies
#' mtcars %>% tab(cyl)
#'
#' # two-way table of frequencies (a special 2x2 contingency table)
#' mtcars %>% tab(cyl, gear)
#'
#' # flat contingency tables of three (or more) variables
#' mtcars %>% tab(cyl, gear, am)
#'
#' # tables wider than the R console are automatically wrapped
#' mtcars %>% tab(cyl, gear, am, vs)
#'
#' # missing values are displayed in tidyverse red
#' tab(letters[24:27])
#'
#' # ftab() displays only flat contingency tables (here, with two variables)
#' mtcars %>% ftab(cyl, gear)
#'
#' # tab1() displays one-way tables for each variable
#' mtcars %>% tab1(cyl, gear)
#'
#' # tab2() displays two-way tables for all variable combinations
#' mtcars %>% tab2(cyl, gear, am)
#'
#' # ta() is a shortened alias for tab(), inspired by Stata
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
  if (!exists("x_name", envir = x_env)) {
    set_x_name(rlang::quo_name(rlang::enexpr(x)))
  }
  if (length(vars) == 0L | length(vars) == 1L | length(vars) > 2L) {
    df_to_return <- ftab(x, ..., m = m)
  }
  if (length(vars) == 2L) {
    df_to_return <- ctab(x, ..., m = m)
  }
  invisible(df_to_return)
}

#' @export
ta <- function(x, ..., m = TRUE) {
  set_x_name(rlang::quo_name(rlang::enexpr(x)))
  tab(x, ..., m = m)
}

#' @export
ftab <- function(x, ..., m = TRUE) {
  if (!exists("x_name", envir = x_env)) {
    set_x_name(rlang::quo_name(rlang::enexpr(x)))
  }
  x_name <- get_x_name()
  reset_x_name()
  if (m == FALSE) {
    x <- stats::na.omit(x)
  }
  vars <- rlang::quos(...)
  if (length(vars) == 0L) {
    if (rlang::is_atomic(x) == TRUE) {
      x <- tibble::as_tibble(x)
      x <- dplyr::count(x, .data$value)
      x <- dplyr::rename(x, !!x_name := .data$value, Freq. = .data$n)
    }
  }
  else {
    groups <- dplyr::group_vars(x)
    x <- dplyr::group_by(x, ...)
    x <- dplyr::summarize(x, Freq. = n())
    x <- dplyr::group_by(x, !!!rlang::syms(groups))
  }
  x <- dplyr::mutate(x, Percent = formatC(.data$Freq. / sum(.data$Freq.) * 100, digits = 1L, format = "f"), Cum. = formatC(cumsum(.data$Percent), digits = 1L, format = "f"))
  df_to_return <- x
  if (ncol(x) == 4 & colnames(x)[2] == "Freq.") {
    total_freq <- formatC(sum(x[, 2]), digits = 0L, format = "f")
    x <- sapply(x, as.character)
    x <- rbind(x, c("Total", total_freq, "100.0", "\u00a0"))
    x[nrow(x) - 1L, ncol(x)] <- "100.0"
    x <- tibble::as_tibble(x)
    statascii(x, flavor = "oneway")
  }
  else if (ncol(x) > 4) {
    x <- tibble::as_tibble(x)
    statascii(x, flavor = "summary", separators = TRUE)
  }
  invisible(df_to_return)
}

#' @export
tab1 <- function(x, ..., m = TRUE) {
  vars <- rlang::quos(...)
  if (!exists("x_name", envir = x_env)) {
    set_x_name(rlang::quo_name(rlang::enexpr(x)))
  }
  if (length(vars) == 0L) {
    ftab(x, ..., m = m)
  } else {
    for (i in 1L:length(vars)) {
      tab(x = x, `!!`(vars[[i]]), m = m)
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
    x <= y
  }
  tab_sequence <- purrr::cross2(1L:length(vars), 1L:length(vars), .filter = filter)
  for (i in 1L:length(tab_sequence)) {
    tab(x = x, `!!`(vars[[purrr::as_vector(tab_sequence[[i]])[2]]]), `!!`(vars[[purrr::as_vector(tab_sequence[[i]])[1]]]), m = m)
    cat("\n")
  }
}
