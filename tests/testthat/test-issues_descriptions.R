test_that("issues_descriptions() mocked", {
  issues <- issues_descriptions(meta = mock_meta_packages)
  expected <- list(
    audio.whisper = list(remotes = "bnosac/audio.vadwebrtc"),
    stantargets = list(
      remotes = c("hyunjimoon/SBC", "stan-dev/cmdstanr")
    ),
    SBC = list(cran = "1.0.0"),
    targetsketch = list(license = "non-standard"),
    tidypolars = list(remotes = "markvanderloo/tinytest/pkg")
  )
  names <- sort(names(issues))
  expect_equal(names, sort(names(expected)))
  expect_equal(issues[names], expected[names])
})

test_that("issues_descriptions() on a small repo", {
  meta <- meta_packages(repo = "https://wlandau.r-universe.dev")
  issues <- issues_descriptions(meta = meta)
  expect_true(is.list(issues))
})

test_that("issues_descriptions() with security advisories", {
  example <- mock_meta_packages$package == "nanonext"
  commonmark <- mock_meta_packages[example,, drop = FALSE] # nolint
  commonmark$package <- "commonmark"
  commonmark$version <- "0.2"
  readxl <- mock_meta_packages[example,, drop = FALSE] # nolint
  readxl$package <- "readxl"
  readxl$version <- "1.4.1"
  meta <- rbind(
    mock_meta_packages,
    commonmark,
    readxl
  )
  out <- issues_descriptions(meta)
  exp <- list(
    audio.whisper = list(remotes = "bnosac/audio.vadwebrtc"),
    commonmark = list(
      advisories = file.path(
        "https://github.com/RConsortium/r-advisory-database",
        "blob/main/vulns/commonmark",
        c("RSEC-2023-6.yaml", "RSEC-2023-7.yaml", "RSEC-2023-8.yaml")
      )
    ),
    readxl = list(
      advisories = file.path(
        "https://github.com/RConsortium/r-advisory-database",
        "blob/main/vulns/readxl/RSEC-2023-2.yaml"
      )
    ),
    stantargets = list(
      remotes = c("hyunjimoon/SBC", "stan-dev/cmdstanr")
    ),
    SBC = list(cran = "1.0.0"),
    targetsketch = list(license = "non-standard"),
    tidypolars = list(remotes = "markvanderloo/tinytest/pkg")
  )
  names <- sort(names(out))
  expect_equal(names, sort(names(exp)))
  expect_equal(out[names], exp[names])
})
