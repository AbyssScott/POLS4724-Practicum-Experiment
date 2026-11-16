# POLS GU4724 Practicum: frozen tray-assignment visualization
# Run from the repository root:
#   Rscript code/plot_tray_randomization.R
# Or open this script in RStudio and run it from the root or code/ folder.
#
# Visualization only: this script reads the frozen random_assignment.csv.
# It does NOT draw a new random assignment or change the preregistration.
# Requires ggplot2 (install once with install.packages("ggplot2")).

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Package 'ggplot2' is required: install.packages('ggplot2')")
}

# Locate the repository's frozen allocation file.
if (file.exists("data/random_assignment.csv")) {
  root <- "."
} else if (file.exists("../data/random_assignment.csv")) {
  root <- ".."
} else {
  stop("Cannot find data/random_assignment.csv. Run from the repo root ",
       "or the code/ directory.")
}

input_path <- file.path(root, "data", "random_assignment.csv")
dat <- read.csv(input_path,
                colClasses = c(cookie_id = "character"),
                stringsAsFactors = FALSE)

# Validate the original 32-unit, four-block, balanced design.
required <- c("cookie_id", "batch", "rack", "position",
              "row_from_back", "column", "assignment")
stopifnot(all(required %in% names(dat)),
          nrow(dat) == 32L,
          !anyNA(dat[required]),
          !anyDuplicated(dat$cookie_id),
          setequal(dat$batch, c(1, 2)),
          setequal(dat$rack, c("Upper", "Lower")),
          setequal(dat$assignment, c("T", "C")),
          setequal(dat$column, c("Left", "Right")),
          setequal(dat$row_from_back, 1:4),
          setequal(dat$position, 1:8),
          all(table(dat$batch, dat$rack, dat$assignment) == 4L),
          all(table(dat$batch, dat$rack, dat$position) == 1L))

# Position 1 is back-left; 2 is back-right; 7 is front-left;
# 8 is front-right. This reproduces the frozen tray-coordinate scheme.
column_number <- match(dat$column, c("Left", "Right"))
stopifnot(all(dat$position == 2L * (dat$row_from_back - 1L) +
              column_number))

dat$x <- column_number
dat$panel_batch <- factor(dat$batch, levels = c(1, 2),
                          labels = c("Batch 1", "Batch 2"))
dat$panel_rack <- factor(dat$rack, levels = c("Upper", "Lower"))
dat$label <- paste0("#", dat$cookie_id, "\n", dat$assignment)

# A 2-by-2 panel figure, with each rack showing 2 columns x 4 rows.
# Row 1 is shown at the TOP because it is closest to the back of the oven.
p <- ggplot2::ggplot(
  dat, ggplot2::aes(x = x, y = row_from_back)
) +
  ggplot2::geom_tile(
    ggplot2::aes(fill = assignment),
    width = 0.88, height = 0.88, colour = "grey45", linewidth = 0.45
  ) +
  ggplot2::geom_text(
    ggplot2::aes(label = label),
    size = 4.2, lineheight = 1.1, fontface = "bold"
  ) +
  ggplot2::scale_fill_manual(
    values = c("T" = "#DDEBF4", "C" = "#F8E7CE"),
    breaks = c("T", "C"),
    labels = c("T: continued refrigeration", "C: room-temperature warming")
  ) +
  ggplot2::scale_x_continuous(
    breaks = 1:2, labels = c("Left", "Right"),
    limits = c(0.45, 2.55), expand = c(0, 0)
  ) +
  ggplot2::scale_y_reverse(
    breaks = 1:4, limits = c(4.55, 0.45), expand = c(0, 0)
  ) +
  ggplot2::facet_grid(panel_batch ~ panel_rack) +
  ggplot2::coord_fixed(ratio = 1) +
  ggplot2::labs(
    title = "Frozen Randomized Tray Assignments",
    subtitle = "Four batch-by-rack blocks, with four T and four C cookies per tray",
    x = "Tray column",
    y = "Row from back of oven (1 = back)",
    fill = "Assignment",
    caption = "Cookie IDs and positions read directly from data/random_assignment.csv"
  ) +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(
    panel.grid = ggplot2::element_blank(),
    strip.background = ggplot2::element_rect(
      fill = "grey94", colour = "grey75", linewidth = 0.4
    ),
    strip.text = ggplot2::element_text(face = "bold"),
    axis.text = ggplot2::element_text(colour = "grey25"),
    legend.position = "bottom",
    legend.title = ggplot2::element_text(face = "bold"),
    plot.title = ggplot2::element_text(face = "bold", size = 15),
    plot.subtitle = ggplot2::element_text(size = 11),
    plot.caption = ggplot2::element_text(size = 9, hjust = 0)
  )

# Save the tray diagram using the filename expected by the final report.
output_path <- file.path(root, "result", "tray_randomization_layout.png")
dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
ggplot2::ggsave(output_path, plot = p, width = 10.5, height = 8,
                units = "in", dpi = 300, bg = "white")
message("Saved reproducible tray diagram to: ", output_path)
