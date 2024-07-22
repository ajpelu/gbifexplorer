#' taxonomic_freq
#'
#' Compute the count and frequence of a taxonomic category
#' @param x A dataframe
#' @param category a character vector with taxonomic ranks defined by
#' [DarwinCore](https://dwc.tdwg.org/terms/) standard. One of `kingdom`,
#' `phylum`, `class`, `order`, `family`, `subfamily`, `genus`, `scientificName`
#' @param code_unknown a custom string that identified the unclassified records
#' at taxa level (default to NA). If the dataset contains a custom string to
#' identify the unclassified taxa, please specify it here, *e.g.* "unclass.",
#' "unknown"
#'
#' @return A tibble with the frequency of records (`n`) by taxonomic category,
#' and:
#'
#' * `freq_all`: percentage of records computed considering all the records
#' (*i.e.* inlcuding the unknown or unclassified taxa)
#' * `freq`: percentage of records computed excluding the unknown or unclassified
#' records
#'
#' @export
#'
taxonomic_freq <- function(x, category, code_unknown = NA){
  n <- freq  <- NULL

  dwc_categories <- c(
    "kingdom", "phylum", "class",
    "order", "family", "subfamily", "genus", "scientificName")

  if(!(category %in% dwc_categories)) {
    stop(paste("category must be one of the:", paste(dwc_categories, collapse = ", ")))
  }

  category <- rlang::sym(category)

  aux <- x |>
    dplyr::group_by(
      dplyr::across(
        dplyr::all_of(category))) |>
    dplyr::tally(sort = TRUE) |>
    dplyr::ungroup()

  dna <- aux |> dplyr::mutate(freq_all = prop.table(n) * 100)

  if(is.na(code_unknown)) {
    d <- aux |> dplyr::filter(!is.na(!!sym(category))) |> dplyr::mutate(freq = prop.table(n) * 100)
  } else {
    d <- aux |> dplyr::filter(!!sym(category) != code_unknown) |> dplyr::mutate(freq = prop.table(n) * 100)
  }

  out <- dplyr::full_join(dna, d)
  return(out)

}
