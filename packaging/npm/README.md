# Optional npm wrapper

Some CLIs publish an npm package whose `postinstall` downloads the matching
GitHub Release binary (see OpenHat
[runhug/packaging/npm](https://github.com/openhat-security/runhug/tree/main/packaging/npm)).

Useful when your audience already has Node. Not a substitute for brew/apt/scoop —
those users rarely want an npm global for a native binary.

Requires `NPM_TOKEN` on the release workflow.
