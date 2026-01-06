test_that("review_package() on a failing package", {
  expect_message(
    out <- review_package(name = letters, url = "xy"),
    regexp = "did not pass"
  )
  expect_false(out)
})

test_that("review_package() on a successful package", {
  expect_message(
    out <- review_package(
      name = "multiverse.internals",
      url = "https://github.com/r-multiverse/multiverse.internals"
    ),
    regexp = "passed"
  )
  expect_true(out)
})

test_that("invalid package name with vector", {
  expect_true(
    grepl(
      "Invalid package name",
      review_package_text(name = letters, url = "xy"),
      fixed = TRUE
    )
  )
})

test_that("invalid package name with vector", {
  expect_true(
    grepl(
      "Invalid package name",
      review_package_text(name = letters, url = "xy"),
      fixed = TRUE
    )
  )
})

test_that("invalid package name with dot", {
  expect_true(
    grepl(
      "Invalid package name",
      review_package_text(
        name = ".gh",
        url = "https://github.com/r-lib/gh"
      ),
      fixed = TRUE
    )
  )
})

test_that("custom JSON", {
  expect_true(
    grepl(
      "looks like JSON",
      review_package_text(name = "xy", url = "{"),
      fixed = TRUE
    )
  )
})

test_that("advisory", {
  expect_true(
    grepl(
      "advisory",
      review_package_text(
        name = "def",
        url = "https://github.com/abc/def",
        advisories = c("abc", "def")
      ),
      fixed = TRUE
    )
  )
})

test_that("invalid vector URL", {
  expect_true(
    grepl(
      "Invalid package URL",
      review_package_text(
        name = "xy",
        url = letters
      ),
      fixed = TRUE
    )
  )
})

test_that("malformed URL", {
  expect_true(
    grepl(
      "Found malformed URL",
      review_package_text(
        name = "gh",
        url = "github.com/r-lib/gh"
      ),
      fixed = TRUE
    )
  )
})

test_that("package name/repo discrpeancy", {
  expect_true(
    grepl(
      "is different from the repository name in the URL",
      review_package_text(
        name = "gh2",
        url = "https://github.com/r-lib/gh"
      ),
      fixed = TRUE
    )
  )
})

test_that("https", {
  expect_true(
    grepl(
      "is not https",
      review_package_text(
        name = "gh",
        url = "http://github.com/r-lib/gh"
      ),
      fixed = TRUE
    )
  )
})

test_that("source code URL", {
  expect_true(
    grepl(
      "is not a repository in GitHub",
      review_package_text(
        name = "gh",
        url = "https://github.gov/r-lib/gh",
        advisories = character(0L)
      ),
      fixed = TRUE
    )
  )
})

test_that("owner URL", {
  expect_true(
    grepl(
      "appears to be an owner",
      review_package_text(
        name = "gh",
        url = "https://github.com/gh",
        advisories = character(0L)
      ),
      fixed = TRUE
    )
  )
})

test_that("CRAN mirror", {
  expect_true(
    grepl(
      "appears to use a CRAN mirror",
      review_package_text(
        name = "gh",
        url = "https://github.com/cran/gh",
        advisories = character(0L)
      ),
      fixed = TRUE
    )
  )
})

test_that("CRAN URL alignment", {
  expect_true(
    grepl(
      "does not appear in its DESCRIPTION file published on CRAN",
      assert_cran_url(
        name = "gh",
        url = "https://github.com/r-lib/gha"
      ),
      fixed = TRUE
    )
  )
})

test_that("HTTP error", {
  expect_true(
    grepl(
      "returned HTTP error",
      review_package_text(
        name = "afantasticallylongandimpossiblepackage",
        url = "https://github.com/r-lib/afantasticallylongandimpossiblepackage"
      ),
      fixed = TRUE
    )
  )
})

test_that("release URL", {
  expect_true(
    grepl(
      "No full release found at URL",
      review_package_text(
        name = "test.no.release",
        url = "https://github.com/wlandau/test.no.release"
      ),
      fixed = TRUE
    )
  )
})

test_that("good GitHub registration", {
  expect_null(
    review_package_text(
      name = "gh",
      url = "https://github.com/r-lib/gh",
      advisories = character(0L)
    )
  )
})

test_that("GitLab registration with free-form license", {
  tmp <- utils::capture.output(
    suppressMessages(
      out <- review_package_text(
        name = "test",
        url = "https://gitlab.com/wlandau/test"
      )
    )
  )
  expect_true(grepl("LICENSE contains text more complicated than", out))
})

test_that("good registration with trailing slash", {
  expect_null(
    assert_cran_url(
      name = "curl",
      url = "https://github.com/jeroen/curl/"
    )
  )
})

test_that("good alignment with CRAN URL", {
  expect_null(
    assert_cran_url(
      name = "jsonlite",
      url = "https://github.com/jeroen/jsonlite"
    )
  )
})

test_that("trivially good alignment with CRAN URL", {
  expect_null(
    assert_cran_url(
      name = "packageNOTonCRAN",
      url = "https://github.com/jeroen/jsonlite"
    )
  )
})
