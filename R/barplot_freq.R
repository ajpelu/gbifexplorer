#' Bar Plot of Frequencies
#'
#' Generate a bar plot of frequencies for taxonomic ranks
#'
#' @param data A data frame or tibble containing the frequency data of the
#' taxonomic rank
#' @param sort_by Character vector specifying the sorting criteria for the bars.
#' Default is "freq". Valid options are "freq" and "name".
#' @param decreasing Logical indicating whether to sort the bars in decreasing
#' order. Default is TRUE.
#' @param flip Logical indicating whether to flip the orientation of the plot.
#' Default is TRUE.
#' @param limit_freq Numeric value specifying the minimum frequency threshold
#' for including a taxa in the plot. Default is NULL, which includes all taxa.
#' @param top Numeric value specifying the maximum number of taxa to include in
#' the plot. Default is NULL, which includes all taxa.
#' @param bar_color Color of the bars. Default is "steelblue".
#' @param show_n Logical indicating whether to display the records number over
#' the bar. Default is FALSE.
#' @param label_color Color of the labels. Default is "white".
#' @param ... Additional arguments to be passed to [ggplot2()] and related functions.
#'
#' @return A ggplot object representing the bar plot of frequencies.
#' @import ggplot2
#' @import dplyr
#' @importFrom forcats fct_reorder
#'
#' @export
#'
barplot_freq <- function(data, sort_by = c("freq", "name"),
                     decreasing = TRUE, flip = TRUE,
                     limit_freq = NULL,
                     top = NULL,
                     bar_color = "steelblue",
                     show_n = FALSE,
                     label_color = "white", ...) {

  if (!inherits(data, c("data.frame", "tbl_df", "tbl"))) {
    stop("Invalid 'data' argument. Must be a data.frame or tibble.")
  }

  if (missing(sort_by) || is.null(sort_by) || length(sort_by) == 0) {
    sort_by <- "freq"
  } else if (!is.character(sort_by) || !(sort_by %in% c("freq", "name"))) {
    stop("Invalid 'sort_by' argument. Must be either 'freq' or 'name'.")
  }


  var_name <- setdiff(names(data), c("freq", "n"))

  if (!is.null(limit_freq)) {
    data <- subset(data, freq >= limit_freq)
  }

  if (!is.null(top)) {
    data <- data[order(-data$freq), ]
    data <- data[1:top, ]
    }


  if (sort_by == "freq") {
    g <- ggplot(data,
                aes(x = forcats::fct_reorder(!!sym(var_name), -freq, .desc = decreasing),
                    y = freq)) +
      geom_col(fill = bar_color, ...)
  } else if (sort_by == "name") {
    g <- ggplot(data,
                aes(x = forcats::fct_reorder(!!sym(var_name), !!sym(var_name), .desc = decreasing),
                    y = freq)) +
      geom_col(fill = bar_color, ...)
  }

  if (show_n) {
    g <- g + geom_text(aes(label = n), hjust = 1.5, colour = label_color, ...)
  }

  if (flip) {
    g <- g + coord_flip()
  }


  g <- g + xlab("") + ylab("% Records") + theme_bw()

  return(g)
}


