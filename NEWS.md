# multiverse.internals 1.1.9

* Bug fix: handle source build failures in `issues_synchronization()`.

# multiverse.internals 1.1.8

* Filter out the `File` column from all `PACKAGES` and `PACKAGES.gz` files (<https://github.com/r-multiverse/help/issues/173>, @andres-ixpantia).

# multiverse.internals 1.1.7

* Write `snapshot.json` during the dependency freeze.
* Regenerate `README.md`.

# multiverse.internals 1.1.6

* Ensure compatibility with `parse_url()` in `nanonext` 2.0.0.

# multiverse.internals 1.1.5

* Make `review_license()` and `review_package()` friendlier for manual reviews. These functions now print nicely formatted R console messages the the results of each review.

# multiverse.internals 1.1.4

* Move `assert_package()` to `review_package()` and add examples. `review_package()` is how the bot checks each package review, and the ability to run it locally will really help ease the manual work of moderators.
* Cache the output of `read_advisories()` in memory for performance.
* Remove false positives (source build failures) from `nonstandard_licenses.json` (#168).

# multiverse.internals 1.1.3

* Clarify expectations for adding organizations.

# multiverse.internals 1.1.2

* Clarify that pull requests to add organizations should be separate from ones that contribute packages.

# multiverse.internals 1.1.1

* Count the number of packages in each section of the status page.
* Use the Air formatter.

# multiverse.internals 1.1.0

* Add `issues_synchronization()` and factor it into `record_status()` and `interpret_status()` (https://github.com/r-multiverse/help/issues/156).

# multiverse.internals 1.0.15

* Use the `_jobs` field instead of `_binaries` to get `R CMD check` results from the R-universe API (https://github.com/r-multiverse/help/issues/162).
* Use direct job links and improve style when reporting `R CMD check` results at r-multiverse.org/status.

# multiverse.internals 1.0.14

* Do not penalize reverse dependencies of already staged packages with failing checks (https://github.com/r-multiverse/help/issues/163).

# multiverse.internals 1.0.13

* Simplify `meta_packages()`: only call the R-universe API to get package metadata.

# multiverse.internals 1.0.12

* Fix `record_nonstandard_licenses()` (continuation of 1.0.11).

# multiverse.internals 1.0.11

* Use `tools::analyze_license()` for continuous license checks because `utils::available.packages(repos = "https://community.r-multiverse.org", filters = "license/FOSS")` no longer returns output.
* Strengthen continuous license checks: an `NA` license (from a failed source build) is no longer acceptable.

# multiverse.internals 1.0.10

* Allow `review_pull_request()` to get advisories and organizations if not supplied.

# multiverse.internals 1.0.9

* Use `tools::analyze_license()` to determine if a package in a registration request has an open-source license. This is much more consistent and reliable than checking a manual list of license specification strings.
* Fix `meta_snapshot()` tests (check against the correct versions of R for the year 2025).
* Fix `rclone_includes()` tests: use the upcoming snapshot R version.

# multiverse.internals 1.0.8

* Subsume `meta_checks()` into `meta_packages()`.
* Rename `status_checks()` to `status_r_cmd_check()`. In general, refer to "R CMD check" instead of the more ambiguous "checks" where appropriate.
* Factor out the R-multiverse checks into their own functions with prefix "issues_". Simplify the management and aggregation of this issue data.

# multiverse.internals 1.0.7

* Fix status links.

# multiverse.internals 1.0.6

* Report the date last published on R-universe.

# multiverse.internals 1.0.5

* Revamp topics website.

# multiverse.internals 1.0.4

* Move status markdown template files outside `multiverse.internals`.

# multiverse.internals 1.0.3

* Fix empty entries in status website.

# multiverse.internals 1.0.2

* Fix bugs in handling missing version and remote hash.

# multiverse.internals 1.0.1

* Handle source failures in `record_status()`.
* Use markdown for `update_status()`.

# multiverse.internals 1.0.0

* Rename "issues" to "status" throughout the package, including in function names.
* Notably, rename `issue.json` to `status.json`.

# multiverse.internals 0.4.10

* Simplify `stage_candidates()`, `rclone_includes()`, and `update_status()`: get remote hashes from pre-recorded `issues.json`, as opposed to a separate call to `meta_packages()`. This ensures those remote hashes are more contemporaneous with the corresponding reported check results.

# multiverse.internals 0.4.9

* In `stage_candidates()`, set `"branch": "*release"` in Staging to allow broken packages to update faster.
* In `stage_candidates()`, ensure that removing a package from Community does not automatically remove it from Staging during the candidate freeze.
* Avoid the need for `staged.json`. Simplifies `multiverse.internals` a lot, especially `stage_candidates()`.

# multiverse.internals 0.4.8

* Sort `staged.json`.

# multiverse.internals 0.4.7

* Remove the `types` argument of `stage_candidates()`.

# multiverse.internals 0.4.6

* Add `rclone_includes()`.

# multiverse.internals 0.4.5

* Replace `snapshot.url` with Rclone filters.
* Add `filter_packages()`

# multiverse.internals 0.4.4

* Implement separate freezes for dependencies and release candidates (#146).
* Add `freeze_dependencies()`.

# multiverse.internals 0.4.3

* Consolidate snapshot metadata management in `meta_snapshot()`.
* Subsume `update_staging()` and `propose_snapshot()` into `stage_candidates()`.
* Rename `freeze.json` to `staged.json`.
* Rename `meta.json` to `snapshot.json`.
* Write a `production.html` page in `update_status()`.

# multiverse.internals 0.4.2

* Rearrange fields in `meta.json`.
* Remove the superfluous `snapshot.json` file.

# multiverse.internals 0.4.1

* Restructure `meta.json` to better maintain a snapshot archive.

# multiverse.internals 0.4.0

* Organize R version and snapshot/staging date information more neatly in `meta.json`.
* Use the new `skip_packages` parameter in the R-universe snapshot API.
* Disallow packages to enter or leave the Staging universe `packages.json` during the Staging period.
* Record healthy packages in `record_issues()` to support the above.

# multiverse.internals 0.3.9

* Target Linux R-release instead of Linux R-devel (#112).

# multiverse.internals 0.3.8

* In the status repo, list all packages with check issues for each of Community and Staging.

# multiverse.internals 0.3.7

* Shift yearly Staging schedule to begin in January and end in December.
* Freeze the targeted base R version at the start of Staging each quarter.

# multiverse.internals 0.3.6

* Detect source failures as issues.
* Flag R-multiverse packages whose CRAN versions from the day of the Staging freeze are higher than the current versions in R-multiverse.
* Use the whole R version in `propose_snapshot()` so downstream automation can grep the snapshot URL for the version instead of needing to install R and the `rversions` package.
* Write `config.json` in Staging to select the CRAN snapshot from the start of the freeze.

# multiverse.internals 0.3.5

* Depend on R >= 4.4.0 for the base coalescing operator `%||%`.
* Only snapshot binaries for the current R release.

# multiverse.internals 0.3.4

* Use `<pre>` to render YAML in HTML.

# multiverse.internals 0.3.3

* Remove a superfluous text replacement in status system.

# multiverse.internals 0.3.2

* Use the `_binaries` field of the R-universe check API.
* Enforce `R CMD check` errors and warnings.
* Report check errors more clearly.
* Make it easy to add/remove the check platforms and R versions we enforce.

# multiverse.internals 0.3.1

* Add extra checks for `Authors@R` in `assert_parsed_description()`.

# multiverse.internals 0.3.0.9000 (development)

* Test `update_topics()` on an empty topic.

# multiverse.internals 0.3.0

* Add `update_topics()`.

# multiverse.internals 0.2.21

* Add back HTML line breaks in `update_status()`.

# multiverse.internals 0.2.20

* Ensure valid RSS feeds created by `update_status()`.

# multiverse.internals 0.2.19

* Fix help file examples of `record_issues()`.
* Link to RSS feed from status page.

# multiverse.internals 0.2.18

* Use a single JSON file for upstream issue data.
* Rename `interpret_issue()` to `interpret_status()`.
* Add `update_status()`.

# multiverse.internals 0.2.17

* Align contribution reviews with revised review policy in https://github.com/r-multiverse/r-multiverse.github.io/pull/33.

# multiverse.internals 0.2.16

* Add `interpret_issue()` to help create RSS feeds.
* Add `record_nonstandard_licenses()`

# multiverse.internals 0.2.14

* Allow `update_staging()` to work if the staging `packages.json` does not exist.
* Remove `staging_is_resetting()` and rely on the cron syntax from <https://github.com/r-multiverse/staging/pull/3> to schedule the management of the staging universe.

# multiverse.internals 0.2.13

* Record issues for vulnerabilities in <https://github.com/RConsortium/r-advisory-database>.

# multiverse.internals 0.2.12

* Amend argument defaults in `propose_snapshot()` to include source files.

# multiverse.internals 0.2.11

* Implement `propose_snapshot()`.
* Exempt Production from WASM checks.

# multiverse.internals 0.2.10

* Implement freezing mechanism in `update_staging()`.
* Implement `staging_is_active()` to detect when the staging universe should be active.

# multiverse.internals 0.2.9

* Implement community/staging idea from (@jeroen).

# multiverse.internals 0.2.8

* Only merge contributions created through the web interface.

# multiverse.internals 0.2.7

* Exclude superfluous fields from `update_production()` `packages.json`.
* Require verified commits in contributions.

# multiverse.internals 0.2.6

* Add `update_production()`.

# multiverse.internals 0.2.4

* Updates R-Multiverse repository to `community.r-multiverse.org`.
* Makes `meta_checks()` and `meta_packages()` robust to trailing slashes in the supplied URL.
* Repair `issues_dependencies()` for empty graphs.

# multiverse.internals 0.2.2

* Add `issues_dependencies()`.

# multiverse.internals 0.2.1

* Bump version to trigger rebuild.

# multiverse.internals 0.2.0

* Add more checks to `record_issues()`: results from the R-universe check API, plus specific results from package `DESCRIPTION` files.
* Refactor and document specific checks in `check_checks()`, `check_descriptions()`, and `check_versions()`.
* Add a `pkgdown` website.

# multiverse.internals 0.1.4

* Do not write `version_issues.json` from `record_versions()`.
* Record version issues in separate JSON files in a new `record_issues()` function. Going forward, this function will also write R-universe check results in those individual package-specific files.

# multiverse.internals 0.1.3

* In `record_versions()`, left-join old versions into new versions to avoid spamming `versions.json` with an unbounded list of renamed or abandoned packages.

# multiverse.internals 0.1.2

* Remove URL reference.

# multiverse.internals 0.1.1

* Rename internal functions and arguments.

# multiverse.internals 0.1.0

* Rename the package to `multiverse.internals`.

# r.releases.internals 0.0.16

* Retry failed merge attempts.
* Use `testthat`

# r.releases.internals 0.0.15

* Add explicit check that each contribution has only 1 line.

# r.releases.internals 0.0.14

* Allow terminating newline to be absent in URL contributions.

# r.releases.internals 0.0.13

* Reformat bot messages.

# r.releases.internals 0.0.12

* Improve bot comment messages.
* Change default contribution repo from `r-releases` to `contributions`.

# r.releases.internals 0.0.11

* Quick bug fix: avoid `NA` entries in `version_issues.json`.

# r.releases.internals 0.0.10

* Automatically merge GitLab URLs with non-"upcoming" releases.
* Rename `build_universe()` to `write_universe_manifest()`. 
* `write_universe_manifest()` omits `"branch": "release"` from listings originating from a short list of prespecified GitHub/GitLab owners. The new `release_exceptions` can accept `"https://github.com/cran"`, for example.

# r.releases.internals 0.0.9

* Change the package name to `r.releases.internals`.
* Get RemoteSha hashes for checking versions (@jeroen, https://github.com/r-universe-org/help/issues/377).
* Makes `review_pull_requests()` robust to a package description with no URL listed.

# r.releases.utils 0.0.8

* Use R-releases and not `r-releases` to refer to the project.
* Edit bot messages.
* Add `record_versions()`.

# r.releases.utils 0.0.7

* Check if a release exists during automated checks.

# r.releases.utils 0.0.6

* Check URL exists as part of package verification.

# r.releases.utils 0.0.5

* Write pretty JSON to `packages.json` (@llrs, https://github.com/r-releases/help/issues/4).

# r.releases.utils 0.0.4

* Relax some assertions so `build_universe()` can run on reasonable cases.

# r.releases.utils 0.0.3

* Checks URL matches the package description for CRAN packages.
* `check_package()` checks the URL and name directly, not a file.
* Add more strict URL assertions.
* Accept custom JSON entries but flag them for manual review.
* Print progress messages from `build_universe()`.

# r.releases.utils 0.0.2

* Trim white space when processing URLs.

# r.releases.utils 0.0.1

* First version.
