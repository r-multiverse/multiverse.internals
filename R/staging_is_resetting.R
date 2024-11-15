#' @title Check if the stating universe is resetting.
#' @export
#' @family staging
#' @description Check if the stating universe is resetting.
#' @return `TRUE` if the staging universe is resetting, `FALSE` otherwise.
#' @param start Character vector of `"%m-%d"` dates that the
#'   staging universe is resetting. The resetting period will then last for a
#'   full calendar month.
#'   For example, if you supply a start date of `"12-15"`,
#'   then the staging period will include all days from `"12-15"`
#'   through `"01-14"` and not include `"01-15"`.
#' @param today Character string with today's date in `"%Y-%m-%d"` format or an
#'   object convertible to POSIXlt format.
#' @examples
#' staging_is_resetting()
staging_is_resetting <- function(
  start = c("12-15", "03-15", "06-15", "09-15"),
  today = Sys.Date()
) {
  within_month_from_start(start = start, today = today)
}
