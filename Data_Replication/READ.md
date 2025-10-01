# Data Replication Projects in R

This folder showcases my work replicating published data analyses and visualizations using **R**.

**Key skills demonstrated:**
- Cleaning and transforming research datasets
- Calculating statistical effect sizes (e.g., Cohen’s d, Hedges’ g)
- Creating reproducible visualizations with `ggplot2`
- Documenting workflows for transparency and reproducibility

These projects highlight my ability to understand scientific studies, reproduce key metrics, and present data-driven insights clearly.

`# Biomedical Research Effect Size Replication

This project replicates analyses from the paper:

> **Ioannidis JPA, Klavans R, Boyack KW.** The evolving significance of effect sizes in biomedical research. *PLoS One*. 2017;12(12):e0188997. [PMID: 29228281](https://pubmed.ncbi.nlm.nih.gov/29228281/)

**What I did:**
- Imported and cleaned a dataset of published biomedical studies containing reported effect sizes.
- Converted and standardized effect size columns, removed missing values, and aggregated by study.
- Computed monthly median **maximal**, **mean**, and **minimal** effect sizes per abstract.
- Visualized long-term trends in effect size reporting with **ggplot2**, using LOESS smoothing for clear trend lines.

**Tech used:**  
`R`, `tidyverse` (dplyr, ggplot2), `lubridate`

**Impact:**  
Showcases my ability to reproduce real-world biomedical analyses, work with large and messy research datasets, calculate effect sizes, and create clear publication-quality visualizations.
