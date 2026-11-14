# This file must be run AFTER all 32 cookie widths have been recorded.
# From repository root: Rscript code/analysis.R
# Primary outcome: mean of two perpendicular bottom-face widths in cm.
data_file <- if (file.exists("../data/measurement_template.csv")) {
  "../data/measurement_template.csv"
} else {
  "data/measurement_template.csv"
}
dat <- read.csv(data_file, colClasses = c(cookie_id = "character"),
                stringsAsFactors = FALSE)
stopifnot(nrow(dat) == 32L, all(dat$assignment %in% c("T", "C")))
stopifnot(all(table(dat$batch, dat$rack, dat$assignment) == 4L))
dat$Y <- (as.numeric(dat$width1_cm) + as.numeric(dat$width2_cm)) / 2
if (anyNA(dat$Y)) {
  stop("Some outcomes are missing. Document deviations before analysis; ",
       "the preregistered complete-data estimator cannot be applied unchanged.")
}
dat$block <- interaction(dat$batch, dat$rack, drop = TRUE)
blocks <- split(dat, dat$block)
within_block <- function(d) {
  yt <- d$Y[d$assignment == "T"]
  yc <- d$Y[d$assignment == "C"]
  c(n = nrow(d), tau = mean(yt) - mean(yc),
    variance = var(yt) / length(yt) + var(yc) / length(yc))
}
block_stats <- t(vapply(blocks, within_block, numeric(3)))
w <- block_stats[, "n"] / sum(block_stats[, "n"])
tau_hat <- sum(w * block_stats[, "tau"])
se_hat <- sqrt(sum(w^2 * block_stats[, "variance"]))
ci95 <- tau_hat + c(-1, 1) * qnorm(0.975) * se_hat
cat(sprintf("ATE (continued refrigeration minus warming): %.4f cm\n",
            tau_hat))
cat(sprintf("Neyman blocked SE: %.4f cm\n", se_hat))
cat(sprintf("Normal-approx. 95%% CI: [%.4f, %.4f] cm\n",
            ci95[1], ci95[2]))
cat("Treatment and control mean widths (cm):\n")
print(tapply(dat$Y, dat$assignment, mean))

# Two-sided sharp-null randomization inference, respecting each block.
set.seed(472417)
B <- 10000L
indices <- split(seq_len(nrow(dat)), dat$block)
ri_estimates <- replicate(B, {
  perm_z <- dat$assignment
  for (idx in indices) {
    perm_z[idx] <- sample(c(rep("T", 4L), rep("C", 4L)))
  }
  sum(vapply(seq_along(indices), function(i) {
    idx <- indices[[i]]
    w[i] * (mean(dat$Y[idx][perm_z[idx] == "T"]) -
            mean(dat$Y[idx][perm_z[idx] == "C"]))
  }, numeric(1)))
})
ri_p <- (1 + sum(abs(ri_estimates) >= abs(tau_hat))) / (B + 1)
cat(sprintf("Two-sided blocked sharp-null RI p-value: %.5f\n", ri_p))

# Save two figures for the practicum report; no extra statistical tests.
# Paths work when launched from either the repository root or code/.
plot_dir <- if (file.exists("../data/measurement_template.csv")) {
  "../result"
} else {
  "result"
}
dir.create(plot_dir, showWarnings = FALSE, recursive = TRUE)

# Figure 1: Fisher sharp-null randomization distribution.
png(file.path(plot_dir, "randomization_inference.png"),
    width = 1000, height = 650, res = 120)
hist(ri_estimates, breaks = 35, col = "grey80", border = "white",
     main = "Blocked randomization inference under the sharp null",
     xlab = "Simulated treatment-minus-control estimate (cm)")
abline(v = tau_hat, lwd = 2, col = "firebrick")
abline(v = -tau_hat, lwd = 2, col = "firebrick", lty = 2)
legend("topright", legend = c("Observed estimate", "Opposite-tail cutoff"),
       col = "firebrick", lty = c(1, 2), lwd = 2, bty = "n")
dev.off()

# Figure 2: Coppock-style individual outcomes and group means.
# The displayed 95% intervals describe each group mean; the formal
# preregistered inference for the blocked ATE is reported above.
groups <- c("C", "T")
values <- lapply(groups, function(z) dat$Y[dat$assignment == z])
group_means <- vapply(values, mean, numeric(1))
group_ses <- vapply(values, function(x) sd(x) / sqrt(length(x)), numeric(1))
lo <- group_means - qnorm(0.975) * group_ses
hi <- group_means + qnorm(0.975) * group_ses
ylim <- range(c(unlist(values), lo, hi))
pad <- max(0.05, diff(ylim) * 0.12)
png(file.path(plot_dir, "cookie_outcomes.png"),
    width = 900, height = 650, res = 120)
plot(1:2, group_means, type = "n", xlim = c(0.5, 2.5),
     ylim = ylim + c(-pad, pad), xaxt = "n", xlab = "",
     ylab = "Baked cookie diameter (cm)",
     main = "Individual cookie diameters and group means")
axis(1, at = 1:2, labels = c("Control: warming", "Treatment: chilled"))
set.seed(472418)  # Jitter only; does not affect any estimates.
for (j in 1:2) {
  points(j + runif(length(values[[j]]), -0.13, 0.13), values[[j]],
         pch = 16, col = grDevices::adjustcolor("grey30", alpha.f = 0.45))
}
segments(1:2, lo, 1:2, hi, lwd = 2)
segments((1:2) - 0.06, lo, (1:2) + 0.06, lo, lwd = 2)
segments((1:2) - 0.06, hi, (1:2) + 0.06, hi, lwd = 2)
points(1:2, group_means, pch = 18, cex = 1.8)
mtext("Diamonds: group means; bars: approximate 95% CIs for group means",
      side = 1, line = 3, cex = 0.75)
dev.off()
cat("Saved figures in: ", plot_dir, "\n", sep = "")
