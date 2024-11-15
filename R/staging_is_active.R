#' @title Check if the staging universe is active.
#' @export
#' @family staging
#' @description Check if the stating universe is active.
#' @return `TRUE` if the staging universe is active, `FALSE` otherwise.
#' @param start Character vector of `"%m-%d"` dates that the
#'   staging universe becomes active. Staging will then last for a full
#'   calendar month. For example, if you supply a start date of `"01-15"`,
#'   then the staging period will include all days from `"01-15"`
#'   through `"02-14"` and not include `"02-15"`.
#' @param today Character string with today's date in `"%Y-%m-%d"` format or an
#'   object convertible to POSIXlt format.
#' @examples
#' staging_is_active()
staging_is_active <- function(
  start = c("01-15", "04-15", "07-15", "10-15"),
  today = Sys.Date()
) {
  within_month_from_start(start = start, today = today)
}
