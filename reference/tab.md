# Create tables of frequencies

`tab()` creates n-way tables of frequencies in the `R` console, similar
to those created by Stata's `tabulate` function. When three or more
variables are passed to `tab()`, only flat tables are displayed.

`ftab()` creates only flat tables of frequencies.

The convenience functions `tab1()` and `tab2()` are inspired by
functions of the same name in Stata. They allow rapid tabulation of a
set of variables. `tab1()` creates one-way tables of frequencies for
each listed variable. `tab2()` creates two-way tables of frequencies for
all listed variable combinations.

## Usage

``` r
tab(x, ..., m = TRUE)

ftab(x, ..., m = TRUE)

tab1(x, ..., m = TRUE)

tab2(x, ..., m = TRUE)
```

## Arguments

- x:

  A vector, data.frame, or tibble.

- ...:

  A comma separated list of unquoted variable names or positions. Select
  helpers from
  [dplyr](https://dplyr.tidyverse.org/reference/select.html) and
  [tidyselect](https://rdrr.io/cran/tidyselect/man/select_helpers.html)
  are supported.

- m:

  If `TRUE` (the default), missing values are reported.

## Value

A tibble containing a table of frequencies for the variables listed in
`...`

## Details

If a single variable is passed to `tab()`, a table of frequencies is
printed (with a total row and columns 'Freq.', 'Percent', and 'Cum.').

If two variables are passed to `tab()`, a special 2x2 contingency table
is printed (with a total row and a total column).

If three or more variables are passed to `tab()`, a flat contingency
table is printed (with columns 'Freq.', 'Percent', and 'Cum.').

The invisibly returned tibble excludes total rows and columns to avoid
collision of variable classes.

## See also

The statar package by Matthieu Gomez provides a `tab()` function with
output similar to tidytab's `ftab()`. Both packages use a variant of
[`statascii()`](https://github.com/gvelasq/statascii) to format tables
for display in the `R` console. Differences between the packages
include:

- tidytab supports select helpers from
  [dplyr](https://dplyr.tidyverse.org/reference/select.html) and
  [tidyselect](https://tidyselect.r-lib.org/reference/language.html).

- tidytab displays tables in colors: dark grey for block drawing
  characters and red for `NA`s.

- tidytab allows for tabulation of named and unnamed vectors.

- tidytab implements automatic table wrapping for tables wider than the
  `R` console.

- tidytab's `tab()` and `ftab()` display a total row with total
  frequencies for one-way tabulations.

- tidytab's `tab()` displays a special 2x2 contingency table for two-way
  tabulations (flat two-way tables are available with `ftab()`).

- tidytab's convenience functions `tab1()` and `tab2()` allow for rapid
  tabulation of a set of variables into either one- or two-way tables.

The janitor package by Sam Firke provides the `tabyl()` function for
SPSS-like tables of frequencies and adornments.

Base `R` provides the [`ftable()`](https://rdrr.io/r/stats/ftable.html)
and [`xtabs()`](https://rdrr.io/r/stats/xtabs.html) functions for
unadorned tables of frequencies.

## Examples

``` r
# one-way table of frequencies
mtcars |> tab(cyl)
#>         cyl │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           4 │         11        34.4        34.4 
#>           6 │          7        21.9        56.2 
#>           8 │         14        43.8       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0            

# two-way table of frequencies (a special 2x2 contingency table)
mtcars |> tab(cyl, gear)
#>            │      gear                       │           
#>        cyl │         3          4          5 │     Total 
#> ───────────┼─────────────────────────────────┼──────────
#>          4 │         1          8          2 │        11 
#>          6 │         2          4          1 │         7 
#>          8 │        12          0          2 │        14 
#> ───────────┼─────────────────────────────────┼──────────
#>      Total │        15         12          5 │        32 

# flat contingency tables of three (or more) variables
mtcars |> tab(cyl, gear, am)
#>         cyl │       gear          am       Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────────────────────────────
#>           4 │          3           0           1         3.1         3.1 
#>           4 │          4           0           2         6.2         9.4 
#>           4 │          4           1           6        18.8        28.1 
#>           4 │          5           1           2         6.2        34.4 
#> ------------┼-----------------------------------------------------------
#>           6 │          3           0           2         6.2        40.6 
#>           6 │          4           0           2         6.2        46.9 
#>           6 │          4           1           2         6.2        53.1 
#>           6 │          5           1           1         3.1        56.2 
#> ------------┼-----------------------------------------------------------
#>           8 │          3           0          12        37.5        93.8 
#>           8 │          5           1           2         6.2       100.0 

# tables wider than the R console are automatically wrapped
mtcars |> tab(cyl, gear, am, vs)
#>         cyl │       gear          am          vs       Freq.     Percent
#> ────────────┼───────────────────────────────────────────────────────────
#>           4 │          3           0           1           1         3.1
#>           4 │          4           0           1           2         6.2
#>           4 │          4           1           1           6        18.8
#>           4 │          5           1           0           1         3.1
#>           4 │          5           1           1           1         3.1
#> ------------┼-----------------------------------------------------------
#>           6 │          3           0           1           2         6.2
#>           6 │          4           0           1           2         6.2
#>           6 │          4           1           0           2         6.2
#>           6 │          5           1           0           1         3.1
#> ------------┼-----------------------------------------------------------
#>           8 │          3           0           0          12        37.5
#>           8 │          5           1           0           2         6.2
#> 
#>         cyl │        Cum.
#> ────────────┼────────────
#>           4 │         3.1
#>           4 │         9.4
#>           4 │        28.1
#>           4 │        31.2
#>           4 │        34.4
#> ------------┼------------
#>           6 │        40.6
#>           6 │        46.9
#>           6 │        53.1
#>           6 │        56.2
#> ------------┼------------
#>           8 │        93.8
#>           8 │       100.0

# missing values are displayed in red
tab(letters[24:27])
#>   letters[24:27] │      Freq.     Percent        Cum. 
#> ─────────────────┼───────────────────────────────────
#>                x │          1        25.0        25.0 
#>                y │          1        25.0        50.0 
#>                z │          1        25.0        75.0 
#>               NA │          1        25.0       100.0 
#> ─────────────────┼───────────────────────────────────
#>            Total │          4       100.0            

# ftab() displays only flat contingency tables (here, with two variables)
mtcars |> ftab(cyl, gear)
#>         cyl │       gear       Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────────────────
#>           4 │          3           1         3.1         3.1 
#>           4 │          4           8        25.0        28.1 
#>           4 │          5           2         6.2        34.4 
#> ------------┼-----------------------------------------------
#>           6 │          3           2         6.2        40.6 
#>           6 │          4           4        12.5        53.1 
#>           6 │          5           1         3.1        56.2 
#> ------------┼-----------------------------------------------
#>           8 │          3          12        37.5        93.8 
#>           8 │          5           2         6.2       100.0 

# tab1() displays one-way tables for each variable
mtcars |> tab1(cyl, gear)
#>         cyl │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           4 │         11        34.4        34.4 
#>           6 │          7        21.9        56.2 
#>           8 │         14        43.8       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0            
#> 
#>        gear │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           3 │         15        46.9        46.9 
#>           4 │         12        37.5        84.4 
#>           5 │          5        15.6       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0            

# tab2() displays two-way tables for all variable combinations
mtcars |> tab2(cyl, gear, am)
#>            │      gear                       │           
#>        cyl │         3          4          5 │     Total 
#> ───────────┼─────────────────────────────────┼──────────
#>          4 │         1          8          2 │        11 
#>          6 │         2          4          1 │         7 
#>          8 │        12          0          2 │        14 
#> ───────────┼─────────────────────────────────┼──────────
#>      Total │        15         12          5 │        32 
#> 
#>            │        am            │           
#>        cyl │         0          1 │     Total 
#> ───────────┼──────────────────────┼──────────
#>          4 │         3          8 │        11 
#>          6 │         4          3 │         7 
#>          8 │        12          2 │        14 
#> ───────────┼──────────────────────┼──────────
#>      Total │        19         13 │        32 
#> 
#>            │        am            │           
#>       gear │         0          1 │     Total 
#> ───────────┼──────────────────────┼──────────
#>          3 │        15          0 │        15 
#>          4 │         4          8 │        12 
#>          5 │         0          5 │         5 
#> ───────────┼──────────────────────┼──────────
#>      Total │        19         13 │        32 
#> 
```
