# 🌸 BLOOM — Game Project

## Concept
Mobile first puzzle game. Tap to plant seeds on a grid. Plants grow and cover cells. Goal: cover EXACTLY 100% of the grid.

## Core Mechanic
1. Tap cells to plant seeds
2. Press GROW — all seeds grow simultaneously (Flower=circle, Bush=square, Star=star, Cactus=elongated)
3. Result: percentage shown
   - 100% exact = ⭐⭐⭐ PERFECT
   - 90-99% = 1-2 stars
   - >100% = overgrow (fail)
   - <90% = undergrow (fail)

## Grid Elements
- 🪨 Rock = blocked cell
- 💧 Water = changes plant shape behavior
- 🌿 Weed = must be covered

## Progression
- Levels 1-100 campaign
- Grid sizes: 3x3 → 7x7
- Moves-limited challenges
- Obstacles introduced at level 20+
- 5 Biomes (themes): Meadow, Desert, Ocean, Space, Winter

## Stars
- ⭐ = Level complete (≥90%)
- ⭐⭐ = < 75% of max moves used
- ⭐⭐⭐ = Exactly 1 seed used (overlap trick)

## Monetization (Cosmetic Only)
- Season Themes (€1-3)
- Plant Color Styles (€0.50-1)
- Particle Packs (€0.50-1)
- Grid Skins (€1-2)
- No Ads Pass (€2.99)

## UI Kit
See: ui-kit.png

## Tech
- Godot 4
- Export: iOS + Android
