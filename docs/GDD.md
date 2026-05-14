# Game Design Document — Wormwood

## Concept

You are Mara (placeholder), granddaughter of a renowned apothecary who died under suspicious circumstances. You arrive to settle the estate, intend to sell the shop — and find yourself unable to leave until you know the truth.

The shop is your survival mechanism and your investigation tool. Customers who knew your grandmother talk. Plants she kept locked away hold clues. Her coded notes are hidden in plain sight.

---

## Core Loops

### Survival Loop (daily)
```
Tend plants → harvest ingredients → mix remedies → serve customers → earn coin → buy supplies
```

### Mystery Loop (across days)
```
Customers hint → find notes/objects → unlock locked areas → piece together what grandma knew → confront it
```

---

## Day Structure (~10 min)

| Phase | Duration | Description |
|-------|----------|-------------|
| Morning | ~2 min | Greenhouse minigame — water, prune, harvest |
| Day | ~5 min | 3–4 customers, diagnose + mix + moral choice |
| Evening | ~2 min | Resource management, narrative beat |
| Night | ~1 min | Event (letter, visitor, dream, discovery) |

---

## Resource System

**Ingredients** — sourced three ways:
- Your greenhouse (slow, renewable, free)
- Black market trader Voss (fast, costly, morally suspect)
- Foragers who barter (story-rich, unreliable supply)

**Coin** — earned from customers, spent on seeds, supplies, bribes, trader

**Condition** — plants have health; neglect during busy weeks = blight

**Reputation** — hidden stat. Customers talk. Treat the wrong people poorly and word spreads. Treat the right people well and doors open.

---

## Moral System

No alignment meter. No good/evil score. Just consequences.

Each customer interaction ends with a choice:
- **Treat** — spend ingredients, earn coin, relationship +
- **Refuse** — save ingredients, relationship -, they may get worse
- **Overcharge** — earn more coin, relationship -, they remember
- **Treat for free** — spend ingredients, no coin, reputation +, they owe you

Some customers are agents of the regime. Treating them funds oppression. Some customers are people the regime wants dead. Refusing them means they suffer. The game never tells you which is which at first.

---

## Progression

**Days 1–3:** Tutorial. Learn the shop, meet recurring customers, find grandma's journal (first page only).  
**Days 4–7:** Strange requests begin. A customer asks for something that isn't a remedy. Grandma's locked greenhouse door.  
**Days 8–14:** The trader Voss reveals he knew grandma. The guard captain starts watching the shop.  
**Days 15–21:** Journal pages unlock. The picture forms. A choice approaches.  
**Day 22+:** Endgame. What grandma knew, what she was building toward, what you do with it.

---

## Win / Lose States

No traditional fail state. But:
- Run out of coin for 3 consecutive days → forced to sell something precious
- Reputation bottoms out → key customers stop coming, story branch closes
- Ignore the mystery too long → someone else acts on what grandma knew, ending changes

Multiple endings based on accumulated choices, not a final decision branch.
