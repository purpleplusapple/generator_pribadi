# Anti-Clone Proof & UI Differentiation Spec

## 1. Screen Inventory (Source vs Target)

| Screen | Source (Shoe Room AI) | Target (Hotel Room AI) | Status |
| :--- | :--- | :--- | :--- |
| **Home** | Hero Layout (Center Icon + Title + Big Button) | Hotel Dashboard (Pill cards + Staggered Grid) | **Redesign** |
| **Wizard** | Horizontal Progress Bar + 5 linear steps | Vertical Step Rail (Left) + Split Panel Upload | **Redesign** |
| **Result** | Single Image View | Swipe Compare (Before/After) | **Redesign** |
| **History** | Standard Grid | Timeline / Mood Board Masonry | **Redesign** |
| **Settings** | List View | List View (Styled) | Keep |

## 2. Similarity Risk Score

**Initial Score Calculation:**
- Layout Skeleton: 90/100 (Identical start)
- Hierarchy: 90/100 (Identical start)
- Navigation: 90/100 (Identical start)
- Spacing/Radius: 80/100 (Similar defaults)
- **Total Initial Risk:** 88 (FAIL)

**Target Score Goal:** < 35

**Differentiation Strategy:**
1.  **Layout:** Move from Center-Hero to Dashboard-Grid.
2.  **Navigation:** Move from Horizontal Stepper to Vertical Rail.
3.  **Interaction:** Move from Click-View to Swipe-Compare.
4.  **Visuals:** Move from Dark/Neon to Warm/Linen (Option A).

## 3. Design Tokens (Option A: Boutique Linen)

**Colors:**
- `bg0`: #FBF7F2 (Linen)
- `bg1`: #FFFFFF (Surface)
- `ink0`: #1C1612 (Primary Text)
- `ink1`: #3B2F28 (Secondary Text)
- `primary`: #A06A43 (Warm Tan)
- `accent`: #2E6F6A (Teal Calm)

**Typography:**
- Heading: **DM Serif Display** (Luxury/Editorial)
- Body: **Inter** (Clean/Modern)

**Shapes:**
- Radius: 14-20px (Soft, organic)
- Shadows: Soft natural shadows (no neon glows)

## 4. Component Replacement Rule (60% Target)

| Old Component | New Component |
| :--- | :--- |
| `WizardProgressIndicator` (Horizontal) | `WizardStepRail` (Vertical Left) |
| `HeroSection` (Center) | `HotelQuickActionBar` + `RoomTypePillCard` |
| `FeaturesCarousel` | `MoodBoardStaggeredGrid` |
| `ResultImageView` | `SwipeBeforeAfterCompare` |
| `GlassCard` | `HotelPaperCard` (Solid/Texture) |

## 5. Implementation Checklist (Audit)

- [ ] **Navigation Pattern:** Changed from Horizontal Tabs to Vertical Rail?
- [ ] **Home Architecture:** Changed from Hero-Center to Dashboard?
- [ ] **Wizard Flow:** Changed Upload screen to Split-Panel?
- [ ] **Primary CTA:** Moved/Resized from Center-Big?
- [ ] **Card System:** Changed from Glass/Dark to Paper/Light?
- [ ] **Result Interaction:** Implemented Swipe Compare?
- [ ] **Typography:** DM Serif Display implemented?
- [ ] **Color Palette:** Warm Linen applied (No Dark Mode)?
- [ ] **Readability:** Contrast ratios checked?
- [ ] **Assets:** All "Shoe" icons/images removed?
