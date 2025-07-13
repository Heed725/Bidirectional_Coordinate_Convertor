# Load libraries
library(shiny)
library(tidyverse)
library(shinythemes)
library(jsonlite)

# ============ Helper Functions ============

# Convert DMS to Decimal Degrees
dms_to_decimal <- function(dms_string) {
  parts <- str_match(dms_string, "(\\d+)[°](\\d+)['](\\d+)[\"]\\s*([NSEW])")
  degrees <- as.numeric(parts[,2])
  minutes <- as.numeric(parts[,3])
  seconds <- as.numeric(parts[,4])
  direction <- parts[,5]
  decimal <- degrees + (minutes / 60) + (seconds / 3600)
  if (direction %in% c("S", "W")) decimal <- -decimal
  return(decimal)
}

# Convert Decimal Degrees to DMS
decimal_to_dms <- function(decimal, is_lat = TRUE) {
  dir <- if (is_lat) ifelse(decimal < 0, "S", "N") else ifelse(decimal < 0, "W", "E")
  decimal <- abs(decimal)
  d <- floor(decimal)
  m <- floor((decimal - d) * 60)
  s <- round((((decimal - d) * 60 - m) * 60), 0)
  sprintf("%d°%d'%d\" %s", d, m, s, dir)
}

# ============ UI ============

ui <- fluidPage(
  theme = shinytheme("cerulean"),
  titlePanel("🌍 Bi-Directional Coordinate Converter: DMS ↔ Decimal Degrees"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "📤 Upload CSV File:", accept = ".csv"),
      tags$hr(),
      helpText("Upload a file with either:"),
      tags$ul(
        tags$li("'Lat' and 'Long' in DMS format (e.g. 6°49'12\" S)"),
        tags$li("'Deci_Lat' and 'Deci_Long' in decimal degrees")
      ),
      downloadButton("downloadData", "⬇️ Download Converted CSV"),
      br(), br(),
      tags$small("Built with ❤️ by Hemed Lungo")
    ),
    mainPanel(
      h4("📋 Preview of Converted Data"),
      tableOutput("contents")
    )
  )
)

# ============ Server ============

server <- function(input, output, session) {
  data <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    if (all(c("Lat", "Long") %in% names(df))) {
      df$Deci_Lat <- sapply(df$Lat, dms_to_decimal)
      df$Deci_Long <- sapply(df$Long, dms_to_decimal)
    } else if (all(c("Deci_Lat", "Deci_Long") %in% names(df))) {
      df$Lat <- sapply(df$Deci_Lat, function(x) decimal_to_dms(x, is_lat = TRUE))
      df$Long <- sapply(df$Deci_Long, function(x) decimal_to_dms(x, is_lat = FALSE))
    } else {
      stop("CSV must contain either 'Lat'/'Long' or 'Deci_Lat'/'Deci_Long'.")
    }
    return(df)
  })

  output$contents <- renderTable({ data() })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("converted_coordinates_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
}

# ============ Manifest Writer (optional) ============

write_manifest <- function() {
  manifest <- list(
    version = 1,
    locale = "en",
    platform = "R",
    metadata = list(
      appmode = "shiny",
      primary_document = "app.R"
    ),
    packages = list(
      list(name = "shiny", version = "1.5.0"),
      list(name = "tidyverse", version = "1.3.0"),
      list(name = "shinythemes", version = "1.1.2"),
      list(name = "rsconnect", version = "0.8.16")
    ),
    r_version = "4.0.0"
  )

  write_json(manifest, "manifest.json", auto_unbox = TRUE, pretty = TRUE)
  message("✅ manifest.json written successfully.")
}

# Write manifest only if running interactively (to avoid it running on shinyapps.io)
if (interactive()) {
  write_manifest()
}

# ============ Run App ============
shinyApp(ui = ui, server = server)
