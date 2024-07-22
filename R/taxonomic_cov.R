#' taxonomic_cov
#'
#' It generates the taxonomic coverage of the dataset
#' @param x A dataframe
#' @param category a character vector with taxonomic ranks defined by
#' [DarwinCore](https://dwc.tdwg.org/terms/) standard.
#' #' @param code_unknown a custom string that identified the unclassified records
#' at taxa level (default to NA). If the dataset contains a custom string to
#' identify the unclassified taxa, please specify it here, *e.g.* "unclass.",
#' "unknown". See [taxonomic_freq()]
#'
#' @details It generates the taxonomic coverage of a occurrence dataset. For each
#' category, the record numbers and relative frequencies of each taxa are computed. The
#' category argument could be one of: `scientificName`, `kingdom`, `phylum`, `class`,
#' `order`, `family`, `subfamily` and `genus`. For get coverage in all categories
#' type `all`.
#'
#' @return A named list of tibbles summarizing the taxonomic coverage for each category.
#' @examples
#' # Example usage
#' data(borreguiles)
#' # Calculate taxonomic coverage for scientificName and genus
#' taxonomic_cov(borreguiles, category = c("scientificName", "genus"))
#'
#' @import dplyr
#' @import purrr
#'
#' @export
#'
taxonomic_cov <- function(x,
                          category = c(
                            "scientificName", "kingdom", "phylum", "class",
                            "order", "family", "subfamily", "genus", "all"
                          ),
                          code_unknown = NA) {
  all_categories <- c(
    "scientificName", "kingdom", "phylum", "class",
    "order", "family", "subfamily", "genus", "all"
  )

  if (!inherits(x, "data.frame") && !inherits(x, "tbl_df")) {
    stop("Input 'x' must be a data frame or tibble.")
  }

  if ("all" %in% category && length(category) > 1) {
    stop("Cannot combine 'all' with other categories.\n Please select 'all' categories or a combination of several categories")
  }

  if ("all" %in% category) {
    select_categories <- setdiff(all_categories, "all")
    select_categories <- select_categories[select_categories %in% names(x)]
  } else {
    select_categories <- category
  }

  out <- purrr::set_names(
            purrr::map(select_categories,
                       ~taxonomic_freq(x, category = .x, code_unknown = code_unknown)),
            select_categories)

  return(out)
}
