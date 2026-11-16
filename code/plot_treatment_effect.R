# Figure 2. Estimated blocked ATE and normal-approximation 95% CI.
# From the repository root: source("code/plot_treatment_effect.R")
# Supplementary visualization only; original analysis.R remains unchanged.

input_path <- if (file.exists("data/cookie_measurements.csv")) {
  "data/cookie_measurements.csv"
} else {
  "../data/cookie_measurements.csv"
}
output_dir <- if (file.exists("data/cookie_measurements.csv")) "result" else "../result"

dat <- read.csv(input_path, colClasses = c(cookie_id = "character"),
                stringsAsFactors = FALSE)
stopifnot(nrow(dat) == 32L)
stopifnot(all(table(dat$batch, dat$rack, dat$assignment) == 4L))
dat$Y <- (dat$width1_cm + dat$width2_cm) / 2
stopifnot(!anyNA(dat$Y))
dat$block <- interaction(dat$batch, dat$rack, drop = TRUE)
blocks <- split(dat, dat$block)

calc_block <- function(x) {
  yt <- x$Y[x$assignment == "T"]
  yc <- x$Y[x$assignment == "C"]
  c(n = nrow(x), ate = mean(yt) - mean(yc),
    var_hat = var(yt) / length(yt) + var(yc) / length(yc))
}
block_results <- t(vapply(blocks, calc_block, numeric(3)))
weights <- block_results[, "n"] / sum(block_results[, "n"])
ate <- sum(weights * block_results[, "ate"])
se <- sqrt(sum(weights^2 * block_results[, "var_hat"]))
ci <- ate + qnorm(c(0.025, 0.975)) * se

# Checks against the preregistered analyses reported in the main report.
stopifnot(isTRUE(all.equal(ate, 0.015625, tolerance = 1e-10)))
stopifnot(isTRUE(all.equal(se, 0.03088326475077826,
                           tolerance = 1e-10)))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
file_out <- file.path(output_dir, "treatment_effect_ci.png")
png(file_out, width = 1800, height = 700, res = 220)
par(mar = c(5, 3.2, 4.8, 1.5), family = "sans")
plot(NA, xlim = c(-0.072, 0.101), ylim = c(0.55, 1.55), yaxt = "n",
     ylab = "", xlab = "Treatment effect on baked cookie diameter (cm)",
     bty = "n", main = "Estimated effect of continued refrigeration")
abline(v = 0, lty = 2, lwd = 1.4, col = "gray45")
segments(ci[1], 1, ci[2], 1, lwd = 2.3, col = "steelblue4")
segments(ci, 0.945, ci, 1.055, lwd = 2.3, col = "steelblue4")
points(ate, 1, pch = 18, cex = 2, col = "steelblue4")
text(ate, 1.18, sprintf("ATE = %+.4f cm", ate), cex = 0.92)
text(ci[1], 0.82, sprintf("%.4f", ci[1]), cex = 0.78)
text(ci[2], 0.82, sprintf("%.4f", ci[2]), cex = 0.78)
mtext("Treatment (chilled) minus control (warmed); N = 32, four blocks",
      side = 3, line = 0.7, cex = 0.87)
mtext("Bar: normal-approximation 95% CI; dashed line: zero effect",
      side = 1, line = 3.7, cex = 0.75)
dev.off()
cat(sprintf("Figure saved to: %s\nATE = %.6f cm; SE = %.6f cm; CI = [%.6f, %.6f] cm\n",
            file_out, ate, se, ci[1], ci[2]))
