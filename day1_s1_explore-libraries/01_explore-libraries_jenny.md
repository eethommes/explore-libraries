01\_explore-libraries\_jenny.R
================
ethommes
Wed Jan 31 14:05:53 2018

``` r
## how jenny might do this in a first exploration
## purposely leaving a few things to change later!
```

Which libraries does R search for packages?

``` r
.libPaths()
```

    ## [1] "/Library/Frameworks/R.framework/Versions/3.3/Resources/library"

``` r
## let's confirm the second element is, in fact, the default library
.Library
```

    ## [1] "/Library/Frameworks/R.framework/Resources/library"

``` r
library(fs)
path_real(.Library)
```

    ## /Library/Frameworks/R.framework/Versions/3.3/Resources/library

Installed packages

``` r
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
ipt <- installed.packages() %>%
  as_tibble()

## how many packages?
nrow(ipt)
```

    ## [1] 111

Exploring the packages

``` r
## count some things! inspiration
##   * tabulate by LibPath, Priority, or both
ipt %>%
  count(LibPath, Priority)
```

    ## # A tibble: 3 x 3
    ##                                                          LibPath
    ##                                                            <chr>
    ## 1 /Library/Frameworks/R.framework/Versions/3.3/Resources/library
    ## 2 /Library/Frameworks/R.framework/Versions/3.3/Resources/library
    ## 3 /Library/Frameworks/R.framework/Versions/3.3/Resources/library
    ## # ... with 2 more variables: Priority <chr>, n <int>

``` r
##   * what proportion need compilation?
ipt %>%
  count(NeedsCompilation) %>%
  mutate(prop = n / sum(n))
```

    ## # A tibble: 3 x 3
    ##   NeedsCompilation     n       prop
    ##              <chr> <int>      <dbl>
    ## 1               no    47 0.42342342
    ## 2              yes    59 0.53153153
    ## 3             <NA>     5 0.04504505

``` r
##   * how break down re: version of R they were built on
ipt %>%
  count(Built) %>%
  mutate(prop = n / sum(n))
```

    ## # A tibble: 3 x 3
    ##   Built     n      prop
    ##   <chr> <int>     <dbl>
    ## 1 3.3.0    24 0.2162162
    ## 2 3.3.2    54 0.4864865
    ## 3 3.3.3    33 0.2972973

Reflections

``` r
## reflect on ^^ and make a few notes to yourself; inspiration
##   * does the number of base + recommended packages make sense to you?
##   * how does the result of .libPaths() relate to the result of .Library?
```

Going further

``` r
## if you have time to do more ...

## is every package in .Library either base or recommended?
all_default_pkgs <- list.files(.Library)
all_br_pkgs <- ipt %>%
  filter(Priority %in% c("base", "recommended")) %>%
  pull(Package)
setdiff(all_default_pkgs, all_br_pkgs)
```

    ##  [1] "assertthat"   "backports"    "base64enc"    "BH"          
    ##  [5] "bindr"        "bindrcpp"     "bitops"       "broom"       
    ##  [9] "caTools"      "cellranger"   "cli"          "clipr"       
    ## [13] "clisymbols"   "colorspace"   "crayon"       "curl"        
    ## [17] "desc"         "dichromat"    "digest"       "dplyr"       
    ## [21] "enc"          "evaluate"     "forcats"      "fs"          
    ## [25] "gapminder"    "ggplot2"      "gh"           "git2r"       
    ## [29] "glue"         "gtable"       "haven"        "highr"       
    ## [33] "hms"          "htmltools"    "httr"         "ini"         
    ## [37] "jsonlite"     "knitr"        "labeling"     "lazyeval"    
    ## [41] "lubridate"    "magrittr"     "markdown"     "mime"        
    ## [45] "mnormt"       "modelr"       "munsell"      "pkgconfig"   
    ## [49] "plogr"        "plyr"         "praise"       "psych"       
    ## [53] "purrr"        "R6"           "RColorBrewer" "Rcpp"        
    ## [57] "readr"        "readxl"       "rematch"      "rematch2"    
    ## [61] "reshape2"     "rlang"        "rmarkdown"    "rprojroot"   
    ## [65] "rstudioapi"   "rvest"        "scales"       "selectr"     
    ## [69] "stringi"      "stringr"      "styler"       "testthat"    
    ## [73] "tibble"       "tidyr"        "tidyselect"   "tidyverse"   
    ## [77] "translations" "usethis"      "viridisLite"  "whisker"     
    ## [81] "withr"        "xml2"         "yaml"

``` r
## study package naming style (all lower case, contains '.', etc

## use `fields` argument to installed.packages() to get more info and use it!
ipt2 <- installed.packages(fields = "URL") %>%
  as_tibble()
ipt2 %>%
  mutate(github = grepl("github", URL)) %>%
  count(github) %>%
  mutate(prop = n / sum(n))
```

    ## # A tibble: 2 x 3
    ##   github     n      prop
    ##    <lgl> <int>     <dbl>
    ## 1  FALSE    52 0.4684685
    ## 2   TRUE    59 0.5315315
