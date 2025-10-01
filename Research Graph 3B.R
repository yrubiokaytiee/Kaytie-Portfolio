# 3B finished 
library(tidyverse)
library(lubridate)

data <- read.csv2("Final_database.csv", stringsAsFactors = FALSE)

# effect size column to numeric
data$es <- as.numeric(gsub(",", "", data$es))

# remove the na's
data <- data %>%
  filter(!is.na(es))

data$year_month <- as.Date(paste0(data$year, "-", data$month, "-01"))

abstract_level <- data %>%
  group_by(pmid) %>%
  summarise(
    year_month = first(year_month),
    max_es = max(es),
    mean_es = mean(es),
    min_es = min(es)
  )

monthly_es <- abstract_level %>%
  group_by(year_month) %>%
  summarise(
    `Maximal value per abstract` = median(max_es),
    `Mean value per abstract` = median(mean_es),
    `Minimal value per abstract` = median(min_es)
  ) %>%
  pivot_longer(cols = c(`Maximal value per abstract`,
                        `Mean value per abstract`,
                        `Minimal value per abstract`),
               names_to = "type", values_to = "es_value")

# Plot
ggplot(monthly_es, aes(x = year_month, y = es_value, color = type, shape = type)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "loess", span = 0.6, se = FALSE, linewidth = 1.2) +
  scale_color_manual(values = c(
    "Maximal value per abstract" = "#08519c",
    "Mean value per abstract" = "#636363",
    "Minimal value per abstract" = "#6baed6"
  )) +
  scale_shape_manual(values = c(17, 16, 25)) +
  labs(
    title = "Monthly Medians of Effect Sizes by Abstract",
    x = "Year",
    y = "Monthly medians of ESs (T#3)",
    color = "ES Outcomes",
    shape = "ES Outcomes"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )

