# Brand asset generation. Runs in the .#brand dev shell (font + fonttools).

[doc("Regenerate the wordmark SVGs from the monospace font")]
[group("brand")]
brand-wordmark:
    nix develop .#brand --command python3 scripts/brand/wordmark.py
