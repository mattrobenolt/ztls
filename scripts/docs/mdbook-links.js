#!/usr/bin/env bun
// mdBook preprocessor: keep the docs site's internal navigation internal.
//
// The site chapters {{#include}} GitHub-native markdown (WHY/USAGE/SECURITY).
// Those files link cross-references as absolute GitHub URLs so they resolve from
// any location — on GitHub and in the book alike. This pass downgrades the few
// URLs that have an in-book chapter to the local page, so "see the guide" stays
// on the docs site instead of bouncing out to GitHub. Everything else (status
// dashboard, research docs, examples, issues) correctly stays pointed at GitHub.

const REPO = "https://github.com/mattrobenolt/ztls";

// absolute GitHub URL -> in-book chapter
const IN_BOOK = {
  [`${REPO}/blob/main/README.md`]: "introduction.md",
  [`${REPO}/blob/main/docs/USAGE.md`]: "guide.md",
  [`${REPO}/blob/main/docs/brand/WHY.md`]: "why.md",
  [`${REPO}/blob/main/SECURITY.md`]: "security.md",
};

function rewriteTarget(target) {
  const hash = target.indexOf("#");
  const base = hash === -1 ? target : target.slice(0, hash);
  const anchor = hash === -1 ? "" : target.slice(hash);
  return base in IN_BOOK ? IN_BOOK[base] + anchor : target;
}

function rewriteContent(md) {
  return md.replace(
    /\]\((\S+?)(\s+"[^"]*")?\)/g,
    (_m, target, title) => `](${rewriteTarget(target)}${title || ""})`,
  );
}

function walk(items) {
  for (const item of items) {
    if (item && item.Chapter) {
      const ch = item.Chapter;
      if (typeof ch.content === "string") ch.content = rewriteContent(ch.content);
      if (Array.isArray(ch.sub_items)) walk(ch.sub_items);
    }
  }
}

if (process.argv[2] === "supports") process.exit(0);

try {
  const [, book] = JSON.parse(await Bun.stdin.text());
  walk(book.items ?? book.sections ?? []);
  process.stdout.write(JSON.stringify(book));
} catch (e) {
  process.stderr.write(`ztls-links: ${e && e.stack ? e.stack : e}\n`);
  process.exit(1);
}
