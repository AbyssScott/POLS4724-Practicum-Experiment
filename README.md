# POLS GU4724 — Practicum Experiment

**Effects of Pre-Baking Warming on Cookie Diameter**

A randomized baking experiment conducted for POLS GU4724: Experimental Methods at Columbia University (Fall 2026).

## Research Question

Does warming refrigerated cookie dough at room temperature for 90 minutes before baking affect the final diameter of baked cookies?

## Experimental Design

- **Sample:** 32 pre-portioned cookie dough pieces
- **Treatment (T):** Continued refrigeration for 180 minutes
- **Control (C):** Refrigeration for 90 minutes, followed by 90 minutes at room temperature
- **Randomization:** Four batch-by-rack blocks, each with 4 treatment and 4 control cookies
- **Outcome:** Mean of two perpendicular measurements of each baked cookie's bottom diameter, in centimeters

## Preregistration

Official AsPredicted registration: [#324567](https://aspredicted.org/8b3y59.pdf).

The detailed pre-analysis plan is available in `preregistration/Cookie_Practicum_PAP.Rmd`.

## Repository Structure

- `preregistration/` — Official preregistration and pre-analysis plan
- `code/` — Randomization and statistical analysis scripts
- `data/` — Frozen random assignment and completed cookie measurements
- `result/` — Experimental results and figures

## Reproducibility

Run the following commands in R from the repository root:

```r
source("code/randomization.R")
```

With all 32 cookie outcomes recorded in `data/cookie_measurements.csv`, run:

```r
source("code/analysis.R")
```

The analysis reports the blocked difference-in-means estimate, Neyman conservative standard error, normal-approximation 95% confidence interval, and two-sided Fisher randomization inference p-value.

## Status

The confirmatory 32-cookie experiment and outcome measurements were completed on November 14, 2026. Preregistration and random assignment were completed before the confirmatory experiment.

**Post-experiment file maintenance (November 14, 2026):** The completed dataset was renamed from `measurement_template.csv` to `cookie_measurements.csv`. Only corresponding file-path references were updated in the R scripts and the supplemental RMarkdown PAP; the preregistered estimand, statistical methods, random assignment, and measurement data were not changed. The original preregistration remains available in AsPredicted and the GitHub commit history.
