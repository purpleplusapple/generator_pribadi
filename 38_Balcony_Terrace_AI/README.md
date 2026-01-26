# Balcony Terrace AI

AI-powered balcony and terrace makeover app for iOS.

## Overview

Balcony Terrace AI helps users design and visualize their dream outdoor space. Upload a night photo of your balcony or terrace and let AI transform it into a cozy, glowing oasis.

## Features

- **AI-Powered Design**: Advanced AI generates realistic night scenes with lighting and greenery.
- **Advanced Style Wizard**: 18+ categories with custom controls per style.
- **Custom Controls**: Adjust lighting warmth, plant density, seating type, and more.
- **Dark Night Garden Theme**: Dark, cozy aesthetic with emerald and amber accents.
- **Compare & Save**: Tap-to-compare results and save your history.

## Premium Features

- **Free Plan**: Browse app and explore features.
- **Premium Subscription**:
  - Unlimited AI generations.
  - Access to Advanced Custom Prompting.
  - High-res downloads.

## Technical Stack

- **Framework**: Flutter (iOS-focused)
- **Theme**: Custom Terrace Theme (Dark Night Garden)
- **Monetization**: RevenueCat (subscriptions + consumable tokens)
- **Storage**: SharedPreferences for local data
- **Image Processing**: Replicate API via Flutter

## Project Structure

```
lib/
├── theme/              # Design Tokens & Terrace Theme
├── data/               # Style Categories & Controls
├── services/           # Prompt Builder & API services
├── screens/            # UI screens (Home, Wizard, Result, History)
├── widgets/            # Reusable components (Dock, Rail, Panels)
└── src/                # Core constants, paywall, assets
```

## Color Palette

- **Background** (#070B0A) - Deep Night
- **Primary** (#2FA37B) - Emerald Green
- **Accent** (#E7A35A) - Lantern Amber
- **Surface** (#101A18) - Dark Glass

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Configure RevenueCat:
- Add your API keys in `lib/src/constant.dart`

3. Run on iOS simulator/device:
```bash
flutter run
```

## Key Files

- `lib/main.dart` - App entry point
- `lib/theme/terrace_theme.dart` - Design system
- `lib/screens/wizard/terrace_wizard_screen.dart` - Main creation flow
- `lib/services/terrace_prompt_builder.dart` - Prompt engineering logic

## Derived From

This project is a specialized adaptation of the Room AI engine, customized for outdoor night scenes.
