import { defineConfig } from "vitepress";

const [owner, repoName] = (process.env.GITHUB_REPOSITORY ?? "adamsiwiec1/foss-template").split("/");
const repo = `https://github.com/${owner}/${repoName}`;
const base = `/${repoName}/`;

export default defineConfig({
  title: "FOSS Template",
  titleTemplate: ":title · FOSS Template",
  description:
    "Starter for a free and open source project: community health files, VitePress docs, and GitHub defaults.",
  lang: "en-US",
  base,
  cleanUrls: true,
  lastUpdated: true,
  ignoreDeadLinks: false,
  sitemap: {
    hostname: `https://${owner}.github.io/${repoName}/`,
  },

  themeConfig: {
    nav: [
      { text: "Guide", link: "/guide/", activeMatch: "/guide/" },
      { text: "Community", link: "/community/", activeMatch: "/community/" },
      { text: "Reference", link: "/reference/community-health", activeMatch: "/reference/" },
    ],

    sidebar: {
      "/guide/": [
        {
          text: "Getting started",
          items: [
            { text: "What this is", link: "/guide/" },
            { text: "Customize after a fork", link: "/guide/setup" },
            { text: "Write docs", link: "/guide/docs" },
          ],
        },
      ],
      "/community/": [
        {
          text: "Community",
          items: [
            { text: "How we work", link: "/community/" },
            { text: "Contributing", link: `${repo}/blob/main/CONTRIBUTING.md` },
            { text: "Code of conduct", link: `${repo}/blob/main/CODE_OF_CONDUCT.md` },
            { text: "Security policy", link: `${repo}/blob/main/SECURITY.md` },
            { text: "Support", link: `${repo}/blob/main/SUPPORT.md` },
            { text: "Governance", link: `${repo}/blob/main/GOVERNANCE.md` },
          ],
        },
      ],
      "/reference/": [
        {
          text: "Reference",
          items: [
            { text: "Community health files", link: "/reference/community-health" },
            { text: "Changelog", link: "/reference/changelog" },
          ],
        },
      ],
    },

    socialLinks: [{ icon: "github", link: repo }],

    editLink: {
      pattern: `${repo}/edit/main/docs/:path`,
      text: "Edit this page on GitHub",
    },

    search: { provider: "local" },

    footer: {
      message: "MIT licensed. Fork it, then make it yours.",
      copyright: "© INSERT_YEAR INSERT_OWNER",
    },
  },
});
