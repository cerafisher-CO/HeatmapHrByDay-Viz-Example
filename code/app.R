library(shiny)
library(ggplot2)
library(dplyr)
library(viridis)
library(lubridate)
library(ggExtra)
library(tidyr)

# ---------------------------------------------------------------------------
# Load and prepare the full dataset once at startup
# ---------------------------------------------------------------------------
load("/data/temps/Trentino_hourly_T.RData")
names(h_d_t)[1:5] <- c("stationid", "date", "hour", "temp", "flag")

all_data <- as_tibble(h_d_t) |>
  mutate(
    date  = ymd(date),
    year  = year(date),
    month = month(date, label = TRUE),
    day   = day(date)
  )

# Clean up objects that came along with the RData but are not needed
extra_objs <- c("h_d_t", "mo_bias", "Tn", "Tx",
                "Th_int_list", "calibration_l", "calibration_shape", "Tm_list")
rm(list = intersect(ls(), extra_objs))

stations <- sort(unique(all_data$stationid))

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Hourly Temperature Heatmap \u2014 Trentino Stations"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId  = "station",
        label    = "Select Station:",
        choices  = stations,
        selected = stations[1]
      ),
      width = 3
    ),
    mainPanel(
      plotOutput("heatmap", height = "620px"),
      width = 9
    )
  )
)

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
server <- function(input, output, session) {

  station_data <- reactive({
    all_data |>
      filter(stationid == input$station) |>
      select(stationid, day, hour, month, year, temp) |>
      fill(temp)   # carry forward the rare missing hourly values
  })

  output$heatmap <- renderPlot({
    df     <- station_data()
    statno <- unique(df$stationid)

    ggplot(df, aes(day, hour, fill = temp)) +
      geom_tile(color = "white", linewidth = 0.1) +
      scale_fill_viridis(name = "Hrly Temps \u00b0C", option = "C") +
      facet_grid(year ~ month) +
      scale_y_continuous(trans = "reverse", breaks = unique(df$hour)) +
      scale_x_continuous(breaks = c(1, 10, 20, 31)) +
      theme_minimal(base_size = 8) +
      labs(
        title = paste("Hourly Temps \u2014 Station", statno),
        x     = "Day",
        y     = "Hour Commencing"
      ) +
      theme(
        legend.position  = "bottom",
        plot.title       = element_text(size = 14, hjust = 0),
        axis.text.y      = element_text(size = 6),
        strip.background = element_rect(colour = "white"),
        axis.ticks       = element_blank(),
        axis.text        = element_text(size = 7),
        legend.title     = element_text(size = 8),
        legend.text      = element_text(size = 6)
      ) +
      ggExtra::removeGrid()
  })
}

shinyApp(ui, server)
