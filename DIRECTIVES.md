# Development Directives

Rules that apply to every coding session on this project.

---

## No placeholder graphics — ever

When implementing any visual element, source real pixel art assets instead of using:
- Emoji characters as sprites
- Solid colored rectangles as stand-ins
- Unicode symbols as game objects

**Acceptable sources (free/CC0):**
- [Kenney.nl](https://kenney.nl/assets) — huge library, CC0, reliable
- [itch.io free assets](https://itch.io/game-assets/free) — filter by license
- [OpenGameArt.org](https://opengameart.org) — CC0/CC-BY
- [Lospec palette + asset packs](https://lospec.com)

**Before writing any UI or game screen:** find and download appropriate sprites first. Commit them to `assets/` with a `CREDITS.md` noting the source and license.

If a suitable free asset genuinely cannot be found, use a solid color rect with a clear `# TODO: replace with sprite` comment — never ship it, never screenshot it as progress.

---

## Asset pipeline

- All assets live in `assets/` with subdirectories by type (`assets/plants/`, `assets/ui/`, `assets/characters/`)
- Every asset batch gets a line in `assets/CREDITS.md`: filename, source URL, license
- Prefer spritesheets over individual files where possible
