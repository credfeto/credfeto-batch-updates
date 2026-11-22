# credfeto-batch-updates

Docker compose for updating repos

## Host firewall

`firewall/` locks the dev-upgrader host's egress down with firewalld policies, the same way as the DNS servers. It is separate from `./update`, which runs every five minutes to keep the updaters current and never touches the firewall.

| Policy              | Traffic                     | Allowed                                                                                                                                                                       |
|---------------------|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `upd-egress`        | host -> anywhere            | DNS to the fleet's DNS servers, NTP to the router, HTTPS to the proxies, journald uploads to monitoring, GitHub, ghcr.io, Docker Hub, Cloudflare, chaotic-aur, pkgstats, the Arch WKD, ICMP |
| `upd-egress-docker` | containers -> outside world | DNS, HTTPS to the proxies (the dev package caches), GitHub over SSH and HTTPS, ghcr.io, api.nuget.org, the .NET downloads, Cloudflare                                         |

Ingress needs nothing extra: the containers publish no ports, and SSH is left to the host's base configuration.

Set it up once, as root:

```sh
sudo firewall/configure
```

That installs two timers:

* `updater-egress-refresh.timer` (every 10 minutes) refreshes the firewalld ipsets for destinations without a stable address: names resolved from DNS, plus GitHub's and Cloudflare's published ranges (`firewall/github-egress-ranges` and `firewall/cloudflare-egress-ranges`).
* `updater-firewall-sync.timer` (every 15 minutes) re-runs `firewall/configure` when anything under `firewall/` changed since the commit it last applied. It does not pull; `./update` keeps the checkout current.

The `Repo: Update egress ranges` workflow regenerates the two range files daily and commits any change to main, refusing a list that has shrunk by more than a fifth, so new ranges reach the host within a day.

`UPDATER_FIREWALL_ENFORCE` in `.env` is the only switch. Unset or anything other than `true` is observation mode: every rule is in place, but traffic that matches none of them still flows and is logged with the prefix `upd-egress-unmatched:` or `upd-egress-docker-unmatched:` (rate-limited to 30 a minute). Run in observation mode first and check the journal for anything legitimate that is not covered:

```sh
sudo journalctl -k --since -1d | grep -E 'upd-egress(-docker)?-unmatched'
```

then set `UPDATER_FIREWALL_ENFORCE=true` and run `sudo firewall/configure` to drop everything else.
