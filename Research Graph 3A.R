#3a finished

library(tidyverse)
library(lubridate)
library(scales)

data <- read.csv2("Final_database.csv", stringsAsFactors = FALSE)

#this was the as.numeric code had issues converting
data$es <- as.numeric(gsub(",", "", data$es))

data <- data %>%
  filter(!is.na(es), es > 0, !is.na(year), !is.na(month)) %>%
  mutate(
    year_month = as.Date(paste0(year, "-", month, "-01")),
    year_bin = floor_date(year_month, "month"),
    log_es = log10(es),
    log_es_bin = round(log_es, 1)
  )

monthly_bins <- data %>%
  group_by(year_bin, log_es_bin) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(year_bin) %>%
  mutate(monthly_prop = 100 * count / sum(count)) %>%
  ungroup()

# proportions
overall_bins <- data %>%
  group_by(log_es_bin) %>%
  summarise(overall_prop = 100 * n() / nrow(data))

# Merge (no filtering this time!)
plot_data <- left_join(monthly_bins, overall_bins, by = "log_es_bin")

# dont use this
#plot_data <- left_join(monthly_bins, overall_bins, by = "log_es_bin") %>%
  #filter(round(log_es_bin, 2) %in% c(0.00, 0.08, 0.34, 0.75, 2.00))


# Plot
ggplot(plot_data, aes(x = year_bin, y = 10^log_es_bin)) +
  geom_tile(aes(fill = monthly_prop), width = 30, height = 0.12) +
  geom_point(
    aes(size = overall_prop),
    shape = 21,
    stroke = 0.1,
    color = "black",
    fill = "black",
    alpha = 0.1  # ✅ softens the dot appearance
  ) +
  scale_y_log10(
    breaks = c(1, 1.2, 2.2, 5.6, 100),
    labels = c("1", "1.2", "2.2", "5.6", "100"),
    limits = c(1, 100),
    expand = c(0.01, 0.01)
  ) +
  scale_fill_gradientn(
    colors = c("blue", "cyan", "green", "yellow", "red", "dark red"),
    values = rescale(c(0, 5, 10, 15, 20)),
    limits = c(0, 20),
    breaks = c(0, 5, 10, 15, 20),
    name = "Monthly relative\nproportions (%)"
  ) +
  scale_size(
    range = c(1, 4),
    breaks = c(0.5, 1, 1.5),
    name = "Overall relative\nproportions (%)"
  ) +
  guides(
    size = guide_legend(order = 1, override.aes = list(shape = 21, fill = "grey", stroke = 0.3)), #grey may be incorrect change if needed
    fill = guide_colorbar(order = 2)
  ) +
  labs(
    title = "Distribution of Effect Sizes Over Time",
    x = "Year",
    y = "ESs (T#1)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.title.y = element_text(face = "bold"),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right",
    legend.key.size = unit(0.5, "cm"),
    legend.title = element_text(size = 11, face = "bold"),
    legend.text = element_text(size = 9)
  )

