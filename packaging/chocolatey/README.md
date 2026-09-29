# Chocolatey

[Chocolatey](https://chocolatey.org/) installs from the community repository
(or a private feed). Your **app repo** holds the nuspec templates; a separate
[`chocolatey-packages`](https://github.com/adamsiwiec1/chocolatey-packages)
repo (example) keeps the package sources you `choco pack` / `choco push`.

```bash
# After filling INSERT_* and checksums:
choco pack packaging/chocolatey/INSERT_REPO.nuspec
choco push INSERT_REPO.0.1.0.nupkg --source https://push.chocolatey.org/ --api-key "$CHOCO_API_KEY"
```

Users:

```bash
choco install INSERT_REPO
```

Moderation on chocolatey.org can take time for first publish; keep the GitHub
Release binary as the fallback install path.
