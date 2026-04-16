# 🌸 BLOOM — Game Design Document (GDD)

**Version:** 1.0  
**Status:** Ready for Development  
**Engine:** Godot 4  
**Platforms:** iOS, Android  
**Orientation:** Portrait (mobile-first)

---

## 1. VISION & PITCH

### One-Liner
> "A zen puzzle game where you plant seeds and watch them grow — but you need exactly 100% coverage to win."

### Elevator Pitch
Bloom is a meditative yet strategic puzzle game that anyone can learn in seconds but takes months to master. The core loop is beautifully simple: tap to plant, watch them grow, hit exactly 100%. It's the satisfaction of a perfect fill combined with the calming nature of watching things bloom. No time pressure, no enemies, no frustration — just you, a grid, and the pursuit of botanical perfection.

### Visual Identity
- **Aesthetic:** Cottagecore meets modern minimalism — hand-crafted, tactile, warm
- **Mood:** Peaceful, cozy, satisfying, meditative
- **Reference:** Studio Ghibli color palette, Monument Valley simplicity
- **Feel:** Every tap should feel intentional; every growth animation should be satisfying

---

## 2. CORE MECHANIC

### The Golden Rule
> **Cover EXACTLY 100% of the grid. Not more, not less.**

### The Four Phases

#### PHASE 1: PLANT
- Player sees an empty grid (3x3 to 7x7 depending on level)
- Player taps cells to place seeds
- Each seed placement costs 1 "move" (limited per level)
- Seeds cannot be removed once placed
- Player taps "GROW" button when ready (or auto-triggers after last move)

#### PHASE 2: GROW
- All planted seeds grow simultaneously (2-3 second animation)
- Each plant type has a unique growth shape (see Plant Types below)
- Plants can overlap — this is intentional and often necessary
- Growth animation: seed → sprout → full plant (satisfying progression)

#### PHASE 3: RESULT
- Coverage percentage calculated and displayed
- **100% exact** → "PERFECT!" → ⭐⭐⭐ + Level Complete
- **90-99%** → Level Complete with 1-2 stars
- **>100%** → "Overgrown!" → Level Failed
- **<90%** → "Not enough!" → Level Failed

#### PHASE 4: RESOLVE
- **Failed:** Tap "Retry" — grid resets, try again (free, unlimited)
- **Passed:** Tap "Next" → unlock next level
- 3-star completion unlocks bonus content (new plant types, biomes)

---

## 3. PLANT TYPES

### Default Plants (Available from start)

| Plant | Shape | Coverage | Visual |
|-------|-------|----------|--------|
| 🌼 **Flower** | Circle | 5 cells | Pink petals, yellow center |
| 🌿 **Bush** | Square | 9 cells | Green leafy mound |
| ⭐ **Star** | Star/Diamond | 13 cells | Golden star with glow |
| 🌵 **Cactus** | Elongated rectangle | 7 cells | Green spiky column |

### Plant Behavior by Terrain

