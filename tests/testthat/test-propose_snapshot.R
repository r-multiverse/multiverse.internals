test_that("propose_snapshot()", {
  dir_staging <- tempfile()
  dir_community <- tempfile()
  path_staging <- file.path(dir_staging, "staging")
  dir.create(dir_staging)
  on.exit(unlink(path_staging, recursive = TRUE))
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
  file_staging <- file.path(path_staging, "packages.json")
  json_staging <- data.frame(
    package = c("good1", "good2", "unsynced", "issue")
  )
  json_staging$url <- file.path(
    "https://github.com/owner",
    json_staging$package
  )
  json_staging$branch <- "original"
  jsonlite::write_json(json_staging, file_staging, pretty = TRUE)
  meta_staging <- data.frame(
    package = c("good1", "good2", "issue", "removed", "unsynced"),
    remotesha = c(rep("original", 4), "sha-unsynced")
  )
  propose_snapshot(
    path_staging = path_staging,
    mock = list(staging = meta_staging)
  )
  json_snapshot <- jsonlite::read_json(
    file.path(path_staging, "snapshot.json"),
    simplifyVector = TRUE
  )
  expect_equal(json_snapshot$package, c("good1", "good2"))
  expect_equal(
    json_snapshot$url,
    file.path("https://github.com/owner", json_snapshot$package)
  )
  expect_equal(json_snapshot$branch, rep("original", 2L))
  expect_equal(ncol(json_snapshot), 3L)
  expect_equal(
    readLines(file.path(path_staging, "snapshot.url")),
    paste0(
      "https://staging.r-multiverse.org/api/snapshot/zip",
      "?types=src,win,mac",
      "&binaries=",
      rversions::r_release()$version,
      "&packages=good1,good2"
    )
  )
  propose_snapshot(
    path_staging = path_staging,
    mock = list(staging = meta_staging),
    r_versions = c("4.5", "4.4")
  )
  expect_equal(
    readLines(file.path(path_staging, "snapshot.url")),
    paste0(
      "https://staging.r-multiverse.org/api/snapshot/zip",
      "?types=src,win,mac&binaries=4.5,4.4&packages=good1,good2"
    )
  )
})
