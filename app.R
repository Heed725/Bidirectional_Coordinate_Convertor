library(shiny)
library(tidyverse)
library(shinythemes)

# ---------- Conversion Functions ----------
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

# ---------- UI ----------
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

# ---------- Server ----------
server <- function(input, output) {
  data <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    
    # Determine which conversion is needed
    if (all(c("Lat", "Long") %in% names(df))) {
      df$Deci_Lat <- sapply(df$Lat, dms_to_decimal)
      df$Deci_Long <- sapply(df$Long, dms_to_decimal)
    } else if (all(c("Deci_Lat", "Deci_Long") %in% names(df))) {
      df$Lat <- sapply(df$Deci_Lat, function(x) decimal_to_dms(x, is_lat = TRUE))
      df$Long <- sapply(df$Deci_Long, function(x) decimal_to_dms(x, is_lat = FALSE))
    } else {
      stop("CSV must contain either 'Lat' and 'Long' (DMS), or 'Deci_Lat' and 'Deci_Long' (decimal degrees)")
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

# ---------- Run App ----------
shinyApp(ui = ui, server = server)
setwd("C:/Users/user/Documents/DMSApp")
rsconnect::writeManifest()

