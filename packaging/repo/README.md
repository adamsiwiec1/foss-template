# apt + dnf via GitHub Pages

Linux package managers need an HTTP repository (pool + metadata), not a single
GitHub Release asset. Host that tree in a dedicated **`OWNER/packages`** repo
and enable GitHub Pages.

1. Build `.deb` / `.rpm` in your release CI (GoReleaser `nfpms`, fpm, …).
2. Run [`build-pages-repos.sh`](build-pages-repos.sh) into an output dir.
3. Push that tree to `OWNER/packages` (`gh-pages` or `main`).
4. Users run `install-apt.sh` / `install-dnf.sh`.

Example Pages site pattern: [adamsiwiec1/packages](https://github.com/adamsiwiec1/packages)
(and production [openhat-security/packages](https://github.com/openhat-security/packages)).
