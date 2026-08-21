# Write docs

Docs are VitePress, following the
[official getting started](https://vitepress.dev/guide/getting-started) layout:
Markdown under `docs/`, config in `docs/.vitepress/config.ts`.

| Directory | Use it for |
| --- | --- |
| `docs/guide/` | Tasks. Install, customize, how to do a thing. |
| `docs/reference/` | Lasting facts. File lists, policy, changelog. |
| `docs/community/` | Pointers to the root community files. |

OnionGate keeps GitHub-conventional files at the repo root and treats
`docs/guide/` vs `docs/reference/` the same way. Update docs in the same pull
request as the behavior they describe.

```bash
npm run docs:dev      # http://localhost:5173/<repo>/
npm run docs:build    # fails on broken internal links
npm run docs:preview
```

`make docs` and `make docs-build` wrap the same scripts.

When you add a page, add it to the sidebar in `docs/.vitepress/config.ts`.
Set `ignoreDeadLinks: false` stays on so CI catches stale links.

Deploy uses the [official GitHub Pages workflow](https://vitepress.dev/guide/deploy#github-pages)
in `.github/workflows/docs.yml`.
