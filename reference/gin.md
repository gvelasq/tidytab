# A reimagination of `%in%` for partial string matching

`%gin%` is a reimagination of `%in%` using
[`grepl()`](https://rdrr.io/r/base/grep.html) for partial string
matching.

## Usage

``` r
pattern %gin% x
```

## Arguments

- pattern:

  Character string to be matched.

- x:

  `R` object to be matched against. The object must be a character
  vector or an object coercible by
  [`as.character()`](https://rdrr.io/r/base/character.html) to a
  character vector.

## References

`%gin%` was first written for [@ivelasq](https://github.com/ivelasq)'s
[r-data-recipes](https://github.com/ivelasq/r-data-recipes) GitHub
repository.

## Examples

``` r
# %in% evaluates to FALSE because it looks for full string matches
"t" %in% "tonic"
#> [1] FALSE

# %gin% evaluates to TRUE
"t" %gin% "tonic"
#> [1] TRUE

# %gin% can be used with tab()
tab("Toyota" %gin% rownames(mtcars))
#>   "Toyota" %gin% rownames(mtcars) │      Freq.     Percent        Cum. 
#> ──────────────────────────────────┼───────────────────────────────────
#>                             FALSE │         30        93.8        93.8 
#>                              TRUE │          2         6.2       100.0 
#> ──────────────────────────────────┼───────────────────────────────────
#>                             Total │         32       100.0            
```
