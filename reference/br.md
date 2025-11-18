# Browse data

`br()` is an alias for
[`utils::View()`](https://rdrr.io/r/utils/View.html) and invokes the
data viewer. See [`utils::View()`](https://rdrr.io/r/utils/View.html)
for details. `br()` invisibly returns its input so that it can be
dropped into magrittr pipe chains.

## Usage

``` r
br(x, title)
```

## Arguments

- x:

  An `R` object coercible into a data frame.

- title:

  Optional title for viewer window.
