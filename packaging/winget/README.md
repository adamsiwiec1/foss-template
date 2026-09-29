# winget

Windows Package Manager reads manifests from
[`microsoft/winget-pkgs`](https://github.com/microsoft/winget-pkgs). You do
**not** host the catalog yourself — you open a PR (or use a bot with `WINGET_PAT`).

Typical layout in the upstream repo:

```
manifests/i/INSERT_OWNER/INSERT_PROJECT/0.1.0/
  INSERT_OWNER.INSERT_PROJECT.yaml
  INSERT_OWNER.INSERT_PROJECT.installer.yaml
  INSERT_OWNER.INSERT_PROJECT.locale.en-US.yaml
```

Generate with [wingetcreate](https://github.com/microsoft/winget-create) against
your GitHub Release asset:

```bash
wingetcreate new https://github.com/INSERT_OWNER/INSERT_REPO/releases/download/v0.1.0/INSERT_REPO_0.1.0_windows_amd64.zip
```

Or adapt a small generator like OpenHat’s
[`runhug` packaging/winget](https://github.com/openhat-security/runhug/tree/main/packaging/winget).

Users (after merge):

```bash
winget install INSERT_OWNER.INSERT_PROJECT
```
