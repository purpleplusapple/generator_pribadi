# Balcony Terrace AI

AI-powered balcony and terrace design inspiration app.

## Overview

Balcony Terrace AI helps users design and visualize their dream outdoor space. Upload a photo of your balcony or patio and let AI transform it into a perfectly organized, atmospheric outdoor lounge.

## Features

- **AI-Powered Design**: Advanced AI generates realistic outdoor scenes.
- **Multiple Styles**: Cozy Lantern, Modern Minimal, Tropical Jungle, and 20+ more.
- **Customization**: Adjust lighting warmth, greenery level, seating capacity, and privacy screens.
- **Cinematic Outdoor Theme**: Night Garden palette with Lantern Amber accents.
- **Save & Share**: Keep your favorite designs and share with friends.

## Premium Features

- **Free Plan**: Browse styles and explore the app.
- **Premium Subscription**:
  - 10 AI designs per day
  - Unlimited generations with token packs
  - Access to advanced styles (Fire Pit, Luxury Hotel)
  - Priority queue for faster renders
  - Full history with high-res downloads

## Technical Stack

- **Framework**: Flutter (iOS-focused)
- **Theme**: Custom Terrace design system with Night Garden palette
- **Monetization**: RevenueCat (subscriptions + consumable tokens)
- **Storage**: SharedPreferences for local data
- **Image Processing**: Flutter image picker & processors

## Project Structure

```
lib/
├── theme/              # Terrace design system (colors, typography, etc)
├── model/              # Data models (Styles, Config)
├── data/               # Static style definitions (24+ styles)
├── services/           # Business logic & API services
├── screens/            # UI screens (Home, Wizard, Gallery)
├── components/         # Reusable components (GlassDock, RailStepper)
└── src/                # Core constants, paywall, assets
```

## Color Palette

- **Deep Night** (#070B0A) - Background
- **Emerald Green** (#2FA37B) - Primary
- **Lantern Amber** (#E7A35A) - Accent
- **Night Violet** (#6F7CFF) - Secondary Accent
- **Mist** (#A3ACA2) - Muted Text

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Configure RevenueCat:
- Add your API keys in `lib/src/constant.dart`
- Set up products in RevenueCat dashboard

3. Run on iOS simulator/device:
```bash
flutter run
```

## Key Files

- `lib/main.dart` - App entry point
- `lib/theme/terrace_theme.dart` - Complete design system
- `lib/data/terrace_styles.dart` - Style definitions
- `lib/screens/wizard/steps/style_terrace_step.dart` - Style picker logic

## Derived From

Clone of Shoe Room AI, completely structurally redesigned for Outdoor Living context.

---

**Note**: App icon asset needed at `assets/icon.jpg`
