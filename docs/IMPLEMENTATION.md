# Implementation Plan — Wormwood

## Principles

- Build vertically: one complete slice (greenhouse → customer → night) before expanding
- Source pixel art assets before coding any visual screen
- Each phase ends with something playable, not just "systems done"
- No feature work until current phase is stable

---

## Phase 0 — Project Setup ✅ COMPLETE
*Goal: empty Godot project that runs, structured correctly, assets pipeline ready*

- [x] Godot 4 project init, repo connected
- [x] Folder structure: `scenes/`, `scripts/`, `assets/`, `data/`
- [x] `assets/CREDITS.md` started
- [x] Base resolution: 1280×720, canvas_items stretch, expand aspect, maximized
- [x] GameState autoload (day counter, inventory, resource dicts, story flags)
- [x] Scene manager (swap between phases cleanly)
- [x] Save/load system (Day, inventory, plant states, story flags)
- [x] Source core asset packs from OpenGameArt (CC0): parchment UI, plant sheet, potion icons

**Deliverable:** game launches, shows title screen, save/load works ✅

---

## Phase 1 — Day Loop Skeleton ✅ COMPLETE
*Goal: all four phases exist and transition correctly, no content yet*

- [x] Phase enum: MORNING / DAY / EVENING / NIGHT
- [x] Morning screen (greenhouse stub → now full minigame from Phase 2)
- [x] Day screen (empty shop counter, End Day button)
- [x] Evening screen (inventory display, End Evening button)
- [x] Night screen (rotating narrative stub text, Sleep button)
- [x] Day advances correctly, GameState updates
- [x] Basic HUD: day number, coin, ingredient count per screen

**Deliverable:** pressing through all four phases advances the day ✅

---

## Phase 2 — Greenhouse Minigame ✅ COMPLETE
*Goal: fully playable plant care, ingredients flow into inventory*

- [x] Source plant spritesheet — CC0, OpenGameArt (SpiderDave, 78 plants, 12×24px each)
- [x] Plant grid (6 plots) in 3×2 layout with PanelContainer cells
- [x] Plant data: species, growth_stage, water_level, health, days_in_stage, has_pest, has_blight
- [x] Actions: Water, Prune, Inspect (free), Harvest, Treat — max 5 per morning
- [x] Growth advances each day automatically via GameState._tick_plants()
- [x] Harvest yields ingredients into inventory, resets plant to mature
- [x] Pest/blight: random chance on mature/ready plants, spreads if untreated
- [x] Visual feedback: stage tinting (brown→green→gold→grey), water/health bars, pest badge
- [x] Starting plants: 3 plots pre-planted by grandma (thornroot, hearthbloom, wormwood)
- [x] Toast messages on every action
- [x] PlantData + RemedyData registered as autoloads

**Known issues / TODO:**
- [ ] Sprite indices for species (44, 8, 36, 62) are estimates — need visual check in-engine
- [ ] Empty plots have no "plant seed" UI yet (Phase 6)
- [ ] Seed shop stub (Voss — Phase 4)

**Plants implemented:** Thornroot (2-day stages), Hearthbloom (3-day), Wormwood (4-day), Moonleaf (5-day, locked)

**Deliverable:** player tends plants each morning, harvests ingredients, inventory fills up ✅

---

## Phase 3 — Customer + Diagnosis 🔲 NOT STARTED
*Goal: customers arrive, player diagnoses, no mixing yet — just correct/incorrect outcome*

- [ ] Source character portrait sprites (at least 3 distinct customers) — check OpenGameArt RPG portrait packs
- [ ] CustomerData.gd: name, portrait_id, ailment, symptoms[], dialogue lines per day
- [ ] Customer queue system: 3 per day, drawn from pool weighted by day number
- [ ] Dialogue UI: portrait left, speech text right, question choices below
- [ ] Symptom board UI: cork board style, pin symptoms as customer reveals them
- [ ] Diagnosis selection: player picks from known ailment list
- [ ] Outcome stub: correct → "remedy dispensed" + coin, wrong → customer leaves worse
- [ ] Relationship tracking per customer in GameState (hidden, affects future dialogue)
- [ ] Coin earned/lost on outcome, DayScene updated

**First 3 customers:**
- Lena (recurring, young woman, anxiety/insomnia, first appears day 1)
- Old Petre (forager, joint pain, narrative-heavy, day 2)
- Captain Brennan (headaches, first appearance day 3, unsettling)

**Deliverable:** 3 customers arrive per day, player diagnoses them, coins change, day ends

---

## Phase 4 — Remedy Mixing 🔲 NOT STARTED
*Goal: replace the diagnosis outcome stub with actual mixing minigame*

