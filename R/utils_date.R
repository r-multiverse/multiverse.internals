date_staging_freeze <- function() {
  today <- Sys.Date()
  year <- as.integer(format(today, "%Y"))
  years <- as.character(rep(c(year - 1L, year), each = 4L))
  months <- rep(c("01-15", "04-15", "07-15", "10-15"), times = 2L)
  freezes <- as.Date(paste(years, months, sep = "-"))
  as.character(max(freezes[freezes <= today]))
}
