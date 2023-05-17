#' Calculate the temporal Coverage
#'
#' This function calculates the temporal coverage of a dataset (occurrences, events, or similar) based on a specified date variable.
#'
#' @param x A data frame.
#' @param date_var The name of the date variable column in the data frame.
#' @param date_format The format of the date variable (optional).
#' @param tryFormats A vector of possible date formats to try if the date variable is not in a standard format.
#' @param report Logical value indicating whether to print the temporal coverage report.
#'
#' @return A data frame with the minimum and maximum dates from the date variable.
#'
#' @details If the \code{date_format} argument is not specified, the function will attempt to determine the format
#' of the date variable automatically using the \code{tryFormats} vector. If the date variable is not in a standard
#' format, an error will be thrown.
#'
#' @examples
#'
#' data("borreguiles")
#' cov_temporal(borreguiles, date_var = "eventDate", report = TRUE)
#'
#' @export

cov_temporal <- function(x,
                         date_var,
                         date_format = NULL,
                         tryFormats = c("%Y-%m-%d", "%Y/%m/%d"),
                         report = TRUE) {
  if (missing(date_var)) {
    stop("Argument 'date_var' must be specified")
  }

  if (is.null(date_format)) {
    warning("The argument date_format is not specified. A default format is assumed. See function's details")
  }

  # Select the date column
  d <- x[, date_var]

  # Check if the selected column has date format
  if (inherits(d, "Date")) {
    df <- d
  } else {
    # try to format using the date_format
    if (!is.null(date_format)) {
      df <- as.Date(d, format = date_format)
    } else {
      formatted <- FALSE
      for (f in tryFormats) {
        if (!is.na(as.Date(d[1L], format = f))) {
          df <- as.Date(d, format = f)
          formatted <- TRUE
          break
        }
      }
    }
  }

  dates <- data.frame(
    min_date = min(df),
    max_date = max(df)
  )


  if (report == TRUE) {
    report_text <- glue::glue("The temporal coverage of the dataset is {dates$min_date} to {dates$max_date}.")
    print(report_text)
  }

  return(dates)
}

