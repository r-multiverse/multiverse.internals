test_that("interpret_status() with no data", {
  expect_equal(
    interpret_status("abc", list()),
    "Data not found on package abc."
  )
})

test_that("interpret_status() with a successful package", {
  expect_equal(
    interpret_status(
      "abc",
      list(
        abc = list(
          success = TRUE,
          version = "v",
          published = "d",
          remote_hash = "h"
        )
      )
    ),
    paste(
      "R-multiverse checks passed for package abc version v remote",
      "hash h (last published at d)."
    )
  )
})

test_that("interpret_status() with advisories", {
  skip_if_offline()
  mock <- mock_meta_packages
  for (field in c("_id", "_dependencies", "distro", "remotes")) {
    mock[[field]] <- NULL
  }
  example <- mock$package == "nanonext"
  commonmark <- mock[example,, drop = FALSE] # nolint
  commonmark$package <- "commonmark"
  commonmark$version <- "0.2"
  readxl <- mock[example,, drop = FALSE] # nolint
  readxl$package <- "readxl"
  readxl$version <- "1.4.1"
  meta <- rbind(
    mock[seq_len(nrow(mock)), ], # to suppress a warning
    commonmark,
    readxl
  )
  output <- tempfile()
  versions <- tempfile()
  record_versions(
    versions = versions,
    repo = "https://wlandau.r-universe.dev"
  )
  on.exit(unlink(c(output, versions), recursive = TRUE))
  record_status(
    mock = list(packages = meta, checks = mock_meta_checks),
    output = output,
    versions = versions
  )
  status <- jsonlite::read_json(output, simplifyVector = TRUE)
  out <- interpret_status("commonmark", status)
  expect_true(
    grepl(
      "Found the following advisories in the R Consortium Advisory Database",
      out
    )
  )
})

test_that("interpret_status() with bad licenses", {
  skip_if_offline()
  mock <- mock_meta_packages[mock_meta_packages$package == "targetsketch", ]
  output <- tempfile()
  versions <- tempfile()
  record_versions(
    versions = versions,
    repo = "https://wlandau.r-universe.dev"
  )
  on.exit(unlink(c(output, versions), recursive = TRUE))
  record_status(
    mock = list(packages = mock, checks = mock_meta_checks),
    output = output,
    versions = versions
  )
  status <- jsonlite::read_json(output, simplifyVector = TRUE)
  out <- interpret_status("targetsketch", status)
  expect_true(
    grepl(
      "targetsketch declares license",
      out
    )
  )
})

test_that("interpret_status() checks etc.", {
  skip_if_offline()
  output <- tempfile()
  lines <- c(
    "[",
    " {",
    " \"package\": \"constantversion\",",
    " \"version_current\": \"1.0.0\",",
    " \"hash_current\": \"hash_1.0.0-modified\",",
    " \"version_highest\": \"1.0.0\",",
    " \"hash_highest\": \"hash_1.0.0\"",
    " }",
    "]"
  )
  versions <- tempfile()
  writeLines(lines, versions)
  on.exit(unlink(c(output, versions), recursive = TRUE))
  record_status(
    mock = list(packages = mock_meta_packages, checks = mock_meta_checks),
    output = output,
    versions = versions
  )
  status <- jsonlite::read_json(output, simplifyVector = TRUE)
  expect_true(
    grepl(
      "Not all checks succeeded on R-universe",
      interpret_status("INLA", status)
    )
  )
  expect_true(
    grepl(
      "Not all checks succeeded on R-universe",
      interpret_status("colorout", status)
    )
  )
  expect_true(
    grepl(
      "Package releases should not use the 'Remotes:' field",
      interpret_status("audio.whisper", status),
      fixed = TRUE
    )
  )
  expect_true(
    grepl(
      "bnosac/audio.vadwebrtc",
      interpret_status("audio.whisper", status),
      fixed = TRUE
    )
  )
  expect_true(
    grepl(
      "On CRAN",
      interpret_status("SBC", status)
    )
  )
  status$tidypolars$dependencies <- list(x = "y")
  expect_true(
    grepl(
      "One or more strong R package dependencies have issues",
      interpret_status("tidypolars", status)
    )
  )
  expect_true(
    grepl(
      "The version number of the current release should be highest version",
      interpret_status("constantversion", status)
    )
  )
})

