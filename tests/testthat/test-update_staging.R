test_that("update_staging()", {
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
  file_config <- file.path(path_staging, "config.json")
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  json_staging <- jsonlite::read_json(file_staging)
  json_community <- jsonlite::read_json(file_community)
  names_community <- vapply(
    json_community,
    function(x) x$package,
    FUN.VALUE = character(1L)
  )
  meta_community <- data.frame(
    package = names_community,
    remotesha = paste0("sha-", names_community)
  )
  update_staging(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(4L, 3L))
  names <- c("add", "freeze", "issue", "removed-no-issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "add"], "sha-add")
  expect_equal(packages$branch[packages$package == "freeze"], "original")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
  expect_equal(
    packages$branch[packages$package == "removed-no-issue"],
    "original"
  )
})

test_that("update_staging() with missing packages.json", {
  dir_staging <- tempfile()
  dir_community <- tempfile()
  path_staging <- file.path(dir_staging, "staging")
  path_community <- file.path(dir_community, "community")
  dir.create(path_staging, recursive = TRUE)
  dir.create(dir_community, recursive = TRUE)
  on.exit(unlink(path_staging, recursive = TRUE))
  on.exit(unlink(path_community, recursive = TRUE), add = TRUE)
  mock <- system.file(
    "mock",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  file.copy(
    from = file.path(mock, "community"),
    to = dir_community,
    recursive = TRUE
  )
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  json_community <- jsonlite::read_json(file_community)
  names_community <- vapply(
    json_community,
    function(x) x$package,
    FUN.VALUE = character(1L)
  )
  meta_community <- data.frame(
    package = names_community,
    remotesha = paste0("sha-", names_community)
  )
  expect_false(file.exists(file_staging))
  update_staging(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  expect_true(file.exists(file_staging))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("add", "freeze", "issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "add"], "sha-add")
  expect_equal(packages$branch[packages$package == "freeze"], "sha-freeze")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
})
