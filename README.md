# POLS GU4724 — Practicum Experiment

**Effect of Continued Refrigeration Relative to Pre-Baking Warming on Cookie Diameter: A Randomized Experiment**

A randomized baking experiment conducted for POLS GU4724: Experimental Methods at Columbia University (Fall 2026).

## Final Report

- [Final report (PDF)](report/Cookie_Practicum_Report.pdf)
- [R Markdown source](report/Cookie_Practicum_Report.Rmd)

The PDF includes the study design, results, figures, photographs, the complete experimental data, and the R programs in its appendices.

## Research Question and Hypothesis

Does **continued refrigeration**, compared with allowing refrigerated cookie dough to warm at room temperature before baking, affect the final diameter of commercially prepared cookies?

The hypothesis is two-sided: mean baked diameters differ between the two conditions. The treatment effect is defined as **treatment (continued refrigeration) minus control (pre-baking warming)**.

## Experimental Design

- **Experimental units:** 32 pre-portioned pieces of Pillsbury Ready to Bake Sugar Cookie Dough from two packages
- **Date:** November 14, 2026
- **Treatment (T; n = 16):** Continued refrigeration for 180 minutes
- **Control (C; n = 16):** Refrigeration for 90 minutes followed by 90 minutes at room temperature
- **Randomization:** Four batch-by-rack blocks (two baking batches × two oven racks), with 4 treatment and 4 control cookies per block; tray positions were also randomized
- **Baking:** Both racks baked simultaneously within each batch at 350°F for 17 minutes
- **Outcome:** After five minutes of cooling on the trays, the mean of two perpendicular bottom-face diameter measurements, in centimeters
- **Completeness:** All 32 cookies complied with their assignments and yielded valid outcome measurements

## Preregistration

- [Official AsPredicted preregistration #324567](https://aspredicted.org/8b3y59.pdf)
- [Archived preregistration PDF](preregistration/AsPredicted_324567.pdf)
- [Supplemental R Markdown pre-analysis plan](preregistration/Cookie_Practicum_PAP.Rmd)

The original preregistration was titled *Effects of Pre-Baking Warming on Cookie Diameter*. The final report title explicitly clarifies the preregistered direction of the comparison (continued refrigeration minus warming); it does not change the treatment assignment or estimand.

## Main Results

The preregistered blocked difference-in-means estimator gives:

| Statistic | Estimate |
| --- | ---: |
| Treatment mean (continued refrigeration; n = 16) | 5.8781 cm |
| Control mean (pre-baking warming; n = 16) | 5.8625 cm |
| Blocked ATE (T − C) | +0.0156 cm (approximately 0.16 mm) |
| Conservative Neyman SE | 0.0309 cm |
| Normal-approximation 95% CI | [−0.0449, 0.0762] cm |
| Two-sided Fisher randomization-inference p-value | 0.552 |
| Total observations | 32 |

The estimated difference is small and statistically uncertain. The results do not provide evidence of a nonzero average effect at the 5% level, but they do not establish that the true effect is exactly zero.

## Repository Structure

- [`report/`](report/) — Final PDF report and R Markdown source
- [`preregistration/`](preregistration/) — Official AsPredicted PDF and supplemental pre-analysis plan
- [`code/`](code/) — Frozen randomization verification, preregistered statistical analysis, and reproducible figures
- [`data/`](data/) — Frozen treatment assignments and complete cookie-level measurements
- [`result/`](result/) — Individual outcome plot, estimated effect with confidence interval, randomization-inference plot, and tray-assignment diagram
- [`photos/`](photos/) — Pre-baking setup and the upper/lower oven racks for both batches

## Reproducibility

Run the following commands **from the repository root** in R:

```r
# Verify the archived, frozen allocation (does not replace the CSV)
source("code/randomization.R")

# Reproduce the blocked ATE, conservative SE, 95% CI,
# two-sided Fisher randomization inference, and related figures
source("code/analysis.R")

# Reproduce the treatment-effect confidence-interval figure
source("code/plot_treatment_effect.R")

# Reproduce the frozen tray-assignment diagram (requires ggplot2)
source("code/plot_tray_randomization.R")
```

For the last script, install `ggplot2` if needed with `install.packages("ggplot2")`. The scripts use `data/cookie_measurements.csv` and `data/random_assignment.csv`; the frozen assignment should not be regenerated or replaced. The figure outputs are stored in `result/`.

## Status and Data Provenance

The confirmatory 32-cookie experiment and outcome measurements were completed on November 14, 2026. Preregistration and random assignment were completed before the confirmatory experiment. The earlier exploratory baking test was not included in this dataset.

**Post-experiment file maintenance (November 14, 2026):** The completed dataset was renamed from `measurement_template.csv` to `cookie_measurements.csv`. Only corresponding file-path references were updated in the R scripts and the supplemental RMarkdown PAP; the preregistered estimand, statistical methods, random assignment, and measurement data were not changed. The original preregistration remains available in AsPredicted and the GitHub commit history.
