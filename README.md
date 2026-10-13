# The Geography of Economic Distance

**ISS Data Analytics Project 1** | **2019 World Development Indicators** | **R + Quarto**

A reproducible analysis of economic differences between the United States and other economies, based on GDP per capita, GDP-deflator inflation, imports (% of GDP), and exports (% of GDP).

This research adapts an earlier collaborative empirical project by **Chipo Jaya and Xianghan Zhu**, based on the institutional-distance framework discussed by Berry, Guillén, and Zhou (2010). The ISS adaptation examines economic disparity, data coverage, outliers, and sensitivity of Mahalanobis distances. Economic distance is not a direct measure of SDG achievement or investment attractiveness.

## Run locally

Install [R](https://cran.r-project.org/) and [Quarto](https://quarto.org/). From the project root:

```r
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2", "knitr",
                   "countrycode", "readr", "scales", "tibble"))
```

```bash
quarto render
```

The Quarto site builds from `index.qmd`, `eda.qmd`, `sensitivity.qmd` and `methods.qmd`, using `R_analysis.R` and `data/WDI_Raw_2019.xlsx`.

**Status:** Project files still need to be uploaded from the prepared ZIP archive. Website generation is not yet verified.

## Data and credit

- World Bank [World Development Indicators](https://databank.worldbank.org/source/world-development-indicators), 2019.
- Berry, H., Guillén, M. F., & Zhou, N. (2010). *An institutional approach to cross-national distance*. Journal of International Business Studies, 41, 1460–1480.
