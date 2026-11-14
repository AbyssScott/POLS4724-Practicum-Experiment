
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
- `data/` — Frozen random assignment and measurement template
- `result/` — Experimental results and figures

## Reproducibility

Run the following commands in R from the repository root:

```r
source("code/randomization.R")
```

After all 32 cookie outcomes have been recorded in `data/measurement_template.csv`, run:

```r
source("code/analysis.R")
```

The analysis reports the blocked difference-in-means estimate, Neyman conservative standard error, normal-approximation 95% confidence interval, and two-sided Fisher randomization inference p-value.

## Status

Preregistration and random assignment completed before the confirmatory experiment. The prior 16-cookie pilot is excluded from the formal analysis.
