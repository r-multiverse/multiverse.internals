within_month_from_start <- function(start, today) {
  today <- as.POSIXlt(today, tz = "UTC")
  start <- strsplit(start, split = "-", fixed = TRUE)
  start <- lapply(start, as.integer)
  within <- lapply(start, within_month_interval, today = today)
  any(as.logical(within))
}

within_month_interval <- function(start, today) {
  month <- today$mon + 1L
  day <- today$mday
  if (start[1L] > 28L) {
    stop(
      "a staging start date cannot be later than day 28 of the given month.",
      call. = FALSE
    )
  }
  month_after_start <- (start[1L] + 1L) %% 12L
  (month == start[1L] && day >= start[2L]) ||
    (month == month_after_start && day < start[2L])
}
