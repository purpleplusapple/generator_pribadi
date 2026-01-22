// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_room_ai/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HotelRoomAIApp());

    // Verify that the app title is present (Splash or Onboarding)
    // Since we have animations, pumpAndSettle might be needed, or just finding a widget.
    // We'll just check if it builds without crashing.
    expect(find.byType(HotelRoomAIApp), findsOneWidget);
  });
}
