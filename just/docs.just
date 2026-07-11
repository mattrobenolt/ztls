# Docs site: Zig autodoc + mdBook, published to Cloudflare via wrangler.
# Run these from inside `nix develop .#docs` (zig + mdbook + wrangler).

[doc("Build the docs site (Zig autodoc + mdBook) into book/")]
[group("docs")]
docs:
    zig build docs -p docs/site
    mdbook build

[doc("Build and serve the docs site locally")]
[group("docs")]
docs-serve: docs
    mdbook serve

[doc("Publish the docs site to Cloudflare (wrangler runs the build)")]
[group("docs")]
docs-publish:
    wrangler deploy

[doc("Remove generated docs site output (book/, docs/site/zig-docs/)")]
[group("docs")]
docs-clean:
    rm -rf book docs/site/zig-docs .wrangler
