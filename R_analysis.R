# ISS Project 1: Economic distance in 2019
# Source: original WDI_Raw.xlsx; see methods.qmd for indicator definitions.
# All paths relative to the Quarto project root.
library(readxl)
library(dplyr)
library(ggplot2)
library(countrycode)
library(knitr)

raw <- read_excel('data/WDI_Raw.xlsx', sheet = 'Data', na = c('..', '.', 'NA', ''))
stopifnot(ncol(raw) >= 6)
# Select by positions after validating the indicators in column names.
needed_codes <- c('NY.GDP.MKTP.KD', 'NE.IMP.GNFS.ZS',
                  'NY.GDP.DEFL.KD.ZG', 'NE.EXP.GNFS.ZS')
stopifnot(all(mapply(grepl, needed_codes, names(raw)[3:6], fixed = TRUE)))
names(raw)[1:6] <- c('country', 'iso3c', 'gdp_constant_2015_usd',
                     'imports_pct_gdp', 'inflation_gdp_deflator_pct', 'exports_pct_gdp')

# Restrict World Bank aggregate rows using ISO3 country matching.
# This retains 3-letter country codes that countrycode recognizes; inspect exclusions.
data_all <- raw |>
  mutate(across(c(gdp_constant_2015_usd, imports_pct_gdp,
                  inflation_gdp_deflator_pct, exports_pct_gdp),
                ~ suppressWarnings(as.numeric(.x))),
         is_country = !is.na(countrycode(iso3c, 'iso3c', 'country.name', warn = FALSE)))
excluded_aggregates <- data_all |> filter(!is_country) |> select(country, iso3c)

indicators <- c('gdp_constant_2015_usd','imports_pct_gdp',
                'inflation_gdp_deflator_pct','exports_pct_gdp')
data <- data_all |> filter(is_country) |> filter(if_all(all_of(indicators), ~ is.finite(.x)))
stopifnot(nrow(data) > 5, sum(data$iso3c == 'USA') == 1)

# Descriptives and correlation of the four raw, unit-labeled variables.
summary_stats <- do.call(rbind, lapply(indicators, function(v) {
  x <- data[[v]]
  data.frame(variable = v, n=length(x), min=min(x), median=median(x),
             mean=mean(x), max=max(x), sd=sd(x))
}))
correlation <- cor(as.matrix(data[, indicators]))

# Define distance from the USA using the inverse sample covariance matrix.
# Mahalanobis D is the square root of the covariance-adjusted quadratic form.
X <- as.matrix(data[, indicators])
S <- cov(X)
stopifnot(qr(S)$rank == ncol(X))
usa <- X[data$iso3c == 'USA', , drop = TRUE]
data$distance_us <- sqrt(rowSums(((sweep(X, 2, usa, '-')) %*% solve(S)) *
                                    sweep(X, 2, usa, '-')))
ranked <- data |> filter(iso3c != 'USA') |> arrange(distance_us)
closest <- head(ranked |> select(country, iso3c, distance_us), 10)
farthest <- head(ranked |> arrange(desc(distance_us)) |>
                   select(country, iso3c, distance_us), 10)
distance_summary <- ranked |> summarize(n=n(), minimum=min(distance_us),
  median=median(distance_us), mean=mean(distance_us),
  maximum=max(distance_us), sd=sd(distance_us))
