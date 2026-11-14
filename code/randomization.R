# Fixed, auditable random assignment: 4 batch-by-rack blocks, 4T/4C each.
# A deterministic Lehmer PRNG is used so the archived CSV can be exactly
# reproduced in either R or Python. Do not re-run to choose a nicer layout.
state <- 472416
next_index <- function(n) {
  state <<- (state * 16807) %% 2147483647
  as.integer(state %% n) + 1L
}
shuffle_fixed <- function(x) {
  if (length(x) > 1L) {
    for (i in seq.int(length(x), 2L, by = -1L)) {
      j <- next_index(i)
      temp <- x[i]
      x[i] <- x[j]
      x[j] <- temp
    }
  }
  x
}

block_list <- list()
k <- 0L
for (batch in 1:2) {
  for (rack in c("Upper", "Lower")) {
    ids <- seq.int(k + 1L, k + 8L)
    z <- shuffle_fixed(c(rep("T", 4L), rep("C", 4L)))
    pos <- shuffle_fixed(1:8)
    block_list[[length(block_list) + 1L]] <- data.frame(
      cookie_id = sprintf("%02d", ids),
      batch = batch,
      rack = rack,
      position = pos,
      row_from_back = (pos + 1L) %/% 2L,
      column = ifelse(pos %% 2L == 1L, "Left", "Right"),
      assignment = z,
      stringsAsFactors = FALSE
    )
    k <- k + 8L
  }
}
assignment <- do.call(rbind, block_list)
stopifnot(nrow(assignment) == 32L)
stopifnot(all(table(assignment$batch, assignment$rack,
                    assignment$assignment) == 4L))
stopifnot(all(vapply(split(assignment, interaction(assignment$batch,
                     assignment$rack)), function(b) {
  identical(sort(b$position), 1:8)
}, logical(1))))

# From the repository root, run: Rscript code/randomization.R
# The original assignment file is frozen and must NOT be overwritten.
data_file <- if (file.exists("../data/random_assignment.csv")) {
  "../data/random_assignment.csv"
} else {
  "data/random_assignment.csv"
}
archive <- read.csv(data_file, colClasses = c(cookie_id = "character"),
                    stringsAsFactors = FALSE)
for (nm in names(assignment)) {
  stopifnot(identical(as.character(assignment[[nm]]),
                      as.character(archive[[nm]])))
}
cat("Verified: frozen random assignment matches seed 472416.\n")
print(assignment[order(assignment$batch, assignment$rack,
                       assignment$position), ])
