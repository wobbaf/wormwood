# Implementation Plan — Wormwood

## Principles

- Build vertically: one complete slice (greenhouse → customer → night) before expanding
- Source pixel art assets before coding any visual screen
- Each phase ends with something playable, not just "systems done"
- No feature work until current phase is stable

---

## Phase 0 — Project Setup
*Goal: empty Godot project that runs, structured correctly, assets pipeline ready*

- [ ] Godot 4 project init, repo connected
- [ ] Folder structure: `scenes/`, `scripts/`, `assets/`, `data/`
- [ ] `assets/CREDITS.md` started
- [ ] Base resolution: 1280×720, canvas_items stretch, expand aspect
- [ ] GameState autoload (day counter, inventory, resource dicts, story flags)
- [ ] Scene manager (swap between phases cleanly)
- [ ] Save/load system (Day, inventory, plant states, story flags)
- [ ] Source core asset packs (UI, plants, characters) from Kenney / OpenGameArt before any visuals

**Deliverable:** game launches, shows a placeholder day counter, save/load works

---

## Phase 1 — Day Loop Skeleton
*Goal: all four phases exist and transition correctly, no content yet*

- [ ] Phase enum: MORNING / DAY / EVENING / NIGHT
- [ ] Morning screen (empty greenhouse grid, End Morning button)
- [ ] Day screen (empty shop counter, End Day button)
- [ ] Evening screen (inventory display, End Evening button)
- [ ] Night screen (text box, Continue button)
- [ ] Day advances correctly, GameState updates
- [ ] Basic HUD: day number, coin, ingredient count

**Deliverable:** pressing through all four phases advances the day. No content, but the loop is real.

---

## Phase 2 — Greenhouse Minigame
*Goal: fully playable plant care, ingredients flow into inventory*

- [ ] Source plant spritesheet (growth stages: seed/sprout/mature/harvest/dead)
- [ ] Plant grid (6 plots), each cell holds a plant object
- [ ] Plant data: species, growth_stage, water_level, health, days_to_next_stage
- [ ] Actions: Water, Prune, Inspect, Harvest (limited per morning — max 5 actions)
- [ ] Growth advances each day automatically
- [ ] Harvest yields ingredients into GameState inventory
- [ ] Blight/pest event (random, spreads if untreated)
- [ ] Visual feedback: wilting sprite at low water, pest particle, harvest animation
- [ ] Starting plants: 3 plots pre-planted (grandma left them)
- [ ] Seed shop (buy from Voss or trader NPC — Phase 4 full impl, stub for now)

**Plants to implement first:**
- Thornroot (3-day grow cycle, common remedy base)
- Hearthbloom (5-day cycle, calming)
- Wormwood (7-day cycle, bitter, important late game)

**Deliverable:** player tends plants each morning, harvests ingredients, inventory fills up

---

## Phase 3 — Customer + Diagnosis
*Goal: customers arrive, player diagnoses, no mixing yet — just correct/incorrect outcome*

- [ ] Source character portrait sprites (at least 3 distinct customers)
- [ ] Customer data structure: name, portrait, ailment, symptoms[], dialogue[]
- [ ] Customer queue: 3 per day, drawn from pool weighted by day number
- [ ] Dialogue UI: portrait left, text right, question choices below
- [ ] Symptom board UI: cork board, pin symptoms as customer reveals them
- [ ] Diagnosis selection: player picks ailment from known list
- [ ] Outcome stub: correct diagnosis → "remedy dispensed" (no mixing yet), wrong → customer leaves worse
- [ ] Relationship tracking per customer (hidden, affects future dialogue)
- [ ] Coin earned/lost on outcome

**First 3 customers:**
- Lena (recurring, young woman, anxiety/insomnia)
- Old Petre (forager, joint pain, narrative-heavy)
- Captain Brennan (headaches, first appearance day 3)

**Deliverable:** 3 customers arrive, player diagnoses them, coins change, day ends

---

## Phase 4 — Remedy Mixing
*Goal: replace the outcome stub with actual mixing minigame*

