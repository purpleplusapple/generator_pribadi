# Camper Van AI

AI-powered shoe room design and organization app for iOS.

## Overview

Camper Van AI helps users design and visualize their dream shoe closet or storage space. Upload a photo of your space and let AI transform it into a perfectly organized, stylish shoe room.

## Features

- **AI-Powered Design**: Advanced AI generates realistic shoe room designs
- **Multiple Styles**: Modern luxury, classic traditional, minimalist, industrial, boutique
- **Customization**: Choose display types, materials, lighting, and special features
- **Premium Materials Theme**: Leather brown, canvas white, metallic gold aesthetic
- **Save & Share**: Keep your favorite designs and share with others

## Premium Features

- **Free Plan**: Browse app and explore features (AI generation requires premium)
- **Premium Subscription**:
  - 10 AI shoe room designs per day
  - Unlimited generations with token packs
  - Access all display styles and materials
  - Priority queue for faster renders
  - Full history with high-res downloads

## Technical Stack

- **Framework**: Flutter (iOS-focused)
- **Theme**: Custom CamperAI design system with premium materials palette
- **Monetization**: RevenueCat (subscriptions + consumable tokens)
- **Storage**: SharedPreferences for local data
- **Image Processing**: Flutter image picker & processors

## Project Structure

```
lib/
├── theme/              # CamperAI design system (colors, typography, etc)
├── model/              # Data models
├── services/           # Business logic & API services
├── screens/            # UI screens (home, wizard, gallery, settings)
├── widgets/            # Reusable components
└── src/                # Core constants, paywall, assets
```

## Color Palette

- **Rich Brown** (#3E2723) - Premium leather
- **Canvas White** (#FAFAFA) - Clean canvas
- **Sole Black** (#212121) - Rubber sole
- **Leather Tan** (#BF8040) - Tan leather accent
- **Metallic Gold** (#D4AF37) - Luxury hardware
- **Lace Gray** (#9E9E9E) - Neutral gray

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
- `lib/theme/camper_van_ai_theme.dart` - Complete design system
- `lib/src/constant.dart` - RevenueCat & premium configuration
- `lib/src/mypaywall.dart` - Subscription paywall UI
- `lib/onboards.dart` - Onboarding flow with shoe-specific questions

## Derived From

This project is a rebranding/adaptation of Laundry Room AI, customized for shoe room organization and display.

---

**Note**: App icon asset needed at `assets/app_icon.png`
