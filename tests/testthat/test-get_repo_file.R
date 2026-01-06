test_that("get_repo_file() GitHub", {
  skip_if_offline()
  out <- get_repo_file(
    url = "https://github.com/r-multiverse/contributions",
    path = "organizations"
  )
  expect_true(is.character(out))
  expect_equal(length(out), 1L)
  expect_false(anyNA(out))
  expect_true(all(nzchar(out)))
  expect_true(grepl("r-multiverse", out))
})

test_that("get_repo_file() GitLab", {
  skip_if_offline()
  out <- get_repo_file(
    url = "https://gitlab.com/wlandau/test",
    path = "DESCRIPTION"
  )
  expect_true(is.character(out))
  expect_equal(length(out), 1L)
  expect_false(anyNA(out))
  expect_true(all(nzchar(out)))
  expect_true(grepl("test", out))
})

test_that("get_repo_file() Codeberg", {
  skip_if_offline()
  out <- get_repo_file(
    url = "https://codeberg.org/wlandau/test",
    path = "DESCRIPTION"
  )
  expect_true(is.character(out))
  expect_equal(length(out), 1L)
  expect_false(anyNA(out))
  expect_true(all(nzchar(out)))
  expect_true(grepl("test", out))
})
