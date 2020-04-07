# install_github("RamiKrispin/coronavirus")
library(coronavirus)
library(tidyverse)
library(ggrepel)
library(DT)
library(knitr)
library(glue)

# set countries of interest ----------------------------------------------------

countries <- c(
  "France", 
  "United Kingdom", 
  "US", 
  "Turkey", 
  "China"
)

# prepare data for countries and type of interest ------------------------------

country_data <- coronavirus %>%
  # filter for deaths in countries of interest
  filter(
    type == "death",
    Country.Region %in% countries
    ) %>%
  # fix county labels for pretty plotting
  mutate(
    country = case_when(
      Country.Region == "United Kingdom" ~ "UK",
      TRUE                               ~ Country.Region
    )
  ) %>%
  # calculate cumulative cases
  group_by(country, date) %>%
  summarise(tot_cases = sum(cases)) %>%
  arrange(date) %>%
  mutate(cumulative_cases = cumsum(tot_cases)) %>%
  # only use data where cumulative cases > 10
  filter(cumulative_cases > 9) %>%
  # calculate days elapsed and label for last recorded date for country
  mutate(
    days_elapsed = as.numeric(date - min(date)),
    end_label = ifelse(date == max(date), country, NA)
    )

# calculate as of date for plot subtitle ---------------------------------------

as_of_date <- format(max(country_data$date), "%A, %B %e, %Y")

# calculate last data point for each country -----------------------------------

last_data_point <- country_data %>%
  group_by(country) %>%
  filter(date == max(date))

last_data_point

# plot cumulative cases vs. days elapsed ---------------------------------------

ggplot(data = country_data, 
       mapping = aes(x = days_elapsed, 
                     y = cumulative_cases, 
                     color = country, 
                     label = end_label)) +
  geom_line(size = 0.7, alpha = 0.8) +
  # use pretty colors
  scale_color_viridis_d() +
  # turn off legend
  guides(color = FALSE) +
  # add country labels, nudged above the lines
  geom_label_repel(nudge_y = 1, direction = "y", hjust = 1) + 
  # add points to line endings
  geom_point(data = last_data_point, 
             mapping = aes(x = days_elapsed, 
                           y = cumulative_cases)) +
  # use minimal theme
  theme_minimal() +
  # adjust labels
  labs(
    x = "Days since 10th confirmed death",
    y = "Cumulative number of deaths",
    title = "Cumulative deaths from COVID-19, selected countries",
    subtitle = glue("Data as of", as_of_date, .sep = " "),
    caption = "Source: github.com/RamiKrispin/coronavirus"
  )

# which state/province for selected countries ----------------------------------

coronavirus %>%
  filter(
    type == "death",
    Country.Region %in% countries,
    Province.State != ""
  ) %>%
  rename(Country = Country.Region) %>%
  group_by(Country) %>%
  summarise(Territory = glue_collapse(unique(Province.State), sep = ", ", last = ", and ")) %>%
  kable()
