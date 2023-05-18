
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gbifexploreR

<!-- badges: start -->

[![R-CMD-check](https://github.com/ajpelu/gbifexplorer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ajpelu/gbifexplorer/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/ajpelu/gbifexplorer/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ajpelu/gbifexplorer?branch=master)
<!-- badges: end -->

The goal of gbifexplorer is provide some tools to explore the different
types of [gfbif dataset classes](https://www.gbif.org/dataset-classes):
Occurrence, Sampling-event or Checklist. `gbifexplorer` allows to
explore the taxonomic, temporal and/or spatial coverages of the gbif
datasets.

## Installation

You can install the development version of gbifexplorer from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ajpelu/gbifexplorer")
```

## Usage

The `gbifexplorer` package provides several functions for exploring and
analyzing occurrence data from the Global Biodiversity Information
Facility (GBIF). Here is an example of the usage of three key functions:
`cov_temporal`, `taxonomic_cov`, and `report_taxonomy`.

We will use a dataset contains information about the phenology of flora
in Mediterranean high-mountains meadows in the Sierra Nevada region
(Spain). This dataset is deposited in
[GBIF](https://doi.org/10.15468/qhqzub) and also published as [Data
Paper](https://doi.org/10.3897/phytokeys.46.9116). It also is included
as example data in the `gbifexplorer` pkg.

### Calculate the Temporal Coverage of an Ocurrence Dataset

The `gbifexplorer::cov_temporal()` function calculates the temporal
coverage of a dataset based on a specified date variable provided by the
user. It determines the minimum and maximum dates from the date variable
and returns them in a data frame.

``` r
library(gbifexplorer)
data("borreguiles")

# Calculate temporal coverage
temporal_coverage <- cov_temporal(borreguiles, date_var = "eventDate", 
                                  date_format = "%Y-%m-%d")
#> The temporal coverage of the dataset is 1988-05-18 to 2013-10-17.
```

It returns a data frame (`temporal_coverage`) that contains the minimum
and maximum dates from the dataset. This function also prints the
temporal coverage as text and could be used to document the metadata of
the dataset.

## Get the Taxonomic Coverage of an Ocurrence Dataset and report it.

The `gbifexplorer::taxonomic_cov()` function generates the taxonomic
coverage of a dataframe. It calculates the record numbers and relative
frequencies of each taxonomic category specified, allowing to compute
the taxonomic coverage of an occurence dataset. The function returns a
named list of tibbles summarizing the taxonomic coverage for each
category.

``` r
# Calculate taxonomic coverage for scientificName and genus
d <- taxonomic_cov(borreguiles, category = c("class", "order"))
d
#> $class
#> # A tibble: 3 × 3
#>   class             n   freq
#>   <chr>         <int>  <dbl>
#> 1 Magnoliopsida  6057 55.1  
#> 2 Liliopsida     4882 44.4  
#> 3 Psilotopsida     63  0.573
#> 
#> $order
#> # A tibble: 19 × 3
#>    order              n     freq
#>    <chr>          <int>    <dbl>
#>  1 Poales          4869 44.3    
#>  2 Lamiales        1378 12.5    
#>  3 Fabales         1190 10.8    
#>  4 Asterales       1032  9.38   
#>  5 Gentianales      996  9.05   
#>  6 Ranunculales     460  4.18   
#>  7 Caryophyllales   425  3.86   
#>  8 Celastrales      209  1.90   
#>  9 Malpighiales     200  1.82   
#> 10 Ericales         103  0.936  
#> 11 Ophioglossales    63  0.573  
#> 12 Apiales           31  0.282  
#> 13 Saxifragales      17  0.155  
#> 14 Boraginales        9  0.0818 
#> 15 Liliales           8  0.0727 
#> 16 Asparagales        5  0.0454 
#> 17 Brassicales        3  0.0273 
#> 18 Rosales            3  0.0273 
#> 19 Myrtales           1  0.00909
```

The result is a list contains tibbles summarizing the taxonomic coverage
for each taxonomic category.

Then, it is possible to generate a Report for different taxa categories
by using the `gbifexplorer::report_taxonomy()` function. It generates a
summary report of the taxonomy of a specified taxa rank, and provides
information about the most represented taxa based on the frequency
information of the taxa rank. The default is the top 5 most represented
taxa but is could be change using the argument `top`

For instance, if you are interested in the 5 most frequent order:

``` r
report_taxonomy(d$order, top = 5)
#>   There are 19 order included in the dataset. The 5 order most represented in the dataset are: Poales (44.26 %), Lamiales (12.52 %), Fabales (10.82 %), Asterales (9.38 %) and Gentianales (9.05 %).
```

The user might also be interested in calculate the taxonomic coverage
for all taxonomic categories present in an occurrence dataset. For this,
we also used the `purrr` package

``` r
library(purrr)
all_taxa <- taxonomic_cov(borreguiles, category = "all")

all_taxa |> 
  purrr::map(~report_taxonomy(., top=10)) |> 
  purrr::list_transpose()
#> [[1]]
#>   There are 94 scientificName included in the dataset. The 10 scientificName most represented in the dataset are: Nardus stricta L. (9.35 %), Carex nigra (L.) Reichard (6.67 %), Euphrasia willkommii Freyn (6.47 %), Lotus corniculatus L. subsp. glacialis (Boiss.) Valdés (5.49 %), Scorzoneroides (5.32 %), Eleocharis quinqueflora (Hartmann) O.Schwarz (4.54 %), Festuca iberica (Hack.) Patzke (4.46 %), Carex nevadensis Boiss. & Reut. (4.38 %), Gentiana boryi Boiss. (3.7 %) and Plantago nivalis Jord. (2.92 %).
#> 
#>   All records belong to the kingdom Plantae
#>   There are 2 phylum included in the dataset. The 2 phylum most represented in the dataset are: Magnoliophyta (99.43 %) and Pteridophyta (0.57 %).
#> 
#>   There are 3 class included in the dataset. The 3 class most represented in the dataset are: Magnoliopsida (55.05 %), Liliopsida (44.37 %) and Psilotopsida (0.57 %).
#> 
#>   There are 19 order included in the dataset. The 10 order most represented in the dataset are: Poales (44.26 %), Lamiales (12.52 %), Fabales (10.82 %), Asterales (9.38 %), Gentianales (9.05 %), Ranunculales (4.18 %), Caryophyllales (3.86 %), Celastrales (1.9 %), Malpighiales (1.82 %) and Ericales (0.94 %).
#> 
#>   There are 28 family included in the dataset. The 10 family most represented in the dataset are: Cyperaceae (21.12 %), Poaceae (19.52 %), Fabaceae (10.82 %), Asteraceae (9.01 %), Gentianaceae (8.82 %), Scrophulariaceae (7.22 %), Ranunculaceae (4.18 %), Caryophyllaceae (3.75 %), Juncaceae (3.61 %) and Plantaginaceae (2.92 %).
#> 
#>   There are 52 genus included in the dataset. The 10 genus most represented in the dataset are: Carex (16.58 %), Nardus (9.35 %), Scorzoneroides (9 %), Gentiana (8.8 %), Euphrasia (6.47 %), Lotus (5.49 %), Trifolium (5.33 %), Festuca (4.77 %), Eleocharis (4.54 %) and Agrostis (4.44 %).
```

## Interctive app

We also have developed a shiny app to allow the user to generate the
taxonomic coverage of an occurence data. To run the app:

``` r
library("gbifexplorer")
gbifexplorer::taxo_reportApp()
```
