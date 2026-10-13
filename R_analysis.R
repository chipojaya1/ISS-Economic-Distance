# Empirical Project 1 — 2019 economic distance from the United States
# All output objects are generated from the original WDI export without modifying it.
# The original downloaded workbook is expected in data/WDI_Raw_2019.xlsx.

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(knitr)
library(countrycode)
library(readr)

workbook <- file.path('data', 'WDI_Raw_2019.xlsx')
# Also works if the .qmd and workbook are directly in the HW1 folder.
if (!file.exists(workbook)) workbook <- 'WDI_Raw_2019.xlsx'
if (!file.exists(workbook)) stop('Place WDI_Raw_2019.xlsx in the data/ folder or beside index.qmd.')

dir.create('outputs', showWarnings = FALSE)
raw <- read_excel(workbook, sheet = 'Data', na = c('..', '.', 'NA', ''))
required_cols <- c('Country Name', 'Country Code', 'Series Code', '2019 [YR2019]')
stopifnot(all(required_cols %in% names(raw)))

series_lookup <- c(
  'NY.GDP.PCAP.KD' = 'gdp_per_capita',
  'NY.GDP.DEFL.KD.ZG' = 'inflation',
  'NE.IMP.GNFS.ZS' = 'imports_pct_gdp',
  'NE.EXP.GNFS.ZS' = 'exports_pct_gdp'
)
indicators <- unname(series_lookup)

# Exclude spreadsheet footnotes/blank series before pivoting: otherwise an NA
# series column and duplicated NA keys can create list-columns in pivot_wider().
long_data <- raw %>%
  transmute(country = as.character(`Country Name`),
            iso3c = as.character(`Country Code`),
            series = as.character(`Series Code`),
            value = suppressWarnings(as.numeric(`2019 [YR2019]`))) %>%
  filter(!is.na(country), !is.na(iso3c),
         grepl('^[A-Z]{3}$', iso3c), series %in% names(series_lookup))

# Repeated country/series observations make a single-valued pivot ambiguous.
duplicate_pairs <- long_data %>% count(iso3c, series, name = 'n') %>% filter(n > 1)
if (nrow(duplicate_pairs)) {
  print(duplicate_pairs)
  stop('Duplicate country–series pairs. Investigate before reshaping.')
}

wide <- long_data %>%
  pivot_wider(id_cols = c(iso3c, country), names_from = series, values_from = value)
stopifnot(all(names(series_lookup) %in% names(wide)))
for (code in names(series_lookup)) names(wide)[names(wide) == code] <- series_lookup[[code]]
stopifnot(all(vapply(wide[indicators], is.numeric, logical(1))))

# countrycode distinguishes country/economy codes from World Bank aggregates.
# Review exclusions separately, since the code list is not a perfect ontology.
wide <- wide %>% mutate(is_country = !is.na(countrycode::countrycode(
  iso3c, origin = 'iso3c', destination = 'country.name', warn = FALSE
)))
excluded_aggregates <- wide %>% filter(!is_country) %>% select(country, iso3c)
country_data <- wide %>% filter(is_country) %>% select(-is_country)

missingness <- tibble(
  indicator = indicators,
  available_n = vapply(country_data[indicators], function(x) sum(is.finite(x)), integer(1)),
  missing_n = vapply(country_data[indicators], function(x) sum(!is.finite(x)), integer(1))
)
complete_data <- country_data %>% filter(if_all(all_of(indicators), is.finite))
excluded_incomplete <- country_data %>% filter(!if_all(all_of(indicators), is.finite))
stopifnot(sum(complete_data$iso3c == 'USA') == 1, nrow(complete_data) > length(indicators))

write_csv(excluded_aggregates, 'outputs/excluded_aggregates.csv')
write_csv(missingness, 'outputs/indicator_missingness.csv')
write_csv(excluded_incomplete, 'outputs/excluded_incomplete_economies.csv')
write_csv(complete_data, 'outputs/WDI_2019_complete_cases.csv')

summary_stats <- bind_rows(lapply(indicators, function(v) {
  x <- complete_data[[v]]
  tibble(indicator = v, n = length(x), min = min(x), median = median(x),
         mean = mean(x), max = max(x), sd = sd(x))
}))
correlation <- cor(complete_data[indicators])

# Mahalanobis distance from the US. Covariance uses the SAME complete-country sample.
X <- as.matrix(complete_data[indicators])
S <- cov(X)
if (qr(S)$rank < ncol(S)) stop('Covariance matrix singular; inspect collinearity.')
usa <- as.numeric(X[complete_data$iso3c == 'USA', ])
# stats::mahalanobis gives squared distance; take square root for D.
complete_data$distance_us <- sqrt(stats::mahalanobis(X, center = usa, cov = S))
stopifnot(abs(complete_data$distance_us[complete_data$iso3c == 'USA']) < 1e-8)
ranked <- complete_data %>% filter(iso3c != 'USA') %>% arrange(distance_us)
closest <- head(ranked %>% select(country, iso3c, distance_us), 10)
farthest <- head(ranked %>% arrange(desc(distance_us)) %>% select(country, iso3c, distance_us), 10)
distance_summary <- ranked %>% summarise(n = n(), minimum = min(distance_us),
  median = median(distance_us), mean = mean(distance_us),
  maximum = max(distance_us), sd = sd(distance_us))
write_csv(ranked, 'outputs/ranked_distances_from_usa.csv')
write_csv(summary_stats, 'outputs/descriptive_statistics.csv')
write_csv(as.data.frame(correlation) %>% tibble::rownames_to_column('indicator'),
          'outputs/correlation_matrix.csv')
