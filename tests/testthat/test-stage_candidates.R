test_that("stage_candidates() for the first time in a Staging cycle", {
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
  file_staged <- file.path(path_staging, "staged.json")
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
  unlink(file_staged)
  stage_candidates(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  expect_equal(config$cran_version, meta_snapshot()$dependency_freeze)
  staged <- jsonlite::read_json(file_staged, simplifyVector = TRUE)
  expect_equal(sort(staged), sort(c("staged", "removed-no-issue")))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("add", "staged", "issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "add"], "sha-add")
  expect_equal(packages$branch[packages$package == "staged"], "sha-staged")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
  expect_equal(
    readLines(file.path(path_staging, "snapshot.url")),
    paste0(
      "https://staging.r-multiverse.org/api/snapshot/tar",
      "?types=src,win,mac",
      "&binaries=",
      meta_snapshot()$r,
      "&skip_packages=add,issue"
    )
  )
  meta <- jsonlite::read_json(
    file.path(path_staging, "snapshot.json"),
    simplifyVector = TRUE
  )
  expect_equal(length(meta), 6L)
  expect_equal(meta$dependency_freeze, meta_snapshot()$dependency_freeze)
  expect_equal(meta$candidate_freeze, meta_snapshot()$candidate_freeze)
  expect_equal(meta$snapshot, meta_snapshot()$snapshot)
  expect_equal(meta$r, meta_snapshot()$r)
  expect_true(is.character(meta$cran))
  expect_true(is.character(meta$r_multiverse))
})

test_that("stage_candidates() in the middle of a Staging cycle", {
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
  file_staged <- file.path(path_staging, "staged.json")
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
  stage_candidates(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  staged <- jsonlite::read_json(file_staged, simplifyVector = TRUE)
  expect_equal(sort(staged), sort(c("staged", "removed-no-issue")))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("staged", "issue", "removed-no-issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "staged"], "original")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
  expect_equal(
    packages$branch[packages$package == "removed-no-issue"],
    "original"
  )
  expect_equal(
    readLines(file.path(path_staging, "snapshot.url")),
    paste0(
      "https://staging.r-multiverse.org/api/snapshot/tar",
      "?types=src,win,mac",
      "&binaries=",
      meta_snapshot()$r,
      "&skip_packages=issue,removed-has-issue"
    )
  )
})

test_that("stage_candidates() when a frozen package breaks", {
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
  file_staged <- file.path(path_staging, "staged.json")
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
  file_issues <- file.path(path_staging, "issues.json")
  json_issues <- jsonlite::read_json(file_issues, simplifyVector = TRUE)
  json_issues$staged <- json_issues$issue
  jsonlite::write_json(json_issues, file_issues, pretty = TRUE)
  stage_candidates(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  staged <- jsonlite::read_json(file_staged, simplifyVector = TRUE)
  expect_equal(sort(staged), sort(c("staged", "removed-no-issue")))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("staged", "issue", "removed-no-issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "staged"], "original")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
  expect_equal(
    packages$branch[packages$package == "removed-no-issue"],
    "original"
  )
})

test_that("stage_candidates() when a broken package gets fixed", {
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
  file_staged <- file.path(path_staging, "staged.json")
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
  file_issues <- file.path(path_staging, "issues.json")
  json_issues <- jsonlite::read_json(file_issues, simplifyVector = TRUE)
  json_issues$issue <- json_issues$staged
  jsonlite::write_json(json_issues, file_issues, pretty = TRUE)
  stage_candidates(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  staged <- jsonlite::read_json(file_staged, simplifyVector = TRUE)
  expect_equal(sort(staged), sort(c("staged", "issue", "removed-no-issue")))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("staged", "issue", "removed-no-issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "staged"], "original")
  expect_equal(packages$branch[packages$package == "issue"], "original")
  expect_equal(
    packages$branch[packages$package == "removed-no-issue"],
    "original"
  )
})

test_that("stage_candidates() with frozen package removed from Community", {
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
  file_staged <- file.path(path_staging, "staged.json")
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  json_staging <- jsonlite::read_json(file_staging)
  json_community <- jsonlite::read_json(file_community, simplifyVector = TRUE)
  json_community <- json_community[json_community$package != "staged", ]
  jsonlite::write_json(json_community, file_community, pretty = TRUE)
  names_community <- json_community$package
  meta_community <- data.frame(
    package = names_community,
    remotesha = paste0("sha-", names_community)
  )
  meta_community <- meta_community[meta_community$package != "staged", ]
  stage_candidates(
    path_staging = path_staging,
    path_community = path_community,
    mock = list(community = meta_community)
  )
  config <- jsonlite::read_json(file_config, simplifyVector = TRUE)
  expect_equal(names(config), "cran_version")
  expect_true(is.character(config$cran_version))
  staged <- jsonlite::read_json(file_staged, simplifyVector = TRUE)
  expect_equal(sort(staged), sort(c("staged", "removed-no-issue")))
  packages <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  expect_true(is.data.frame(packages))
  expect_equal(dim(packages), c(3L, 3L))
  names <- c("staged", "issue", "removed-no-issue")
  expect_equal(sort(packages$package), sort(names))
  expect_equal(
    packages$url,
    file.path("https://github.com/owner", packages$package)
  )
  expect_equal(packages$branch[packages$package == "staged"], "original")
  expect_equal(packages$branch[packages$package == "issue"], "sha-issue")
  expect_equal(
    packages$branch[packages$package == "removed-no-issue"],
    "original"
  )
})
