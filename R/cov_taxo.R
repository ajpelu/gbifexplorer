#' taxonomic_cov
#'
#' @param x A dataframe
#' @param category taxonomic ranks defined by DarwinCore standard
#'
#' @return
#' @export
#'
#' @examples
taxonomic_cov <- function(x,
                          category = c(
                            "scientificName", "kingdom", "phylum", "class",
                            "order", "family", "subfamily", "genus", "all"
                          )) {
  all_categories <- c(
    "scientificName", "kingdom", "phylum", "class",
    "order", "family", "subfamily", "genus", "all"
  )

  if (category == "all") {
    select_categories <- setdiff(all_categories, category)
    select_categories <- select_categories[select_categories %in% names(occ)]
  } else {
    select_categories <- category
  }

  aux_summary <- function(y) {
    x |>
      group_by(!!!syms(y)) |>
      tally() |>
      mutate(freq = prop.table(n) * 100) |>
      arrange(desc(freq))
  }

  out <- select_categories |>
    purrr::map(aux_summary) |>
    set_names(select_categories)
  return(out)
}
