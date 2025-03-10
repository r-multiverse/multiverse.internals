test_that("freeze_dependencies()", {
  dir_staging <- tempfile()
  dir_community <- tempfile()
  path_staging <- file.path(dir_staging, "staging")
  path_community <- file.path(dir_community, "community")
  dir.create(dir_staging)
  dir.create(dir_community)
  on.exit(unlink(path_staging, recursive = TRUE))
  on.exit(unlink(path_community, recursive = TRUE), add = TRUE)
  mock <- system.file(
    "mock",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  file.copy(
    from = file.path(mock, "staging"),
    to = dir_staging,
    recursive = TRUE
  )
  file.copy(
    from = file.path(mock, "community"),
    to = dir_community,
    recursive = TRUE
  )
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  file_config <- file.path(path_staging, "config.json")
  file_staged <- file.path(path_staging, "staged.json")
  old_lines_staging <- paste(readLines(file_staging), collapse = "\n")
  old_lines_community <- paste(readLines(file_community), collapse = "\n")
  expect_false(file.exists(file_config))
  expect_true(file.exists(file_staged))
  expect_false(old_lines_staging == old_lines_community)
  freeze_dependencies(
    path_staging = path_staging,
    path_community = path_community
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  expect_equal(config$cran_version, meta_snapshot()$dependency_freeze)
  expect_false(file.exists(file_staged))
  lines_staging <- paste(readLines(file_staging), collapse = "\n")
  lines_community <- paste(readLines(file_community), collapse = "\n")
  expect_true(lines_staging == old_lines_community)
  expect_true(lines_community == old_lines_community)
})
