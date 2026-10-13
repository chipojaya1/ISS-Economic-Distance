# Empirical Project 1 — Economic Distance (2019)

Quarto/RStudio project updated to use the correct **GDP per capita** indicator (`NY.GDP.PCAP.KD`) from the new World Bank WDI long-format Excel file. The earlier `pivot_wider()` issue is prevented by excluding invalid series/footer rows and checking duplicate country–indicator keys.

## Folder layout

- `index.qmd` — main analysis and results
- `methods.qmd` — methods and reproducibility documentation
- `R_analysis.R` — data import, cleaning, stats, distance computation, CSV exports
- `data/WDI_Raw_2019.xlsx` — unchanged newly downloaded 2019 data
- `outputs/` — created when the report renders

## How to use in RStudio

1. Extract this ZIP into your `~/GW/Big Data and International Business/Assignment/HW1/` folder (or an isolated subfolder). Keep the files together.
2. Install once in the **Console**:
   ```r
   install.packages(c('readxl','dplyr','tidyr','ggplot2','knitr','countrycode','readr','tibble'))
   ```
3. Open the folder as an RStudio Project, or use `setwd('~/GW/Big Data and International Business/Assignment/HW1')` in your Console.
4. Open `index.qmd` and click **Render**. You can also render `methods.qmd` separately.
5. Review `outputs/`, the excluded economy list, descriptive statistics, rankings and the written placeholders before submitting.

## Important

- The analysis automatically calculates results; **no rankings are hardcoded**.
- Research interpretation and the CEO recommendation have marked placeholders: complete these using the rendered 2019 findings. The original professor required a 3–4 page double-spaced Word narrative with maps and graphs; these Quarto HTML pages alone do **not** meet that submission format, and a map still needs to be added if resubmitting against the original rubric.
- The source export supplied for this redo has 217 economy codes and four indicator rows each; the script excludes footer rows and audits missingness and aggregate codes.
- Keep the source workbook unchanged and verify country-code exclusions and unusual values before interpreting results.


## Exploratory data analysis

Open `eda.qmd` (or run `quarto render` and visit the **Exploratory Analysis** navigation tab) for sample auditing, indicator availability, missing-data patterns, distributions, extremes, correlation heatmap, trade scatterplot and distance diagnostics. All visuals are computed dynamically using the original WDI workbook. The R script requires the packages listed in `methods.qmd` plus `scales`.

## Outlier and sensitivity analysis

The `sensitivity.qmd` page calculates 1%/99% winsorized Mahalanobis distances, reports ranks alongside baseline values, and exports `outputs/sensitivity_rankings.csv` when rendered. Rankings and figures should be reviewed after executing R/Quarto.