- [ ] Source ingredient icon sprites — use potion_32x32 already in assets/ui/
- [ ] Ingredient inventory UI (jars on shelf, click to select)
- [ ] Mixing interface: 3 ingredient slots + Combine button
- [ ] Recipe book UI: grandma's handwritten book, known recipes listed
- [ ] Balance/property indicator: soothing / stimulating / purgative shown visually
- [ ] Outcome logic: correct recipe → effective, wrong combo → side effects, empty slots → nothing
- [ ] Recipe discovery: unlock via journal pages and customer hints
- [ ] Ingredient consumed on use
- [ ] Trader Voss NPC: arrives every 3 days, sells ingredients for coin (simple shop panel)

**First recipes (already defined in RemedyData.gd):**
- Thornroot tea (thornroot_extract ×2) → fever, headache — unlocked day 1
- Hearthbloom tincture (hearthbloom_petals ×1) → anxiety, insomnia — unlocked day 1
- Wormwood draught (wormwood_leaf ×1 + thornroot_extract ×1) → stomach ailments — unlocked day 4 via journal

**Deliverable:** full customer loop — diagnose → mix → outcome → coin

---

## Phase 5 — Narrative Layer 🔲 NOT STARTED
*Goal: story exists, mystery begins, grandma feels present*

- [ ] Journal system: pages unlock on specific days, readable in EveningScene
- [ ] Object interaction: clickable items in EveningScene (desk, jars, locked door)
- [ ] Night event system: weighted pool, draw one per night, text + optional binary choice
- [ ] Story flag system already in GameState — wire it to events
- [ ] Grandma's presence: margin notes in recipe book, labeled jars, handwritten tags on plant plots
- [ ] Days 1–7 scripted: fixed events on days 1 (first journal), 3 (Brennan visit), 6 (locked door)
- [ ] Locked greenhouse door: interactable from day 6, opens day 14 with key item

**Deliverable:** player feels the mystery. Grandma feels real. First session has emotional weight.

---

## Phase 6 — Content Pass (Week 1) 🔲 NOT STARTED
*Goal: days 1–7 fully written, balanced, playable start to finish*

- [ ] All dialogue written for Lena, Petre, Brennan across 7 days
- [ ] 8 night events scripted (mix of atmospheric + plot-relevant)
- [ ] Resource balance tuned — enough ingredients to survive, not comfortable
- [ ] Moral weight: refusing Brennan vs. treating him — test it feels meaningful
- [ ] Plant propagation minigame (cutting timing mechanic)
- [ ] Plant identification minigame (reference book matching)
- [ ] Seed planting UI for empty plots
- [ ] Audio: ambient shop sounds + day/night music (source freesound CC0)

**Deliverable:** full first week playable, ~70 min content, narrative hook lands

---

## Phase 7 — Art Pass 🔲 NOT STARTED
*Goal: everything looks intentional, not placeholder*

- [ ] Background art for each screen: greenhouse, shop counter, back room, night
- [ ] All plant sprites confirmed and tuned (fix sprite index guesses from Phase 2)
- [ ] Character portraits final (multiple expressions each)
- [ ] UI skin: parchment texture panels, handwritten-style fonts, aged aesthetic
- [ ] Replace all remaining colored-rect placeholders
- [ ] Consistent lighting per phase (warm morning, amber day, dim evening, dark night)

---

## Phase 8 — Expansion + Endgame 🔲 NOT STARTED
*Goal: days 8–22 written, multiple endings implemented*

- [ ] Full story content: Brennan confrontation, Voss betrayal arc, compound completion
- [ ] 3 distinct endings implemented
- [ ] Reputation system consequences become visible
- [ ] Late-game resource pressure tuned
- [ ] New customer types introduced days 8+
- [ ] Moonleaf / locked greenhouse plot unlocks

---

## Phase 9 — Steam Release 🔲 NOT STARTED
*Goal: ship*

- [ ] Windows + Mac builds, test both
- [ ] Steam page: capsule art, screenshots, store description
- [ ] Achievements (5–10, story-gated)
- [ ] External playtesting (minimum 5 people)
- [ ] Trailer (60–90 sec, screen capture + music)
- [ ] Pricing research (comparable titles: Potion Craft ~$15, Strange Horticulture ~$13)
- [ ] Launch

---

## Estimated Phase Timeline

| Phase | Status | Estimated effort |
|-------|--------|-----------------|
| 0 — Setup | ✅ Done | 1 session |
| 1 — Day loop | ✅ Done | merged into Phase 0 |
| 2 — Greenhouse | ✅ Done | 1 session |
| 3 — Customer/diagnosis | 🔲 Next | 3–4 sessions |
| 4 — Mixing | 🔲 | 3–4 sessions |
| 5 — Narrative | 🔲 | 4–5 sessions |
| 6 — Content week 1 | 🔲 | 4–6 sessions |
| 7 — Art pass | 🔲 ongoing parallel | — |
| 8 — Expansion | 🔲 | 6–8 sessions |
| 9 — Steam | 🔲 | 2–3 sessions |

"Session" = one focused coding/writing block with Claude (~1–3 hours).
