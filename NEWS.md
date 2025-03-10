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
