# Beauty Salon AI

AI-powered beauty salon design and organization app for iOS.

## Overview

Beauty Salon AI helps users design and visualize their dream beauty salon, spa, or styling space. Upload a photo of your space and let AI transform it into a perfectly organized, stylish salon.

## Features

- **AI-Powered Design**: Advanced AI generates realistic beauty salon designs
- **Multiple Styles**: Modern luxury, boho chic, minimalist zen, industrial chic, classic elegant
- **Customization**: Choose storage styles, workstation surfaces, lighting, and layout
- **Elegant Theme**: Rose gold, cream white, charcoal, and metallic gold aesthetic
- **Save & Share**: Keep your favorite designs and share with clients or contractors

## Premium Features

- **Free Plan**: Browse app and explore features (AI generation requires premium)
- **Premium Subscription**:
  - 10 AI salon designs per day
  - Unlimited generations with token packs
  - Access all furniture styles and materials
  - Priority queue for faster renders
  - Full history with high-res downloads

## Technical Stack

- **Framework**: Flutter (iOS-focused)
- **Theme**: Custom BeautySalonAI design system with elegant palette
- **Monetization**: RevenueCat (subscriptions + consumable tokens)
- **Storage**: SharedPreferences for local data
- **Image Processing**: Flutter image picker & processors

## Project Structure

```
lib/
├── theme/              # BeautySalonAI design system (colors, typography, etc)
├── model/              # Data models
├── services/           # Business logic & API services
├── screens/            # UI screens (home, wizard, gallery, settings)
├── widgets/            # Reusable components
└── src/                # Core constants, paywall, assets
```

## Color Palette

- **Cream White** (#FDFBF7) - Soft background
- **Rose Gold** (#B76E79) - Elegant accent
- **Charcoal** (#333333) - Text and contrast
- **Sage Green** (#8FA79A) - Calming accent
- **Metallic Gold** (#D4AF37) - Luxury details

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
- `lib/theme/beauty_salon_ai_theme.dart` - Complete design system
- `lib/src/constant.dart` - RevenueCat & premium configuration
- `lib/src/mypaywall.dart` - Subscription paywall UI
- `lib/onboards.dart` - Onboarding flow with salon-specific questions

## Derived From

This project is a redesign and adaptation of Shoe Room AI, customized for beauty salon design.

---

**Note**: App icon asset needed at `assets/icon.jpg`
