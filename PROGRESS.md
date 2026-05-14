# Progress Log — Wormwood

Running log of every session. Most recent first.

---

## Session 3 — 2026-05-14
**Phase 2: Greenhouse Minigame**

### Done
- Rewrote `MorningScene.gd` as full interactive greenhouse
- 6 plots in 3×2 grid, each shows plant sprite from CC0 sheet (SpiderDave, OGA)
- Plant sprites: `AtlasTexture` slices from 936×24 spritesheet (78 plants, 12×24px each)
- Growth stage tinting: seed=brown, sprout=bright green, mature=deep green, ready=gold, overripe=dull gold, dead=grey
- Water bar + health bar per plot using anchor-based ColorRect fills
- Pest/blight warning badge shown inline
- Click plot → right panel shows species name, description, exact water%, health%, days in stage
- 5 actions per morning: Water (+55% water), Prune (+15% health), Inspect (free, no cost), Harvest (yields to inventory), Treat (clears pest/blight)
- Action buttons auto-disable when not applicable (e.g. Harvest only when stage=3)
- Toast messages on every action with 2s fade-out
- "Open the Shop" button advances to Day phase + saves
- `PlantData` and `RemedyData` promoted to autoloads in `project.godot`
- `PlantData.gd`: 4 species (thornroot, hearthbloom, wormwood, moonleaf) with grow cycles, yields, descriptions
- `RemedyData.gd`: 4 recipes, 7 ailment definitions, helper functions

### Known issues
- Sprite indices (44, 8, 36, 62) are visual guesses — need checking in-engine
- Empty plot cells have no "plant a seed" interaction yet
- `_show_toast` accesses `CanvasLayer` by class type scan — fragile if scene structure changes

### Files changed
- `scripts/MorningScene.gd` — full rewrite
- `scripts/PlantData.gd` — added, promoted to autoload
- `scripts/RemedyData.gd` — added, promoted to autoload
- `project.godot` — added PlantData + RemedyData autoloads

---

## Session 2 — 2026-05-14
**Phase 0 + Phase 1: Project Setup + Day Loop**

### Done
- Godot 4.6 project created at `/Users/wobbaf/wormwood`
- Repo: `github.com/wobbaf/wormwood`
- Folder structure: `scenes/`, `scripts/`, `assets/`, `docs/`
- `project.godot`: 1280×720, canvas_items + expand, maximized, GL Compatibility
- `GameState.gd`: day, phase, coin, inventory, plant_states, story_flags, reputation, known_recipes, journal_pages — save/load to `user://savegame.dat` via JSON
- `SceneManager.gd`: scene name → .tscn path map, `go_to()` + `go_to_phase()`, clean swap
- `Main.gd`: title screen with Begin/Continue, routes to correct phase on load
- All 4 phase scenes created as stubs: Morning, Day, Evening, Night
- Night scene: 4 rotating placeholder narrative texts
- Assets downloaded (all CC0):
  - `assets/ui/`: parchment buttons, panels, labels, slots (zwonky, OGA)
  - `assets/ui/potions_32x32/`: 5 potion icons (Buch/AntumDeluge, OGA)
  - `assets/plants/plants_sheet.png`: 78 pixel plants (SpiderDave, OGA)
  - `assets/CREDITS.md`: source + license for every asset

### Files created
- `project.godot`, `scripts/GameState.gd`, `scripts/SceneManager.gd`, `scripts/Main.gd`
- `scripts/MorningScene.gd`, `scripts/DayScene.gd`, `scripts/EveningScene.gd`, `scripts/NightScene.gd`
- `scenes/Main.tscn`, `scenes/MorningScene.tscn`, `scenes/DayScene.tscn`, `scenes/EveningScene.tscn`, `scenes/NightScene.tscn`
- `scripts/PlantData.gd`, `scripts/RemedyData.gd` (data layer)
- `.gitignore`

---

## Session 1 — 2026-05-14
**Design + Planning**

### Done
- Game concept finalised: apothecary mystery, grandma's death, occupied city, ~10 min sessions
- Working title: **Wormwood**
- Confirmed no direct competitor with this specific combo (Potion Craft = cozy/no narrative, Strange Horticulture = no minigames/resource loop)
- GitHub repo created: `github.com/wobbaf/wormwood`
- Design docs written and committed:
  - `docs/GDD.md` — mechanics, moral system, progression arc, win/lose states
  - `docs/NARRATIVE.md` — Mara, Elsa's secret (regime collaborator network), all 5 characters, world tone
  - `docs/MINIGAMES.md` — 5 minigames designed: greenhouse, mixing, diagnosis, plant ID, propagation
  - `docs/DAY_LOOP.md` — 4-phase day structure, timing, forced event days
  - `docs/ART.md` — palette, visual references (Disco Elysium, Spiritfarer), per-screen feel
  - `docs/IMPLEMENTATION.md` — 9 phases, tasks, timeline
  - `DIRECTIVES.md` — no placeholder graphics rule, asset sourcing guidelines

---

## What's Next

### Immediate (Phase 3)
1. Find CC0 character portrait sprites (RPG portrait pack on OGA or similar)
2. Build `CustomerData.gd` with Lena, Petre, Brennan dialogue + symptom data
3. Rewrite `DayScene.gd` as full customer interaction loop:
   - Customer arrives with portrait + intro text
   - Player asks follow-up questions
   - Symptom board populates
   - Player selects diagnosis
   - Outcome: correct = coin earned, wrong = customer worsens
4. Wire relationship tracking to GameState.reputation

### Soon (Phase 4)
- Mixing minigame replaces the outcome stub
- Trader Voss NPC (buy ingredients)
- Recipe book UI

### Backlog
- Seed planting for empty plots
- Fix sprite index guesses (visual tuning in-engine)
- Narrative layer (Phase 5)
- Audio pass (Phase 6)

---

## Bugs / Issues Tracking

| ID | Description | Severity | Status |
|----|-------------|----------|--------|
| B01 | Greenhouse sprite indices are guesses (44, 8, 36, 62) — may show wrong plants | Low | Open |
| B02 | `_show_toast()` scans for CanvasLayer by type — fragile | Low | Open |
| B03 | Empty plots have no seed-planting UI | Medium | Deferred to Phase 6 |
| B04 | DayScene / EveningScene are still stubs with no real content | High | Phase 3 next |
