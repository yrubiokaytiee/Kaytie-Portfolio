# 3C finished

# Load libraries
library(tidyverse)
library(lubridate)

data <- read.csv2("Final_database.csv", stringsAsFactors = FALSE)

# CI bounds to numeric
data$lci <- as.numeric(gsub(",", "", data$lci))
data$hci <- as.numeric(gsub(",", "", data$hci))

# Remove invalid CI
data <- data %>%
  filter(!is.na(lci), !is.na(hci)) %>%
  filter(hci > lci)

# Calculate CI width
data$ci_width <- data$hci - data$lci

#  reasonable CI widths (remove some outliers)
data <- data %>%
  filter(ci_width > 0.05 & ci_width < 3)

data$year_month <- as.Date(paste0(data$year, "-", data$month, "-01"))

abstract_level <- data %>%
  group_by(pmid) %>%
  summarise(
    year_month = first(year_month),
    max_ci = max(ci_width),
    mean_ci = mean(ci_width),
    min_ci = min(ci_width)
  )

monthly_cis <- abstract_level %>%
  group_by(year_month) %>%
  summarise(
    `Maximal magnitude per abstract` = median(max_ci),
    `Mean magnitude per abstract` = median(mean_ci),
    `Minimal magnitude per abstract` = median(min_ci)
  ) %>%
  pivot_longer(cols = c(`Maximal magnitude per abstract`,
                        `Mean magnitude per abstract`,
                        `Minimal magnitude per abstract`),
               names_to = "type", values_to = "ci_value")

# Plot
ggplot(monthly_cis, aes(x = year_month, y = ci_value, color = type, shape = type)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "loess", span = 0.6, se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c(
    "Maximal magnitude per abstract" = "#08519c",
    "Mean magnitude per abstract" = "#636363",
    "Minimal magnitude per abstract" = "#6baed6"
  )) +
  scale_shape_manual(values = c(17, 16, 25)) +
  labs(
    title = "Monthly Medians of CI Magnitudes by Abstract",
    x = "Year",
    y = "Monthly medians of CI magnitudes (T#3)",
    color = "Outcomes related to CI magnitudes",
    shape = "Outcomes related to CI magnitudes"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )

