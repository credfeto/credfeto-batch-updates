# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Please ADD ALL Changes to the UNRELEASED SECTION and not a specific release
-->

## [Unreleased]
### Security
### Added
### Fixed
- Fixed stale ssh key ownership on host-provisioned directories that blocked git clones after pinning the updater user's uid/gid
- Updaters (dependencies, packages, templates and cleanup) now exit with an error when the tool install or update pipeline fails, instead of carrying on as if they had succeeded
- optimise-git now reports failed git steps and exits non-zero, instead of reporting the optimisation as completed; the remaining repositories are still processed
- optimise-git no longer skips repositories whose paths merely contain the text cache; only repositories inside a .cache directory are excluded
- optimise-git no longer treats submodule and worktree checkouts, whose .git is a file, as repositories to optimise
### Changed
- Push development container images to ghcr.io/credfeto instead of the private container registry, and point docker-compose at the new locations.
- optimise-git now runs remote prune, reflog expire and gc at most once per ISO week, only on the GIT_OPTIMIZE_DAY, instead of on every update cycle, and is shared by all updaters
- The weekly git optimisation is only recorded as done once all of its git steps have succeeded, so a failed run is not treated as complete for that week
### Deprecated
### Removed
### Deployment Changes

<!--
Releases that have at least been deployed to staging, BUT NOT necessarily released to live.  Changes should be moved from [Unreleased] into here as they are merged into the appropriate release branch
-->

## [0.0.0] - Project created