- [ ] Source ingredient sprites (small icons for each plant extract/preparation)
- [ ] Ingredient inventory UI (jars/pouches on shelf, click to select)
- [ ] Mixing interface: 3 ingredient slots, combine button
- [ ] Recipe book UI: grandma's illustrated book, known recipes listed
- [ ] Balance indicator: properties sum (soothing/stimulating/purgative) shown visually
- [ ] Outcome logic: correct recipe → effective, wrong combo → side effects, empty → nothing
- [ ] Recipe discovery: new recipes unlock from journal pages and customer hints
- [ ] Ingredient consumption on use
- [ ] Trader Voss: can buy ingredients for coin (simple shop UI, arrives every 3 days)

**First recipes:**
- Thornroot tea (thornroot × 2) → fever
- Hearthbloom tincture (hearthbloom × 1 + water) → anxiety/insomnia
- Wormwood draught (wormwood × 1 + thornroot × 1) → stomach ailments

**Deliverable:** full customer loop works — diagnose → mix → outcome → coin

---

## Phase 5 — Narrative Layer
*Goal: story exists, mystery begins, grandma feels present*

- [ ] Journal system: pages unlock on specific days, display in back room
- [ ] Object interaction: clickable items in evening screen (desk, shelves, locked door)
- [ ] Night event system: weighted pool, draw one per night, display as text + optional choice
- [ ] Story flag system in GameState (tracks what player knows)
- [ ] Grandma's presence: margin notes in recipe book, labeled jars, handwritten tags
- [ ] Days 1–7 scripted: fixed events on days 1, 3, 6 (Brennan visit, Voss intro, first journal page)
- [ ] Locked greenhouse door: interactable from day 6, opens day 14 with correct key item

**Deliverable:** player feels the mystery. First session has emotional weight.

---

## Phase 6 — Content Pass (Week 1 complete)
*Goal: days 1–7 are fully written, balanced, and playable start to finish*

- [ ] All dialogue written for 3 core characters across 7 days
- [ ] 8 night events scripted (mix of atmospheric + plot-relevant)
- [ ] Resource balance tuned (enough ingredients to survive, not to be comfortable)
- [ ] Moral weight tested: refusing Brennan vs. treating him — does it feel meaningful?
- [ ] Plant propagation minigame (cutting timing mechanic)
- [ ] Plant identification minigame (reference book matching)
- [ ] Audio: ambient shop sounds, simple day/night music loop (source from freesound/CC)

**Deliverable:** full first week playable, ~70 minutes of content, narrative hook lands

---

## Phase 7 — Art Pass
*Goal: everything looks intentional*

- [ ] Background paintings / illustrated scenes for each screen (commission or AI-assisted base + hand edit)
- [ ] All plant sprites final quality
- [ ] Character portraits final (multiple expressions each)
- [ ] UI skin: parchment texture, handwritten fonts, aged aesthetic
- [ ] Replace all temp assets, remove all TODO placeholders
- [ ] Consistent lighting per time-of-day phase

---

## Phase 8 — Expansion + Endgame
*Goal: days 8–22 written, multiple endings implemented*

- [ ] Full story content (Brennan confrontation, Voss betrayal arc, compound completion)
- [ ] 3 distinct endings implemented
- [ ] Reputation system consequences visible
- [ ] Late-game resource pressure tuned
- [ ] New customer types (days 8+)

---

## Phase 9 — Steam Release
*Goal: ship*

- [ ] Windows + Mac builds
- [ ] Steam page: capsule art, screenshots, description
- [ ] Achievements (5–10, story-gated)
- [ ] Playtesting (external, minimum 5 people)
- [ ] Trailer (screen capture + music, 60–90 sec)
- [ ] Pricing research (comparable titles)
- [ ] Launch

---

## Estimated Phase Timeline

| Phase | Estimated effort |
|-------|-----------------|
| 0 — Setup | 1 session |
| 1 — Day loop | 1–2 sessions |
| 2 — Greenhouse | 3–4 sessions |
| 3 — Customer/diagnosis | 3–4 sessions |
| 4 — Mixing | 3–4 sessions |
| 5 — Narrative | 4–5 sessions |
| 6 — Content week 1 | 4–6 sessions |
| 7 — Art pass | ongoing, parallel |
| 8 — Expansion | 6–8 sessions |
| 9 — Steam | 2–3 sessions |

"Session" = one focused coding/writing block with Claude (~1–3 hours).
