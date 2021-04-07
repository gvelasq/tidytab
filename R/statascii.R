#' @keywords internal
#' @noRd
statascii <- function(df, ..., flavor = "oneway", padding = "stata", separators = FALSE, topvar = NULL) {
  stopifnot(is.data.frame(df))
  if (ncol(df) <= 2L & flavor == "twoway") {
    rlang::abort("data frame must have at least three columns for 'twoway' flavor")
  }
  if (ncol(df) <= 1L) {
    rlang::abort("data frame must have at least two columns")
  }
  df <- as.matrix(purrr::modify(df, as.character))
  if (padding == "stata") {
    colnames(df) <- stringr::str_pad(colnames(df), 9L, pad = " ")
  }
  if (padding == "summary") {
    colnames(df) <- stringr::str_pad(colnames(df), 5L, pad = " ")
  }
  nchar_content <- apply(df, 2, function(x) {
    max(crayon::col_nchar(x, type = "width"))
  })
  nchar_names <- crayon::col_nchar(colnames(df), type = "width")
  M <- pmax(nchar_content, nchar_names)
  M1 <- as.integer(c(
    M[1],
    sum(M[2:(length(M))]) + (3L * ncol(df)) - 6L
  ))
  M2 <- as.integer(c(
    M[1] - 1L,
    sum(
      M[2:(length(M) - 1L)],
      (2L * ncol(df)) - 6L
    ),
    M[length(M)] - 1L
  ))
  for (i in seq_along(M)) {
    df[, i] <- df[, i] %|% crayon::col_align(color_red("NA"), width = M[i], align = "right")
  }
  if (flavor == "oneway") {
    table_line <- add_line(M1)
    group_dashes <- add_dash(M1)
    total_line <- nrow(df) - 1L
    con <- file()
    writeLines(add_row_oneway(colnames(df), M), con)
    writeLines(table_line, con)
    for (i in seq_len(nrow(df))) {
      writeLines(add_row_oneway(df[i, ], M), con)
      if (i > 0L & i < total_line) {
        if (separators) {
          if (df[i, 1] != df[i + 1L, 1]) {
            writeLines(group_dashes, con)
          }
        }
      }
      if (i == total_line) {
        writeLines(table_line, con)
      }
    }
    table_captured <- as.matrix(readLines(con))
    close(con)
    wrap_tbl(table_captured, M = M, M1 = M1)
  }
  else if (flavor == "twoway") {
    table_line <- add_line(M2)
    group_dashes <- add_dash(M2)
    total_line <- nrow(df) - 1L
    con <- file()
    writeLines(add_row_twoway(colnames(df), M), con)
    writeLines(table_line, con)
    for (i in seq_len(nrow(df))) {
      writeLines(add_row_twoway(df[i, ], M), con)
      if (i > 0L & i < total_line) {
        if (separators) {
          if (df[i, 1] != df[i + 1L, 1]) {
            writeLines(group_dashes, con)
          }
        }
      }
      if (i == total_line) {
        writeLines(table_line, con)
      }
    }
    table_captured <- as.matrix(readLines(con))
    close(con)
    wrap_tbl(table_captured, M = M, M1 = M1)
  }
  else if (flavor == "contingency") {
    top_row <- vector(mode = "character", length = length(colnames(df)))
    top_row[2] <- topvar
    table_line <- add_line(M2)
    group_dashes <- add_dash(M2)
    total_line <- nrow(df) - 1L
    colnames(df) <- stringr::str_replace(colnames(df), "NA", color_red("NA"))
    con <- file()
    writeLines(add_row_twoway(top_row, M), con)
    writeLines(add_row_twoway(colnames(df), M), con)
    writeLines(table_line, con)
    for (i in seq_len(nrow(df))) {
      writeLines(add_row_twoway(df[i, ], M), con)
      if (i == total_line) {
        writeLines(table_line, con)
      }
    }
    table_captured <- as.matrix(readLines(con))
    close(con)
    wrap_tbl(table_captured, M = M, M1 = M1)
  }
  else if (flavor == "summary") {
    table_line <- add_line(M1)
    group_dashes <- add_dash(M1)
    con <- file()
    writeLines(add_row_oneway(colnames(df), M), con)
    writeLines(table_line, con)
    for (i in seq_len(nrow(df))) {
      writeLines(add_row_oneway(df[i, ], M), con)
      if (i > 0L & i < nrow(df)) {
        if (separators) {
          if (df[i, 1] != df[i + 1L, 1]) {
            writeLines(group_dashes, con)
          }
        }
      }
    }
    table_captured <- as.matrix(readLines(con))
    close(con)
    wrap_tbl(table_captured, M = M, M1 = M1)
  }
  invisible(df)
}

