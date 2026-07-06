# Docs site: Zig autodoc + mdBook, published to Cloudflare via wrangler.
# Runs in the .#docs dev shell (crypto backend env + mdbook + wrangler).

[doc("Build the docs site (Zig autodoc + mdBook) into book/")]
[group("docs")]
docs:
    nix develop .#docs --command sh -c 'zig build docs -p docs/site && mdbook build'

[doc("Build and serve the docs site locally")]
[group("docs")]
docs-serve: docs
    nix develop .#docs --command mdbook serve

[doc("Publish the docs site to Cloudflare (requires wrangler auth)")]
[group("docs")]
docs-publish: docs
    nix develop .#docs --command wrangler deploy
