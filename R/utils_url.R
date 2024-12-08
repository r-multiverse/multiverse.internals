url_parse <- function(url) {
  nanonext::parse_url(trim_url(url))
}

trim_url <- function(url) {
  trim_trailing_slash(trimws(url))
}

trim_trailing_slash <- function(url) {
  sub(pattern = "/$", replacement = "", x = url, perl = TRUE)
}

`%||%` <- function(x, y) {
  if (is_null(x)) y else x
}

# Reexport from base on newer versions of R
if (exists("%||%", envir = .BaseNamespaceEnv)) {
  `%||%` <- get("%||%", envir = .BaseNamespaceEnv)
}
