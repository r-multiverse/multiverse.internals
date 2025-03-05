test_that("meta_checks()", {
  out <- meta_checks(repo = "https://wlandau.r-universe.dev")
  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 1L)
  fields <- c("package", "url", "issues")
  expect_true(all(fields %in% colnames(out)))
})

test_that("meta_checks_process_json() with a source failure", {
  json <- structure(
    list(
      Package = c("mirai", "crew"),
      "_user" = c("r-multiverse-staging", "r-multiverse-staging"),
      "_type" = c("src", "src"),
      "_commit" = structure(
        list(
          id = c(
            "645738f41fbfac835bbce76596d6f924ce3c9549",
            "859a9b465e25e0ced329c36206488fb61382880c"
          )
        ),
        row.names = c(6L, 13L),
        class = "data.frame"
      ),
      "_status" = c("success", "success"),
      "_buildurl" = c(
        "https://github.com/r-universe/r-multiverse-staging/buildurl",
        "https://github.com/r-universe/r-multiverse-staging/buildurl"
      ),
      "_indexed" = c(FALSE, FALSE),
      "_binaries" = list(
        structure(
          list(
            r = c(
              "4.5.0", "4.4.2", "4.5.0", "4.3.3", "4.4.2", "4.3.3",
              "4.4.1", "4.5.0", "4.3.3", "4.4.2"
            ),
            os = c(
              "linux", "linux",
              "mac", "mac", "mac", "wasm", "wasm", "win", "win", "win"
            ),
            commit = c(
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549",
              "645738f41fbfac835bbce76596d6f924ce3c9549"
            ),
            status = c(
              "success", "success", "success", "success",
              "success", "success", "success", "success", "success", "success"
            ),
            check = c(
              "OK", "OK", "OK", "OK", "OK", NA, NA, "OK", "OK", "OK"
            ),
            buildurl = c(
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary"
            )
          ),
          class = "data.frame",
          row.names = c(NA, 10L)
        ),
        structure(
          list(
            r = c(
              "4.5.0", "4.4.2", "4.3.3", "4.4.2", "4.3.3", "4.4.1",
              "4.5.0", "4.3.3", "4.4.2"
            ),
            os = c(
              "linux", "linux", "mac",
              "mac", "wasm", "wasm", "win", "win", "win"
            ),
            commit = c(
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c",
              "859a9b465e25e0ced329c36206488fb61382880c"
            ),
            status = c(
              "success", "success", "success", "success",
              "success", "success", "success", "success", "success"
            ),
            check = c("OK", "OK", "OK", "OK", NA, NA, "OK", "OK", "OK"),
            buildurl = c(
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary",
              "https://github.com/r-universe/r-multiverse-staging/binary"
            )
          ),
          class = "data.frame",
          row.names = c(NA, 9L)
        )
      ),
      "_failure" = structure(
        list(
          commit = structure(
            list(
              id = c(NA, "859a9b465e25e0ced329c36206488fb61382880c"
              )
            ),
            row.names = c(6L, 13L),
            class = "data.frame"
          ),
          buildurl = c(
            NA,
            "https://github.com/r-universe/r-multiverse-staging/failure"
          )
        ),
        row.names = c(6L, 13L),
        class = "data.frame"
      )
    ),
    row.names = c(6L, 13L),
    class = "data.frame"
  )
  out <- meta_checks_process_json(json)
  expect_equal(nrow(out), 2L)
  expect_equal(sort(out$package), sort(c("crew", "mirai")))
  expect_equal(
    out$url[out$package == "mirai"],
    "https://github.com/r-universe/r-multiverse-staging/buildurl"
  )
  expect_equal(
    out$url[out$package == "crew"],
    "https://github.com/r-universe/r-multiverse-staging/failure"
  )
  expect_equal(out$issues[[which(out$package == "mirai")]], list())
  expect_equal(
    out$issues[[which(out$package == "crew")]],
    list(source = "FAILURE")
  )
})
