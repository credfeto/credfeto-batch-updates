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
- optimise-git now reports failed git steps and exits non-zero, instead of reporting the optimisation as completed; the remaining repositories are still processed
- optimise-git no longer skips repositories whose paths merely contain the text cache; only repositories inside a .cache directory are excluded
- Updaters (dependencies, packages, templates and cleanup) now exit with an error when the tool update or the update pipeline fails, instead of carrying on as if they had succeeded; a failed tool install is ignored because it can fail when the tool is already installed
- optimise-git no longer treats submodule and worktree checkouts, whose .git is a file, as repositories to optimise; only normal clones (with a .git directory) are optimised, so bare and mirror repositories are not
- When an update fails, the updater still runs optimise-git before stopping, so stale git locks are cleared instead of making every later cycle fail (cleanup clears locks only on its weekly optimise day)
### Changed
- Push development container images to ghcr.io/credfeto instead of the private container registry, and point docker-compose at the new locations.
- Each updater now runs remote prune, reflog expire and gc at most once per ISO week, on its own GIT_OPTIMIZE_DAY, instead of on every update cycle
- The weekly git optimisation is recorded as done once every repository has been attempted, even if some failed, so one broken repository does not make it rerun across every repository on each cycle of the optimise day
### Deprecated
### Removed
### Deployment Changes

<!--
Releases that have at least been deployed to staging, BUT NOT necessarily released to live.  Changes should be moved from [Unreleased] into here as they are merged into the appropriate release branch
-->

## [0.0.0] - Project created