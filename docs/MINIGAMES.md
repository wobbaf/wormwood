# Minigames — Wormwood

## 1. Greenhouse (Morning Phase)

A small grid of plant plots. Each plant has:
- **Growth stage** (seed → sprout → mature → harvest-ready → overripe → dead)
- **Water level** (bar, drains daily)
- **Health** (affected by pests, blight, neglect)
- **Yield** (higher care quality = more ingredients harvested)

### Actions (limited per morning)
- **Water** — fill water level, takes 1 action
- **Prune** — removes dead growth, improves yield, takes 1 action
- **Inspect** — reveals pest/blight early, free action
- **Treat blight** — costs a common ingredient, removes disease
- **Harvest** — collect ingredients from ready plants, takes 1 action

### Design notes
- 6–8 plots available, expands slightly as game progresses
- Grandma's locked plot unlocks mid-game — contains the special compound plants
- Some plants have long grow cycles (plan ahead), some fast (daily use)
- Morning actions are limited — you can't do everything, prioritize

---

## 2. Remedy Mixing (Day Phase)

When a customer needs treatment, a mixing interface opens.

- A **recipe book** shows known remedies (grandma's handwriting, margin notes)
- Player selects ingredients from inventory and combines them
- A **balance mechanic**: too much of one ingredient = side effects, too little = ineffective
- New recipes discovered through: customer hints, journal pages, experimentation

### Mixing interface
- 3–4 ingredient slots
- Each ingredient has properties (soothing, stimulating, purgative, etc.)
- A simple **compatibility indicator** (don't need perfect balance, but extremes have consequences)
- Time pressure is light — a few seconds of animation, not a reaction test

### Complexity scaling
- Early game: simple 2-ingredient remedies, clear recipes
- Mid game: 3-ingredient combos, some substitutions possible
- Late game: the compound (grandma's secret recipe) — complex, multi-step, high stakes

---

## 3. Diagnosis (Day Phase)

Before mixing, you need to know what's wrong.

Customer describes symptoms in dialogue. You ask follow-up questions (choose from 2–3 options). Based on answers, you identify the ailment from a visual **symptom board** — a cork board style UI where you pin clues.

- Match 2–3 symptoms → confident diagnosis → correct remedy
- Partial match → uncertain → you can guess or ask more (time cost)
- Wrong diagnosis → wrong remedy → customer gets worse, relationship damage

### Design notes
- Doubles as narrative delivery — questions reveal character backstory
- Some "ailments" are not physical (grief, fear, insomnia from stress) — remedy exists but isn't in the recipe book at first
- The guard captain's "headaches" are one such case

---

## 4. Plant Identification (occasional)

Some customers bring in plants they've found — asking what they are, if they're safe.

Simple minigame: a **reference book** (grandma's illustrated guide) and a plant specimen. Match visual features (leaf shape, color, markings) to the correct entry.

- Correct ID → helpful advice, sometimes reveals new ingredient source
- Wrong ID → could be harmless, could be dangerous depending on plant
- Some plants aren't in the book — Mara notes them, Voss or Petre may know

---

## 5. Propagation (occasional, greenhouse)

To grow more of a plant without buying seeds: take a cutting.

Simple timing minigame — a plant diagram, a moving indicator, click at the right moment to make a clean cut. Success = new seedling. Failure = damaged cutting, delayed growth.

Unlocked mid-game. Necessary for the compound plants (can't buy those seeds anywhere).
