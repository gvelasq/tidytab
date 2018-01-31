#' A reimagination of \code{\%in\%} for partial string matching
#'
#' @name %gin%
#' @rdname gin
#' @rdname \%gin\%
#'
#' @description
#' \code{\%gin\%} is a reimagination of \code{\%in\%} using `grepl()` for partial string matching.
#'
#' @usage
#' pattern \%gin\% x
#'
#' @param pattern Character string to be matched.
#' @param x `R` object to be matched against. The object must be a character vector or an object coercible by `as.character()` to a character vector.
#'
#' @examples
#' # %in% evaluates to FALSE because it looks for full string matches
#' "t" %in% "tonic"
#'
#' # %gin% evaluates to TRUE
#' "t" %gin% "tonic"
#'
#' # %gin% can be used with tab()
#' tab("Toyota" %gin% rownames(mtcars))
#'
#' @references
#' \code{\%gin\%} was first written for [@ivelasq](https://github.com/ivelasq)'s [r-data-recipes](https://github.com/ivelasq/r-data-recipes) GitHub repository.
#'
#' @export
"%gin%" <- function(pattern, x) {
  grepl(pattern, x)
}
