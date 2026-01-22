# Clinic Room AI — UI Differentiation Spec & Anti-Clone Proof

## 1. Screen Inventory (Source: Shoe Room AI)

| Screen | Layout / Structure | Key Components | Visual Style |
| :--- | :--- | :--- | :--- |
| **Home** | Grid/List of Features | `GlassCard`, `GradientButton` | Dark Mode (Black/Gold/Tan) |
| **Wizard** | Horizontal Stepper (Circles) | `WizardProgressIndicator` | Floating, Glassmorphism |
| **Upload** | Single Panel | `UploadStep` | Simple Center |
| **Style** | Grid Selection | `StyleLaundryStep` | Toggles |
| **Result** | Standard Result View | `ResultStep` | - |

## 2. Similarity Risk Assessment

*   **Initial Score:** 95 (Direct Clone)
*   **Target Score:** ≤ 35

## 3. UI Differentiation Spec (Target: Clinic Room AI)

### A. Design Tokens (Brand: "Medical Trust")

*   **Theme:** Light Mode Only (vs Source Dark Mode).
*   **Colors:**
    *   Background: `#F6FAFB` (Cool White)
    *   Primary: `#138A8A` (Medical Teal)
    *   Ink: `#0F1A1C` (Dark Blue-Black)
    *   Success: `#1C8B6A`
*   **Typography:** Sora (Headings) + Inter (Body). High contrast.
*   **Shapes:** Radius 16px (Professional). No full-glassmorphism. Solid clean surfaces.

### B. Core Navigation Redesign

*   **Structure:**
    *   **Source:** Full-screen Hero/Grid.
    *   **Target:** **Clinic Dashboard**.
*   **Components:**
    *   `ClinicDashboardHeader` (Greeting + Readiness Score).
    *   `ClinicQuickActionsRow` (New Design, Guidelines, etc.).
    *   `RoomTypeClinicalCard` (Horizontal List: Exam, Waiting, Dental).

### C. Wizard Redesign (Vertical Rail / Segmented)

*   **Stepper:**
    *   **Source:** Horizontal Circles with connectors below header.
    *   **Target:** **Segmented Stepper** (Top bar with text labels + thin progress line) OR **Vertical Step Rail** (Left side icons). *Decision: Segmented Top Bar for cleaner mobile view.*
*   **Upload Step:**
    *   **Source:** Single image picker.
    *   **Target:** **Two-Panel Layout**. Top/Left: Upload Area. Bottom/Right: "Hygiene Checklist" (Lighting, Angle, Cleanliness).

### D. Result & Compare Redesign

*   **Compare:**
    *   **Source:** Slider? (Assumed standard).
    *   **Target:** **"Tap to Flip"** Card or **Toggle Pill** (Before/After).
*   **Details:**
    *   **Source:** Download/Share buttons.
    *   **Target:** **Clinical Details Panel** (Lighting score, Cleanliness rating, Recommended Furniture list).

## 4. Implementation Checklist (Anti-Clone Gate)

- [ ] **Theme:** Replace `shoe_room_ai_theme.dart` with `clinic_theme.dart`.
- [ ] **Fonts:** Add Sora/Inter to `pubspec.yaml` (Google Fonts).
- [ ] **Home:** Build `ClinicDashboardHeader`, `ClinicQuickActionsRow`, `RoomTypeClinicalCard`.
- [ ] **Wizard:** Build `ClinicSegmentedStepper` (replace `WizardProgressIndicator`).
- [ ] **Upload:** Build `UploadChecklistPanel`.
- [ ] **Result:** Build `ClinicalDetailsPanel` and `BeforeAfterFlipToggle`.
- [ ] **Assets:** Replace all icons with Medical/Clinic versions.

## 5. Component Replacement Rule (>60%)

| Old Component | New Component | Change Type |
| :--- | :--- | :--- |
| `GlassCard` | `ClinicalCard` | Visual + Structure (No blur, solid white) |
| `GradientButton` | `PrimaryButton` | Visual (Flat Teal, no gradient) |
| `WizardProgressIndicator` | `ClinicSegmentedStepper` | Layout (Circles -> Segments) |
| `ShoeAIColors` | `ClinicColors` | Palette Swap (Dark -> Light) |
| `UploadStep` | `UploadWithChecklistStep` | Layout (1-panel -> 2-panel) |
