#!/usr/bin/env Rscript
# Headless render of the hourly-by-day temperature heatmap.
#
# Produces the same figure the Shiny app shows interactively, for one station,
# so the capsule has a non-interactive end-to-end path that completes.
#
# Usage: Rscript render_heatmap.R [station_id]

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(viridis)
  library(lubridate)
  library(ggExtra)
  library(tidyr)
  library(tibble)
})

data_dir    <- "../data"
results_dir <- "../results"

# Locate the input programmatically; the mount layout can change between runs.
candidates <- list.files(data_dir, pattern = "\\.RData$",
                         recursive = TRUE, full.names = TRUE)
if (length(candidates) == 0) {
  stop("No .RData input found under ", normalizePath(data_dir, mustWork = FALSE))
}
input_file <- candidates[1]
message("Using input: ", input_file)

load(input_file)
if (!exists("h_d_t")) {
  stop("Expected object 'h_d_t' was not found in ", input_file)
}
names(h_d_t)[1:5] <- c("stationid", "date", "hour", "temp", "flag")

all_data <- as_tibble(h_d_t) |>
  mutate(
    date  = ymd(date),
    year  = year(date),
    month = month(date, label = TRUE),
    day   = day(date)
  )

args    <- commandArgs(trailingOnly = TRUE)
station <- if (length(args) >= 1 && nzchar(args[1])) {
  args[1]
} else {
  sort(unique(all_data$stationid))[1]
}
if (!station %in% all_data$stationid) {
  stop("Station '", station, "' is not present in the dataset")
}
message("Rendering station: ", station)

df <- all_data |>
  filter(stationid == station) |>
  select(stationid, day, hour, month, year, temp) |>
  fill(temp)   # carry forward the rare missing hourly values

p <- ggplot(df, aes(day, hour, fill = temp)) +
  geom_tile(color = "white", linewidth = 0.1) +
  scale_fill_viridis(name = "Hrly Temps \u00b0C", option = "C") +
  facet_grid(year ~ month) +
  scale_y_continuous(trans = "reverse", breaks = unique(df$hour)) +
  scale_x_continuous(breaks = c(1, 10, 20, 31)) +
  theme_minimal(base_size = 8) +
  labs(
    title = paste("Hourly Temps \u2014 Station", station),
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

dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)
out_file <- file.path(results_dir,
                      paste0("HourlyTemps_Heatmap_", station, ".png"))
ggsave(out_file, plot = p, width = 11, height = 7, dpi = 150)
message("Wrote: ", out_file)
