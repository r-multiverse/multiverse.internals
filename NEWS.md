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