wrap_tbl <- function(tbl, M = M, M1 = M1, width = getOption("width")) {
  stopifnot(is.matrix(tbl))
  if (max(crayon::col_nchar(tbl)) <= width) {
    cat(tbl, sep = "\n")
  }
  if (max(crayon::col_nchar(tbl)) > width) {
    M_rest <- M[-1] + 3L
    M_rest[1] <- M_rest[1] - 1L
    M_start <- M[-1]
    M_start[seq_along(M_start)] <- 0L
    M_start[1] <- 1L
    M_end <- M[-1]
    M_end[seq_along(M_end)] <- 0L
    M_end[1] <- M_rest[1]
    if (length(M_rest) > 1L) {
      for (i in 2L:length(M_rest)) {
        M_end[i] <- M_end[i - 1L] + M_rest[i]
        M_start[i] <- M_end[i - 1L] + 1L
      }
    }
    col_one <- as.matrix(crayon::col_substr(tbl, 1L, M1[1] + 4L))
    col_rest <- as.matrix(crayon::col_substr(tbl, M1[1] + 5L, crayon::col_nchar(tbl)))
    col_position <- matrix(c(M_start, M_end), ncol = 2L)
    all_cols <- list()
    if (length(M_rest) > 1L) {
      for (i in 1L:length(M_rest)) {
        all_cols[[i + 1L]] <-
          as.matrix(crayon::col_substr(col_rest, col_position[i, 1], col_position[i, 2]))
      }
    }
    all_cols[[1]] <- col_one
    col_widths <- vector(mode = "integer", length = length(all_cols))
    col_sums <- vector(mode = "integer", length = length(all_cols))
    col_index <- vector(mode = "integer", length = length(all_cols))
    wrap_count <- 1L
    for (i in 1L:length(all_cols)) {
      col_widths[i] <- max(crayon::col_nchar(all_cols[[i]]))
      col_index[i] <- wrap_count
    }
    col_sums[1] <- col_widths[1]
    for (i in 2L:length(all_cols)) {
      col_sums[i] <- col_widths[i] + col_sums[i - 1L]
      if (col_sums[i] > width) {
        wrap_count <- wrap_count + 1L
        col_sums[i] <- col_widths[1L] + col_widths[i]
      }
      if (wrap_count > 1L) {
        col_index[i] <- wrap_count
      }
    }
    tbl_wrapped <- vector(mode = "list", length = wrap_count)
    for (i in 1L:length(tbl_wrapped)) {
      tbl_wrapped[i] <- all_cols[1]
    }
    for (i in 2L:length(col_index)) {
      current_list <- col_index[i]
      tbl_wrapped[[current_list]] <- as.matrix(
        paste0(
          as.matrix(unlist(tbl_wrapped[current_list])),
          as.matrix(unlist(all_cols[i]))
        )
      )
    }
    for (i in 1L:length(tbl_wrapped)) {
      cat(tbl_wrapped[[i]], sep = "\n")
      if (i < length(tbl_wrapped)) {
        cat("\n")
      }
    }
  }
}

add_line <- function(n) {
  tmp <- purrr::map_chr(n, ~paste0(rep(color_grey(u2500), . + 2L), collapse = ""))
  paste0(color_grey(u2500), paste0(tmp, collapse = color_grey(u253c)))
}

add_dash <- function(n) {
  tmp <- purrr::map_chr(n, ~paste0(rep(color_grey("-"), . + 2L), collapse = ""))
  paste0(color_grey("-"), paste0(tmp, collapse = color_grey(u253c)))
}

add_row_oneway <- function(x, n) {
  row_content <- purrr::map2_chr(x, seq_along(x), ~sprintf(paste0("%", n[.y], "s"), .x))
  paste0(
    paste0(paste0("  ", row_content[1], " "), collapse = ""),
    color_grey(u2502),
    " ",
    paste0(paste0(" ", row_content[-1], " "), collapse = " ")
  )
}

add_row_twoway <- function(x, n) {
  row_content <- purrr::map2_chr(x, seq_along(x), ~sprintf(paste0("%", n[.y], "s"), .x))
  paste0(
    paste0(paste0(" ", row_content[1], " "), collapse = ""),
    color_grey(u2502),
    paste0(paste0(" ", row_content[2:(length(row_content) - 1L)], " "), collapse = ""),
    color_grey(u2502),
    paste0(paste0(" ", row_content[length(row_content)], " "), collapse = " ")
  )
}
