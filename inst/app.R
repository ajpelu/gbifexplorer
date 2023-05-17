library(shiny)
library(dplyr)
library(glue)

# UI
ui <- fluidPage(
  titlePanel("Taxonomic Coverage Report"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV or TXT file", accept = c(".csv", ".txt")),
      checkboxGroupInput("categories", "Select Taxonomic Categories",
                         choices = c("scientificName", "kingdom", "phylum", "class",
                                     "order", "family", "subfamily", "genus", "all"),
                         selected = "scientificName"),
      actionButton("generateReport", "Generate Report")
    ),
    mainPanel(
      textOutput("report")
    )
  )
)

# Server
server <- function(input, output, session) {
  data <- reactiveVal(NULL)

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

    data(data_value)
  })

  generateReport <- function() {
    req(data())

    categories <- input$categories

    if (length(categories) == 0) {
      return("Please select at least one taxonomic category.")
    }

    if ("all" %in% categories && length(categories) > 1) {
      return("Cannot combine 'all' with other categories.\nPlease select 'all' categories or a combination of several categories.")
    }

    coverage <- taxonomic_cov(data(), category = categories)

    reports <- lapply(categories, function(category) {
      if (category %in% names(coverage)) {
        report <- report_taxonomy(coverage[[category]])
        glue::glue("{category}: {report}")
      } else {
        glue::glue("{category}: Not available in the dataset.")
      }
    })

    paste(reports, collapse = "\n\n")
  }

  observeEvent(input$generateReport, {
    output$report <- renderText({
      generateReport()
    })
  })
}

# Run the app with increased maxRequestSize
options(shiny.maxRequestSize = 30*1024^2)  # Set maximum upload size to 30 MB
shinyApp(ui, server)