| Terrain | Effect on Plant |
|---------|-----------------|
| Grass (default) | Normal shape |
| 💧 Water | Circle becomes Square; Square becomes smaller Square |
| 🪨 Rock | Plant grows AROUND rock (doesn't cover it) |
| 🌿 Weed | Must be covered by a plant (counts as covered) |

### Unlock Order
- Level 1-5: Flower only
- Level 6: Bush unlocked
- Level 15: Star unlocked
- Level 25: Cactus unlocked

---

## 4. GRID ELEMENTS

### Base Terrain

| Element | Behavior | First Appears |
|---------|----------|---------------|
| Grass | Default terrain, normal plant growth | Level 1 |
| 💧 Water | Changes plant shape (circle→square) | Level 20 |
| 🪨 Rock | Blocked cell, counts toward grid but cannot be planted on | Level 20 |
| 🌿 Weed | Must be covered by plant overlap | Level 30 |
| ⏸️ Void | Does NOT count toward coverage (ignore) | Level 40 |

### Grid Sizes by Level

| Levels | Grid | Total Cells |
|--------|------|-------------|
| 1-10 | 3x3 | 9 |
| 11-25 | 4x4 | 16 |
| 26-50 | 5x5 | 25 |
| 51-75 | 6x6 | 36 |
| 76-100 | 7x7 | 49 |

---

## 5. LEVEL DESIGN

### Level Types

| Type | Description | First Appears | Special Rule |
|------|-------------|---------------|--------------|
| **Classic** | Standard coverage puzzle | Level 1 | Cover 100% |
| **Moves Limited** | Maximum X seeds allowed | Level 6 | Use ≤ X seeds |
| **Plant Restricted** | Only one plant type allowed | Level 10 | Use only designated plant |
| **Obstacle** | Rocks/water on grid | Level 20 | Navigate terrain |
| **Timed** | Complete within Y seconds | Level 35 | Time pressure |
| **Perfect Only** | No 1-2 star option | Level 50 | 100% or fail |
| **Speed Run** | Lowest moves wins | Level 60 | Compare to leaderboard |

### Difficulty Curve

```
Levels 1-5:   Tutorial — 3x3, 1 plant type, generous moves
Levels 6-15:  Easy — 4x4, 2 plant types, normal moves
Levels 16-30: Medium — 4x4/5x5, all plants, limited moves
Levels 31-50: Hard — 5x5, obstacles, timed elements
Levels 51-75: Harder — 6x6, complex obstacle patterns
Levels 76-100: Expert — 7x7, all mechanics combined
```

### Level Data Structure

```gdscript
# Example Level Data (JSON)
{
  "id": 23,
  "grid_size": 5,
  "max_moves": 4,
  "available_plants": ["flower", "bush"],
  "obstacles": [
    {"type": "rock", "x": 2, "y": 2},
    {"type": "water", "x": 0, "y": 4}
  ],
  "target_percentage": 100,
  "time_limit": null,
  "biome": "meadow"
}
```

---

## 6. PROGRESSION SYSTEM

### Star Requirements

| Stars | Requirement |
|-------|-------------|
| ⭐ | Complete level (≥90% coverage) |
| ⭐⭐ | Complete with ≤75% of max moves used |
| ⭐⭐⭐ | Complete using exactly 1 seed (overlap trick) |

### Star Rewards
- 1 star minimum to unlock next level
- 3 stars to unlock: new plant types, biomes, achievements

### Level Unlock Tree
```
1 → 2 → 3 → ... → 100
 ├── (3 stars on 5: unlock Bush)
 ├── (3 stars on 15: unlock Star)
 └── (3 stars on 25: unlock Cactus)
```

### Endless Mode (Post-Level 100)
- Procedurally generated levels
- Infinite difficulty scaling
- Weekly challenge with global leaderboard
- Daily mini-puzzle

---

## 7. BIOMES (Themes)

Biomes are purely cosmetic (no gameplay change).

| Biome | Levels | Theme | Colors |
|-------|--------|-------|--------|
| 🌻 **Meadow** | 1-20 | Default, grassy field | Soft greens, warm whites |
| 🏜️ **Desert** | 21-40 | Sandy dunes, cacti | Oranges, browns, dusty pinks |
| 🌊 **Ocean** | 41-60 | Underwater reef | Blues, teals, coral pinks |
| 🌌 **Space** | 61-80 | Cosmic garden | Deep purple, glowing neon |
| ❄️ **Winter** | 81-100 | Frozen garden | Whites, ice blues, silver |

### Unlock Condition
- Complete all levels in previous biome with at least 1 star
- Example: Beat levels 1-20 → Meadow complete → Desert unlocked

---

## 8. MONETIZATION (Cosmetic Only)

### Core Principle
> **NO gameplay advantage through purchases. Ever.**

### In-App Purchase Items

| Category | Item | Price | Effect |
|----------|------|-------|--------|
| **Themes** | Meadow Theme | Free (default) | — |
| | Desert Theme | €1.99 | Desert visuals + sound pack |
| | Ocean Theme | €1.99 | Underwater visuals + sound |
| | Space Theme | €2.49 | Cosmic visuals + ambient sounds |
| | Winter Theme | €2.49 | Snowy visuals + crackling fire sounds |
| **Plant Colors** | Sunset Pack | €0.99 | Warm orange/pink plant palette |
| | Forest Pack | €0.99 | Deep green/earth tones |
| | Royal Pack | €0.99 | Purple/gold premium palette |
| | Rainbow Pack | €1.49 | Vibrant multicolor plants |
| **Particles** | Butterflies | €0.99 | Animated butterflies on success |
| | Fireflies | €0.99 | Glowing firefly ambient effect |
| | Petals | €0.99 | Falling flower petals |
| | Sparkles | €0.49 | Glitter burst on level complete |
| **Grid Skins** | Classic Grass | Free (default) | — |
| | Wooden Tiles | €1.99 | Wood grain texture |
| | Marble | €2.49 | Polished marble grid |
| | Hex Pattern | €1.99 | Honeycomb instead of squares |
| | Cobblestone | €1.99 | Stone road texture |
| **No Ads** | Ad-Free Forever | €2.99 | Removes all banner/interstitial ads |

### Revenue Model
- Free to play with ads
- Optional cosmetic IAP
- No energy systems, no timers, no gameplay shortcuts

---

## 9. TUTORIAL FLOW (First-Time User Experience)

### Onboarding Steps

**Step 1: Welcome Screen**
- Animated Bloom logo
- "Tap to Start" prompt
- 3-second auto-advance or tap to skip

**Step 2: Level 1 (Built-in Tutorial)**
- Grid: 3x3
- Available: Flower only
- Max moves: 3
- Instruction banner: "Tap a cell to plant a seed"
- Player taps one cell
- Instruction: "Now tap GROW"
- Auto-growth animation
- Result: ~55% coverage (fail expected)
- Message: "Almost! Try placing seeds closer together"
- Player retries

**Step 3: Level 1 Retry**
- Hint system activates
- Subtle glow on optimal cell
- Player places 2 flowers with overlap
- Success: "PERFECT! 100%!"
- Confetti animation + 3 stars
- Message: "You got 3 stars! Try to beat each level perfectly!"

**Step 4: Level 2**
- 3x3 grid
- Instruction: "You have 2 moves. Plan carefully!"
- Player solves
- Continue until level 5 (tutorial ends)

**Step 5: End of Tutorial**
- Summary screen: "You're ready for Bloom!"
- Show: Level Select, Settings, Shop icons
- Prompt to enable notifications (optional)

---

## 10. UI/UX DESIGN

### Screen Flow

```
Splash → Logo → [NEW] Tutorial → Main Menu
                            ↓
                    Level Select
                            ↓
                  [Level 1-N] → Pause → Retry/Home
                            ↓
                       Results → Next Level

Main Menu also accesses:
  ├── Shop
  ├── Settings
  ├── Daily Challenge
  └── Achievements
```

### UI Kit Reference
See: `ui-kit.png` for visual reference

### Color Palette (from UI Kit)

| Element | Color | Hex |
|---------|-------|-----|
| Background | Cream/Beige | #F5F0E6 |
| Primary Action | Soft Green | #7CB87C |
| Stars | Gold | #FFD93D |
| Success | Bright Green | #4CAF50 |
| Failure | Soft Red | #E57373 |
| Text Primary | Dark Brown | #4A3728 |
| Text Secondary | Warm Gray | #8B7355 |
| Accent | Coral Pink | #FF8A80 |

### Typography

| Element | Font Style | Size |
|---------|------------|------|
| Game Title | Rounded, bold | 48sp |
| Level Numbers | Clean sans-serif | 32sp |
| Button Text | Medium weight | 18sp |
| Descriptions | Light | 14sp |

### Key UI Elements

| Element | Description |
|---------|-------------|
| Grid Container | Centered, 80% screen width, soft shadow |
| Cell | Rounded square, 3dp corner radius |
| Seed | Small dot with pulse animation |
| Plant Animation | Seed → Sprout → Full (2s) |
| Star Display | 3 stars, fill left-to-right |
| Progress Bar | Horizontal, rounded ends |
| Navigation | Bottom bar: Home, Retry, Pause |
| Result Modal | Centered, 80% width, rounded corners |

---

## 11. SOUND DESIGN

### Sound Categories

| Category | Sounds Needed |
|----------|---------------|
| **Ambient** | Background loop per biome (peaceful, nature sounds) |
| **UI** | Button tap, menu open/close, modal appear |
| **Planting** | Soft "pop" when placing seed |
| **Growing** | Whoosh + gentle nature growth sounds |
| **Success** | Cheerful chime, confetti swoosh |
| **Failure** | Soft "whomp", gentle negative feedback |
| **Star Earned** | Individual chime per star |

### Implementation
- Godot 4 AudioStreamPlayer
- Background music crossfade between biomes
- Master volume + SFX volume (separate settings)

---

## 12. ANALYTICS & EVENTS

### Key Events to Track

| Event | Data |
|-------|------|
| level_start | level_id, biome |
| level_complete | level_id, stars, accuracy, moves_used |
| level_retry | level_id, attempt_number |
| level_fail | level_id, fail_reason |
| iap_purchase | item_id, price |
| theme_unlock | theme_id |
| session_length | duration |
| return_user | days_since_last_session |

---

## 13. TECHNICAL REQUIREMENTS

### Engine & Platform
- **Engine:** Godot 4.x
- **Language:** GDScript
- **Export:** iOS (Xcode), Android (APK/AAB)
- **Min iOS:** 12.0
- **Min Android:** API 21 (Android 5.0)

### Performance Targets
- 60 FPS on mid-range devices (iPhone 8+, Galaxy S10+)
- < 100MB APK size
- < 50MB iOS app size
- < 2s cold start

### Project Structure

```
bloom/
├── project.godot
├── scenes/
│   ├── main.tscn              # Entry point
│   ├── screens/
│   │   ├── splash_screen.tscn
│   │   ├── main_menu.tscn
│   │   ├── level_select.tscn
│   │   ├── game_screen.tscn
│   │   ├── results_screen.tscn
│   │   ├── shop_screen.tscn
│   │   └── settings_screen.tscn
│   ├── game/
│   │   ├── grid.tscn
│   │   ├── cell.tscn
│   │   ├── plant.tscn
│   │   └── effects.tscn
│   └── ui/
│       ├── button.tscn
│       ├── star_display.tscn
│       └── modal.tscn
├── scripts/
│   ├── autoload/
│   │   ├── game_state.gd      # Global state singleton
│   │   ├── audio_manager.gd
│   │   └── save_manager.gd
│   ├── screens/
│   │   ├── main_menu.gd
│   │   ├── level_select.gd
│   │   ├── game_screen.gd
│   │   └── results_screen.gd
│   └── game/
│       ├── grid.gd
│       ├── cell.gd
│       ├── plant.gd
│       ├── level_data.gd
│       └── plant_placer.gd
├── resources/
│   ├── levels/
│   │   └── levels.json       # All level data
│   ├── themes/
│   │   ├── meadow.tres
│   │   ├── desert.tres
│   │   └── ...
│   ├── plants/
│   │   ├── flower.tscn
│   │   ├── bush.tscn
│   │   └── ...
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── ui/
│       └── fonts/
├── assets/
│   ├── images/
│   │   ├── ui/
│   │   └── plants/
│   └── icons/
├── export_presets/
│   ├── ios_preset.cfg
│   └── android_preset.cfg
└── README.md
```

### Save System
- Local JSON save using Godot's FileAccess
- Data: level progress, stars, unlocked content, settings
- Auto-save after each level completion
- Cloud save (future): Google Play Games / Game Center

---

## 14. LEVEL LIST (1-30 Sample)

| Level | Grid | Moves | Plants | Obstacles | Biome |
|-------|------|-------|--------|-----------|-------|
| 1 | 3x3 | 3 | Flower | None | Meadow |
| 2 | 3x3 | 2 | Flower | None | Meadow |
| 3 | 3x3 | 2 | Flower | None | Meadow |
| 4 | 3x3 | 1 | Flower | None | Meadow |
| 5 | 3x3 | 3 | Flower | None | Meadow |
| 6 | 3x3 | 3 | Flower+Bush | None | Meadow |
| 7 | 4x4 | 3 | Flower+Bush | None | Meadow |
| 8 | 4x4 | 3 | Flower+Bush | None | Meadow |
| 9 | 4x4 | 2 | Flower+Bush | None | Meadow |
| 10 | 4x4 | 4 | Flower+Bush | None | Meadow |
| 11 | 4x4 | 4 | All | None | Meadow |
| 12 | 4x4 | 3 | All | None | Meadow |
| 13 | 4x4 | 5 | All | None | Meadow |
| 14 | 4x4 | 2 | All | None | Meadow |
| 15 | 4x4 | 4 | All | 1 Rock | Meadow |
| 16 | 4x4 | 4 | All | 1 Rock | Meadow |
| 17 | 4x4 | 5 | All | 2 Rocks | Meadow |
| 18 | 4x4 | 3 | All | 1 Water | Meadow |
| 19 | 4x4 | 4 | All | Mixed | Meadow |
| 20 | 5x5 | 4 | All | Mixed | Meadow |
| 21 | 5x5 | 4 | All | 2 Rocks | Desert |
| 22 | 5x5 | 3 | All | Water | Desert |
| 23 | 5x5 | 5 | All | Mixed | Desert |
| 24 | 5x5 | 4 | All | 3 Rocks | Desert |
| 25 | 5x5 | 3 | All | Complex | Desert |
| 26 | 5x5 | 4 | All | 2 Weeds | Desert |
| 27 | 5x5 | 5 | All | 2 Rocks, 1 Water | Desert |
| 28 | 5x5 | 4 | All | 3 Weeds | Desert |
| 29 | 5x5 | 3 | All | 4 Rocks | Desert |
| 30 | 5x5 | 4 | All | Complex | Desert |

(Full 100 levels to be designed with increasing difficulty)

---

## 15. ACCESSIBILITY

### Features
- **Colorblind modes:** Deuteranopia, Protanopia, Tritanopia options
- **Screen reader:** Basic support for UI navigation
- **Haptic feedback:** Vibration on plant/result (can be disabled)
- **Reduced motion:** Skip growth animations option
- **Font scaling:** Increase/decrease text size
- **Guide mode:** Show optimal placement hint (free, unlimited)

---

## 16. POST-LAUNCH ROADMAP

### Phase 1 (Launch)
- 100 campaign levels
- 5 biomes
- Basic shop (themes, plant colors)
- iOS + Android release

### Phase 2 (Month 1-3)
- Endless mode
- Daily challenges
- Weekly leaderboards
- 2-3 new plant types
- Social sharing (screenshot results)

### Phase 3 (Month 3-6)
- Season events (limited time themes)
- Cloud save
- Friend leaderboards
- New biome: Cherry Blossom
- Sound packs expansion

---

*Document prepared by Bottie — Ready for development handoff.*
