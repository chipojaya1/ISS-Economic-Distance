# The Geography of Economic Distance

**A comparative analysis of economic similarity to the United States using 2019 World Bank data**

**[Explore the interactive-style research website →](https://chipojaya1.github.io/ISS-Economic-Distance/)**

This project explores a simple question: **Which economies were most similar to the United States in 2019 when we consider income per person, inflation, imports, and exports together?** It uses Python to examine economic patterns across economies and combines four indicators into a measure called *Mahalanobis distance*.

The website is a single-page research report designed to be read from beginning to end. It includes charts, explanations, results, and methodological cautions. Readers do not need to run the code to explore the findings.

## What you will find on the website

1. **Research question and data:** Why economic distance is worth examining and which World Bank indicators are used.
2. **Data coverage:** How missing observations affect the economies included in the analysis.
3. **Exploratory analysis:** Separate charts of GDP per capita, inflation, imports, and exports, followed by a correlation heatmap.
4. **Economic distance results:** The economies closest to and furthest from the United States across the four selected indicators.
5. **Sensitivity analysis:** How distance rankings may respond to adjustments for extreme values.
6. **Conclusions and limitations:** What these comparisons can—and cannot—tell us.

**[Read the full report](https://chipojaya1.github.io/ISS-Economic-Distance/)**

## Key findings

In the baseline Mahalanobis-distance analysis, **Australia, Norway, and the United Kingdom** are the three closest economies to the United States. **Venezuela, Djibouti, and Hong Kong SAR, China** are the three most distant.

A larger distance does **not** mean an economy is less successful, less developed, or a worse place to invest. It means its combined profile differs more from the United States on the four measures used here. For instance, an economy with high GDP per capita can still have a large economic distance if its trade patterns differ substantially.

## Data and method

The analysis uses 2019 **World Development Indicators (WDI)** from the World Bank:

| Indicator | What it represents |
| --- | --- |
| GDP per capita (constant 2015 US$) | Economic output per person |
| Inflation, GDP deflator (annual %) | Changes in the prices of domestically produced goods and services |
| Imports of goods and services (% of GDP) | Purchases from abroad relative to the economy's size |
| Exports of goods and services (% of GDP) | Sales abroad relative to the economy's size |

Mahalanobis distance brings these indicators together while accounting for their different scales and correlations. The analysis uses economies with complete data for all four measures.

**Interpretation matters:** This is a descriptive comparison for one year, not a causal study. The dataset includes economies and territories, not only sovereign states. Extreme observations can also influence the distance scores.

The trade indicators provide context for conversations about **Sustainable Development Goal 17**, but this project does **not** directly measure an official SDG 17 indicator.

## Explore the underlying research

- **[Research website](https://chipojaya1.github.io/ISS-Economic-Distance/)** — Start here for the complete, illustrated explanation.
- **[Python analysis notebook](https://github.com/chipojaya1/ISS-Economic-Distance/blob/main/Economic_distance_analysis.ipynb)** — Explore the code and calculations behind the analysis.
- **[World Bank 2019 dataset](data/WDI_Raw_2019.xlsx)** — View the original workbook used in the project.
- **[Quarto report source](index.qmd)** — See how the website is generated.

The repository also retains earlier R and Quarto files as project history. The **published website is the single-page Python-based report**, not the older multi-page R version.

## Research credit and sources

This ISS Data Analytics Project 1 presentation adapts an earlier collaborative empirical project by **Chipo Jaya and Xianghan Zhu**.

**Data:** World Bank, *World Development Indicators*, 2019.

**Conceptual reference:** Berry, H., Guillén, M. F., & Zhou, N. (2010). *An institutional approach to cross-national distance*. *Journal of International Business Studies*, 41, 1460–1480.

The economic-distance calculation presented here uses the four WDI indicators above; it is not a reproduction of Berry and colleagues' full institutional-distance index.

---

**[Visit The Geography of Economic Distance website](https://chipojaya1.github.io/ISS-Economic-Distance/)**
