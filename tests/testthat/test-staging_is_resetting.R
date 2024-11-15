test_that("staging_is_resetting()", {
  start <- c("12-15", "03-15", "06-15", "09-15")
  resetting <- c(
    "2024-12-15",
    "2024-12-16",
    "2024-01-13",
    "2024-03-15",
    "2024-03-25",
    "2024-04-14",
    "2024-06-15",
    "2024-07-12",
    "2024-07-13",
    "2024-09-15",
    "2024-10-01",
    "2024-10-13"
  )
  for (today in resetting) {
    expect_true(
      staging_is_resetting(
        start = start,
        today = today
      )
    )
  }
  not_resetting <- c(
    "2024-12-12",
    "2024-01-15",
    "2024-03-14",
    "2024-04-15",
    "2024-06-12",
    "2024-07-15",
    "2024-09-14",
    "2024-10-15"
  )
  for (today in not_resetting) {
    expect_false(
      staging_is_resetting(
        start = start,
        today = today
      )
    )
  }
})

test_that("defaults staging_is_resetting() vs staging_is_active()", {
  dates <- seq(
    as.Date(paste0(format(Sys.Date(), "%Y"), "-01-01")),
    as.Date(paste0(format(Sys.Date(), "%Y"), "-12-31")),
    by = "day"
  )
  dates <- format(dates, "%Y-%m-%d")
  for (date in dates) {
    expect_false(
      staging_is_active(today = date) && staging_is_resetting(today = date)
    )
  }
})
