test_that("meta_snapshot() is correct", {
  check_snapshot <- function(
    today,
    dependency_freeze,
    candidate_freeze,
    snapshot,
    r
  ) {
    out <- meta_snapshot(today = today)
    expect_equal(out$dependency_freeze, dependency_freeze)
    expect_equal(out$candidate_freeze, candidate_freeze)
    expect_equal(out$snapshot, snapshot)
    expect_equal(out$r, r)
    expect_equal(
      out$cran,
      file.path(
        "https://packagemanager.posit.co/cran",
        dependency_freeze
      )
    )
    expect_equal(
      out$r_multiverse,
      file.path(
        "https://production.r-multiverse.org",
        snapshot
      )
    )
  }
  first <- c(paste0("0", seq_len(9L)), as.character(seq(11L, 14L)))
  middle <- "15"
  last <- as.character(seq(16L, 28L))
  for (day in first) {
    check_snapshot(
      today = sprintf("2025-01-%s", day),
      dependency_freeze = "2024-10-15",
      candidate_freeze = "2024-11-15",
      snapshot = "2024-12-15",
      r = "4.4"
    )
  }
  for (day in c(middle, last)) {
    check_snapshot(
      today = sprintf("2025-01-%s", day),
      dependency_freeze = "2025-01-15",
      candidate_freeze = "2025-02-15",
      snapshot = "2025-03-15",
      r = "4.4"
    )
  }
  for (month in c("02", "03")) {
    for (day in c(first, middle, last)) {
      check_snapshot(
        today = sprintf("2025-%s-%s", month, day),
        dependency_freeze = "2025-01-15",
        candidate_freeze = "2025-02-15",
        snapshot = "2025-03-15",
        r = "4.4"
      )
    }
  }
  for (day in first) {
    check_snapshot(
      today = sprintf("2025-04-%s", day),
      dependency_freeze = "2025-01-15",
      candidate_freeze = "2025-02-15",
      snapshot = "2025-03-15",
      r = "4.4"
    )
  }
  for (day in c(middle, last)) {
    check_snapshot(
      today = sprintf("2025-04-%s", day),
      dependency_freeze = "2025-04-15",
      candidate_freeze = "2025-05-15",
      snapshot = "2025-06-15",
      r = "4.4"
    )
  }
  for (month in c("05", "06")) {
    for (day in c(first, middle, last)) {
      check_snapshot(
        today = sprintf("2025-%s-%s", month, day),
        dependency_freeze = "2025-04-15",
        candidate_freeze = "2025-05-15",
        snapshot = "2025-06-15",
        r = "4.4"
      )
    }
  }
  for (day in first) {
    check_snapshot(
      today = sprintf("2025-07-%s", day),
      dependency_freeze = "2025-04-15",
      candidate_freeze = "2025-05-15",
      snapshot = "2025-06-15",
      r = "4.4"
    )
  }
  for (day in c(middle, last)) {
    check_snapshot(
      today = sprintf("2025-07-%s", day),
      dependency_freeze = "2025-07-15",
      candidate_freeze = "2025-08-15",
      snapshot = "2025-09-15",
      r = "4.4"
    )
  }
  for (month in c("08", "09")) {
    for (day in c(first, middle, last)) {
      check_snapshot(
        today = sprintf("2025-%s-%s", month, day),
        dependency_freeze = "2025-07-15",
        candidate_freeze = "2025-08-15",
        snapshot = "2025-09-15",
        r = "4.4"
      )
    }
  }
  for (day in first) {
    check_snapshot(
      today = sprintf("2025-10-%s", day),
      dependency_freeze = "2025-07-15",
      candidate_freeze = "2025-08-15",
      snapshot = "2025-09-15",
      r = "4.4"
    )
  }
  for (day in c(middle, last)) {
    check_snapshot(
      today = sprintf("2025-10-%s", day),
      dependency_freeze = "2025-10-15",
      candidate_freeze = "2025-11-15",
      snapshot = "2025-12-15",
      r = "4.4"
    )
  }
  for (month in c("11", "12")) {
    for (day in c(first, middle, last)) {
      check_snapshot(
        today = sprintf("2025-%s-%s", month, day),
        dependency_freeze = "2025-10-15",
        candidate_freeze = "2025-11-15",
        snapshot = "2025-12-15",
        r = "4.4"
      )
    }
  }
})
