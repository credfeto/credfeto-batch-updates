# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Please ADD ALL Changes to the UNRELEASED SECTION and not a specific release
-->

## [Unreleased]
### Security
- The .NET SDK version check fetches releases-index.json through the dotnet package cache ($DOTNET_PROXY_HOST) instead of directly from dotnetcli.blob.core.windows.net, so the updaters no longer bypass the proxy
- Updater images (cleanup, dependencies, packages, templates) set DOTNET_CLI_TELEMETRY_OPTOUT, DOTNET_NOLOGO, DOTNET_SKIP_FIRST_TIME_EXPERIENCE and AWS_EC2_METADATA_DISABLED, so the .NET CLI no longer sends usage telemetry to Azure Application Insights and SDK credential chains stop probing the cloud metadata endpoint; the host egress table rejects 169.254.169.254 immediately instead of letting probes time out
- Firewall: the reverse proxies' DMZ VLAN addresses (`192.168.140.250`, `192.168.140.251`, `2a02:8010:61d5:140::250`, `2a02:8010:61d5:140::251`) are allowed alongside their Servers VLAN addresses, so proxy-01/proxy-02 can move to the DMZ one at a time without losing access
- Host egress lockdown (`firewall/configure`, run by hand once and kept current by `updater-firewall-sync.timer`, separate from `./update`): firewalld policies limit what the host and the updater containers may connect to, with CDN-fronted destinations kept in ipsets refreshed every 10 minutes and GitHub/Cloudflare ranges refreshed daily by the new `Repo: Update egress ranges` workflow. Observation mode (log unmatched traffic, drop nothing) until `UPDATER_FIREWALL_ENFORCE=true`
### Added
### Fixed
- The host egress firewall is now one nftables table (`inet upd_egress`) loaded atomically by `firewall/egress`, instead of firewalld policies and ipsets: the 10-minute refresh reloaded firewalld, and a firewalld killed mid-reload (by the OOM killer) left its block-everything table in place and cut the host off. `firewall/configure` removes the old policies and ipsets with one last reload
- Fixed stale ssh key ownership on host-provisioned directories that blocked git clones after pinning the updater user's uid/gid
- optimise-git now reports failed git steps and exits non-zero, instead of reporting the optimisation as completed; the remaining repositories are still processed
- optimise-git no longer skips repositories whose paths merely contain the text cache; only repositories inside a .cache directory are excluded
- Updaters (dependencies, packages, templates and cleanup) now exit with an error when the tool update or the update pipeline fails, instead of carrying on as if they had succeeded; a failed tool install is ignored because it can fail when the tool is already installed
- Each updater now deletes its own temporary directory when it exits, so these directories no longer pile up on the persistent /local/work mount after every container restart (a SIGKILL before the exit runs can still leave one behind)
- Each updater (dependencies, packages, templates and cleanup) now runs optimise-git at the start of every cycle, before the update, so stale git locks are cleared before the update uses the repositories instead of making every later cycle fail; a failed optimise makes the updater exit with an error before the update runs. Cleanup clears locks on every cycle, but its working tree clean and weekly git steps still run only once a week, on its optimise day
- optimise-git no longer treats submodule and worktree checkouts, whose .git is a file, as repositories to optimise; only normal clones (with a .git directory) at most two levels below /local/work (owner/repo) are optimised, so bare and mirror repositories are not, and deeper nested .git directories are no longer found
- optimise-git no longer optimises leftover git repositories in the temporary directory /local/work/tmp, which were previously treated as work repositories and cleaned, pruned and garbage collected
- The weekly git optimisation no longer writes the previous ISO week to its marker when a run straddles midnight at the end of a week, which could make the weekly steps run a second time on the next cycle
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