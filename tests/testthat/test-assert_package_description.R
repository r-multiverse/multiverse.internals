test_that("assert_package_description() no description", {
  skip_if_offline()
  out <- assert_package_description(
    name = "multiverse.internals",
    url = "https://github.com/r-multiverse/contributions"
  )
  expect_true(grepl("Could not read a DESCRIPTION file", out))
})

test_that("assert_package_description() GitHub", {
  skip_if_offline()
  expect_null(
    assert_package_description(
      name = "multiverse.internals",
      url = "https://github.com/r-multiverse/multiverse.internals"
    )
  )
})

test_that("assert_package_description() Codeberg", {
  skip_if_offline()
  expect_null(
    assert_package_description(
      name = "test",
      url = "https://codeberg.org/wlandau/test"
    )
  )
})

test_that("assert_package_description() GitLab + free-form license file", {
  skip_if_offline()
  out <- assert_package_description(
    name = "test",
    url = "https://gitlab.com/wlandau/test"
  )
  expect_true(grepl("contains text more complicated than the usual", out))
})

test_that("assert_package_description() GitHub + no license", {
  skip_if_offline()
  expect_null(
    assert_package_description(
      name = "multiverse.internals",
      url = "https://github.com/r-multiverse/multiverse.internals"
    )
  )
})

test_that("assert_description_local() on bad DESCRIPTION file", {
  out <- assert_description_local("name", list())
  expect_true(grepl("DESCRPTION file could not be parsed", out))
})

test_that("assert_description_local() good result", {
  path <- system.file(
    "DESCRIPTION",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  text <- paste(readLines(path), collapse = "\n")
  expect_null(
    assert_description_local(
      name = "multiverse.internals",
      text = text
    )
  )
})

test_that("assert_description_local() different name", {
  path <- system.file(
    "DESCRIPTION",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  text <- paste(readLines(path), collapse = "\n")
  out <- assert_description_local(
    name = "different",
    text = text
  )
  expect_true(grepl("R-multiverse listing name", out))
})

test_that("assert_parsed_description() no author", {
  path <- system.file(
    "DESCRIPTION",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  text <- paste(readLines(path), collapse = "\n")
  description <- desc::description$new(text = text)
  description$del("Authors@R")
  description$del("Author")
  description$del("Maintainer")
  out <- assert_parsed_description(
    name = "multiverse.internals",
    description = description
  )
  expect_true(grepl("does not list an author or maintainer", out))
})

test_that("assert_parsed_description() no license", {
  path <- system.file(
    "DESCRIPTION",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  text <- paste(readLines(path), collapse = "\n")
  description <- desc::description$new(text = text)
  description$del("License")
  out <- assert_parsed_description(
    name = "multiverse.internals",
    description = description
  )
  expect_true(grepl("Detected license", out))
})

test_that("assert_parsed_description() uncommon license", {
  path <- system.file(
    "DESCRIPTION",
    package = "multiverse.internals",
    mustWork = TRUE
  )
  text <- paste(readLines(path), collapse = "\n")
  description <- desc::description$new(text = text)
  description$set(License = "uncommon")
  out <- assert_parsed_description(
    name = "multiverse.internals",
    description = description
  )
  expect_true(grepl("Detected license", out))
})

test_that("assert_license_local() with free form text", {
  out <- assert_license_local(
    name = "test",
    path = "LICENSE",
    text = "free form text"
  )
  expect_true(grepl("contains text more complicated than the usual", out))
})

test_that("assert_license_local() with empty fields", {
  out <- assert_license_local(
    name = "test",
    path = "LICENSE",
    text = "YEAR:\nCOPYRIGHT HOLDER:person"
  )
  expect_true(grepl("key-value pairs with empty values", out))
})

test_that("assert_parsed_description() detects malformed Authors@R", {
  text <- paste(
    c(
      "Package: x",
      "Title: What the Package Does (One Line, Title Case)",
      "Version: 0.0.0.9000",
      "Authors@R: c(",
      "  person(\"First\", \"Last\", ,",
      "   \"first.last@example.com\", role = c(\"aut\", \"cre\"),",
      "   comment = c(ORCID = \"YOUR-ORCID-ID\")),",
      "   person(\"First\", \"Last\", ,",
      "  \"first.last@example.com\", role = c(\"aut\", \"cre\"),",
      "   comment = c(ORCID = \"YOUR-ORCID-ID\"))",
      "Description: What the package does (one paragraph).",
      "License: GPL-3"
    ),
    collapse = "\n"
  )
  x <- desc::description$new(text = text)
  expect_true(
    grepl(
      "Could not parse the Authors@R field of the package DESCRIPTION",
      assert_parsed_description("x", x),
      fixed = TRUE
    )
  )
})

test_that("assert_parsed_description() detects usethis default Authors@R", {
  text <- paste(
    c(
      "Package: x",
      "Title: What the Package Does (One Line, Title Case)",
      "Version: 0.0.0.9000",
      "Authors@R: c(",
      "  person(\"First\", \"Last\", ,",
      "   \"first.last@example.com\", role = c(\"aut\", \"cre\"),",
      "   comment = c(ORCID = \"YOUR-ORCID-ID\")),",
      "   person(\"First\", \"Last\", ,",
      "  \"first.last@example.com\", role = c(\"aut\", \"cre\"),",
      "   comment = c(ORCID = \"YOUR-ORCID-ID\")))",
      "Description: What the package does (one paragraph).",
      "License: GPL-3"
    ),
    collapse = "\n"
  )
  x <- desc::description$new(text = text)
  expect_true(
    grepl(
      "not a serious author name",
      assert_parsed_description("x", x)
    )
  )
})