test_that("interpret_status() with complicated dependency problems", {
  output <- tempfile()
  lines <- c(
    "[",
    " {",
    " \"package\": \"nanonext\",",
    " \"version_current\": \"1.0.0\",",
    " \"hash_current\": \"hash_1.0.0-modified\",",
    " \"version_highest\": \"1.0.0\",",
    " \"hash_highest\": \"hash_1.0.0\"",
    " }",
    "]"
  )
  versions <- tempfile()
  on.exit(unlink(c(output, versions), recursive = TRUE))
  writeLines(lines, versions)
  meta_checks <- mock_meta_checks[1L, ]
  meta_checks$package <- "crew"
  suppressMessages(
    record_status(
      versions = versions,
      mock = list(
        checks = meta_checks,
        packages = mock_meta_packages_graph
      ),
      output = output,
      verbose = TRUE
    )
  )
  expect_true(file.exists(output))
  status <- jsonlite::read_json(output, simplifyVector = TRUE)
  expect_equal(
    status$nanonext,
    list(
      versions = list(
        version_current = "1.0.0",
        hash_current = "hash_1.0.0-modified",
        version_highest = "1.0.0",
        hash_highest = "hash_1.0.0"
      ),
      success = FALSE,
      published = "published_5",
      version = "1.1.0.9000",
      remote_hash = "85dd672a44a92c890eb40ea9ebab7a4e95335c2f"
    )
  )
  expect_equal(
    status$mirai,
    list(
      dependencies = list(
        nanonext = list()
      ),
      success = FALSE,
      published = "published_4",
      version = "1.1.0.9000",
      remote_hash = "7015695b7ef82f82ab3225ac2d226b2c8f298097"
    )
  )
  expect_equal(
    status$crew,
    list(
      checks = list(
        url = file.path(
          "https://github.com/r-universe/r-multiverse/actions",
          "runs/11898760503"
        ),
        issues = list(
          `linux R-4.5.0` = "WARNING",
          `mac R-4.4.2` = "WARNING",
          `win R-4.4.2` = "WARNING"
        )
      ),
      dependencies = list(nanonext = "mirai"),
      success = FALSE,
      published = "published_1",
      version = "0.9.3.9002",
      remote_hash = "eafad0276c06dec2344da2f03596178c754c8b5e"
    )
  )
  expect_true(
    grepl(
      "nanonext: mirai",
      interpret_status("crew", status)
    )
  )
  expect_true(
    grepl(
      "nanonext: crew",
      interpret_status("crew.aws.batch", status)
    )
  )
  expect_true(
    grepl(
      "Dependency nanonext is explicitly mentioned in",
      interpret_status("mirai", status)
    )
  )
})

test_that("interpret_status(): check these interactively", {
  skip_if_offline()
  status <- list(
    bad = list(
      checks = list(
        url = "https://github.com/12103194809",
        status = list(
          `linux x86_64 R-4.5.0` = "WARNING",
          `mac aarch64 R-4.4.2` = "WARNING",
          `mac x86_64 R-4.4.2` = "WARNING",
          `win x86_64 R-4.4.2` = "WARNING"
        )
      ),
      descriptions = list(
        license = "non-standard",
        advisories <- c("link1", "link2", "link3"),
        remotes = "markvanderloo/tinytest/pkg"
      ),
      dependencies = list(
        nanonext = "mirai",
        mirai = list(),
        a = list(),
        b = c("x", "yasdf", "z")
      ),
      versions = list(
        version_current = "1.0.0",
        hash_current = "hash_1.0.0-modified",
        version_highest = "1.0.0",
        hash_highest = "hash_1.0.0"
      )
    )
  )
  status$bad2 <- status$bad
  status$bad2$dependencies <- list(
    nanonext = "mirai",
    b = c("x", "yasdf", "z")
  )
  status$bad3 <- status$bad
  status$bad3$dependencies <- list(
    nanonext = list(),
    b = list()
  )
  status$bad4 <- status$bad
  status$bad4$dependencies <- list(
    nanonext = "mirai"
  )
  status$bad5 <- status$bad
  status$bad5$dependencies <- list(
    nanonext = list()
  )
  temp <- tempfile(fileext = ".html")
  on.exit(unlink(temp))
  for (package in names(status)) {
    text <- interpret_status(package, status)
    expect_true(grepl("found issues", text))
    writeLines(text, temp)
    # browseURL(temp) # nolint
    # browser() # nolint
  }
})
