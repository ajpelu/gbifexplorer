#' App to generate taxonomic report
#'
#' @examples
#' \dontrun{
#' data(borreguiles)
#' taxo_reportApp()
#'}
#'
#' @import shiny
#' @export
taxo_reportApp <- function() {

  n <- freq  <- NULL

  # UI
  ui <- fluidPage(
    titlePanel("Taxonomic Coverage Report"),
    sidebarLayout(
      sidebarPanel(
        fileInput("file", "Upload CSV or TXT file", accept = c(".csv", ".txt")),
        checkboxGroupInput("categories", "Select Taxonomic Categories",
                           choices = c("kingdom", "phylum", "class",
                                       "order", "family", "genus", "scientificName", "all"),
                           selected = "family"),
        actionButton("generateReport", "Generate Report")
      ),
      mainPanel(
        uiOutput("report")  # Display the report
      )
    )
  )

  # Server
  server <- function(input, output, session) {
    uploadedData <- reactiveVal(NULL)

    observeEvent(input$file, {
      req(input$file)

      # Read the uploaded file
      data_value <- read.csv(input$file$datapath)

      # Check the file extension
      ext <- tools::file_ext(input$file$name)

      if (ext == "txt") {
        # If the file is a TXT, treat it as a CSV with tab delimiter
        data_value <- read.delim(input$file$datapath, sep = "\t")
      }

      uploadedData(data_value)
    })

    observeEvent(input$categories, {
      if ("all" %in% input$categories) {
        # Select all checkboxes
        updateCheckboxGroupInput(session, "categories", selected = c("scientificName", "kingdom", "phylum", "class", "order", "family", "genus", "all"))
      }
    })

    generateReport <- function() {
      req(uploadedData())

      categories <- input$categories

      if (length(categories) == 0) {
        return("Please select at least one taxonomic category.")
      }

      if ("all" %in% categories) {
        # If "all" is selected, generate report for all categories
        categories <- setdiff(categories, "all")
        coverage <- taxonomic_cov(uploadedData(), category = categories)

        reports <- lapply(categories, function(category) {
          if (category %in% names(coverage)) {
            report <- report_taxonomy(coverage[[category]])
            glue::glue("<b>{category}:</b>\n{report}")
          } else {
            glue::glue("<b>{category}:</b> Not available in the dataset.")
          }
        })
      } else {
        # Generate report for selected categories
        coverage <- taxonomic_cov(uploadedData(), category = categories)

        reports <- lapply(categories, function(category) {
          if (category %in% names(coverage)) {
            report <- report_taxonomy(coverage[[category]])
            glue::glue("<b>{category}:</b>\n{report}")
          } else {
            glue::glue("<b>{category}:</b> Not available in the dataset.")
          }
        })
      }

      paste(reports, collapse = "<br><br>")
    }

    observeEvent(input$generateReport, {
      output$report <- renderUI({
        HTML(generateReport())
      })
    })
  }

  # Run the app with increased maxRequestSize
  options(shiny.maxRequestSize = 30*1024^2)  # Set maximum upload size to 30 MB
  shinyApp(ui, server)
}

