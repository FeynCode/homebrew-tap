# Tachyon Homebrew tap

Install [Tachyon](https://tachyon.feyncode.com) — a full-fledged terminal
coding agent — on macOS (Apple Silicon or Intel):

```bash
brew install feyncode/tap/tachyon
```

## What this repo contains

Only the Homebrew formula: download URLs and SHA-256 checksums. **No product
source.** Tachyon is proprietary software under the
[FeynCode EULA](https://tachyon.feyncode.com/eula); the binaries are prebuilt
and self-hosted at `https://tachyon.feyncode.com/releases/`.

- `Formula/tachyon.rb` — the live formula (rendered per release).
- `Formula/tachyon.rb.tmpl` — the template the release pipeline renders from.

## How releases update this formula

The formula ships a distinct URL + checksum for each macOS architecture, so
`brew bump-formula-pr` (which rewrites a single pair) does not fit. Instead the
release pipeline reads the published `tachyon-darwin-{arm64,x64}.sha256`
sidecars, fills the `version` and per-arch `sha256` placeholders in
`tachyon.rb.tmpl`, and commits the result to `Formula/tachyon.rb`.

## Notes

- The binaries are ad-hoc signed, so they run on Apple Silicon. Homebrew
  formulae do not apply the download quarantine flag, so no Gatekeeper prompt.
- Run `tachyon login` once after install to save a provider key.
