# The Geography of Economic Distance — ISS Data Analytics Project 1

Reproducible 2019 cross-country economic-distance analysis in **R + Quarto**, adapted from the original empirical project by **Chipo Jaya and Xianghan Zhu**.

## Run
1. Install R and Quarto.
2. In this folder, run:
   ```bash
   Rscript -e 'install.packages(c("readxl","dplyr","ggplot2","countrycode","knitr"), repos="https://cloud.r-project.org")'
   quarto render
   quarto preview
   ```
3. Upload the project to a **new public GitHub repository** only after reviewing the data and content. Publish the generated site with a suitable free GitHub Pages workflow.

The supplied workbook is located in `data/WDI_Raw.xlsx`. No values from the original report are hard-coded into the charts or ranking tables. See `methods.qmd` for variable definitions and limitations.

## Check before presentation
- Compare computed sample size and ranking to the original Stata report.
- Resolve GDP vs GDP-per-capita choice. Current code intentionally uses exact uploaded columns.
- Inspect whether `countrycode` excludes any valid country code you want to retain.
- Confirm coauthor acknowledgement and public-data licensing before publication.
- Verify the generated report on a local machine; R/Quarto were not available in the authoring environment.
