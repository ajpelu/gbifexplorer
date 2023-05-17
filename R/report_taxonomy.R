#' Creates a report for a taxa rank
#'
#' Generate a summary report of the taxonomy of a taxa rank
#'
#' @param x A data frame or tibble containing the frequency information of the taxa rank.
#'          It must have columns 'n' and 'freq'. This dataframe typically generated
#'          from [gbifexplorer::taxonomic_cov()]
#' @param top The number of top taxa to include in the report.
#'            Default value is 5.
#'
#' @details This function generates a report based on the input data frame 'x'
#'          containing frequency information of certain taxa rank. It provides
#'          information about the most represented taxa.
#'
#' @return A character string representing the generated report.
#'
#' @examples
#' # Example usage
#' data(borreguiles)
#' # Calculate taxonomic coverage for scientificName and genus
#' d <- taxonomic_cov(borreguiles, category = c("scientificName", "genus"))
#' # Generate report
#' report_taxonomy(d$genus)
#'
#' @export
#' @import glue

report_taxonomy <- function(x, top = 5){

  if (!inherits(x, 'data.frame')) {
    stop("Argument 'x' must be a data frame")
  }

  if (!is.numeric(top) || top < 1) {
    stop("Argument 'top' must be a positive numeric value")
  }

  if (!("n" %in% names(x)) || !("freq" %in% names(x))) {
    stop("Input data frame 'x' must have columns 'n' and 'freq'")
  }

  taxa_rank <- names(x)[!names(x) %in% c("n", "freq")]
  unique_taxa <- unique(x[[taxa_rank]])
  n_taxa <- length(unlist(unique_taxa))

  if (n_taxa == 1) {
    glue::glue('
             All records belong to the {taxa_rank} {unique_taxa}
           ')
  } else {
    if (n_taxa < top) {
      top <- n_taxa
      }

    x$value <- paste0("(", round(x$freq, 2), " %)")
    x$message <- do.call(paste,  c(x[c(taxa_rank, "value")], sep = " "))
    x_subset <- x[1:top, ]

    represented <- glue::glue_collapse(x_subset$message, sep = ", ", last = " and ")

    glue::glue('
             There are {n_taxa} {taxa_rank} included in the dataset. The {top} {taxa_rank} most represented in the dataset are: {represented}.
           ')
  }
}
