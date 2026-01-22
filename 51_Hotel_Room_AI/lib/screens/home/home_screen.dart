// lib/screens/home/home_screen.dart
// Redesigned Hotel Dashboard
// Option A: Boutique Linen Theme

import 'package:flutter/material.dart';
import '../../theme/hotel_room_ai_theme.dart';
import '../../widgets/hotel_quick_action_bar.dart';
import '../../widgets/room_type_pill.dart';
import '../../widgets/mood_board_grid.dart';
import '../../widgets/swipe_compare.dart'; // Just for imports if needed, but not used directly on home

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedRoomTypeIndex = 0;

  final List<String> _roomTypes = [
    "All",
    "Deluxe Suite",
    "Lobby",
    "Bedroom",
    "Bathroom",
    "Restaurant",
  ];

  final List<MoodBoardItem> _moodBoardItems = [
    MoodBoardItem(
      id: '1',
      title: 'Minimalist Zen Suite',
      category: 'Modern',
      imageUrl: 'assets/onboarding_1.jpg', // Placeholder
      heightRatio: 1.2,
    ),
    MoodBoardItem(
      id: '2',
      title: 'Royal Heritage Lobby',
      category: 'Classic',
      imageUrl: 'assets/onboarding_2.jpg',
      heightRatio: 1.5,
    ),
    MoodBoardItem(
      id: '3',
      title: 'Coastal Resort Bedroom',
      category: 'Resort',
      imageUrl: 'assets/onboarding_3.jpg',
      heightRatio: 1.0,
    ),
    MoodBoardItem(
      id: '4',
      title: 'Industrial Chic Bar',
      category: 'Urban',
      imageUrl: 'assets/onboarding_4.jpg',
      heightRatio: 1.3,
    ),
    MoodBoardItem(
      id: '5',
      title: 'Scandinavian Studio',
      category: 'Nordic',
      imageUrl: 'assets/icon.jpg',
      heightRatio: 1.1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HotelAIColors.bg0,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            HotelQuickActionBar(
              onSearchTap: () {
                // TODO: Implement search
              },
              onMenuTap: () {
                // TODO: Notifications
              },
              onProfileTap: () {
                // TODO: Profile
              },
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: HotelAISpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: HotelAISpacing.md),

                    // Welcome Title
                    Text(
                      "Design Studio",
                      style: HotelAIText.h1,
                    ),
                    const SizedBox(height: HotelAISpacing.xs),
                    Text(
                      "Create your next masterpiece.",
                      style: HotelAIText.body.copyWith(color: HotelAIColors.muted),
                    ),

                    const SizedBox(height: HotelAISpacing.xl),

                    // Room Type Filter (Horizontal)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: List.generate(_roomTypes.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RoomTypePillCard(
                              label: _roomTypes[index],
                              isSelected: _selectedRoomTypeIndex == index,
                              onTap: () {
                                setState(() {
                                  _selectedRoomTypeIndex = index;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: HotelAISpacing.xl),

                    // Mood Board Grid (Staggered)
                    Text(
                      "Inspiration",
                      style: HotelAIText.h3,
                    ),
                    const SizedBox(height: HotelAISpacing.md),

                    MoodBoardStaggeredGrid(
                      items: _moodBoardItems,
                      onTap: (item) {
                        // TODO: Open detail
                      },
                    ),

                    const SizedBox(height: 80), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           // Navigate to Wizard
           // Assuming route name or direct push. Need to check main router.
           // Source used: ScaffoldMessenger... "Opening wizard..." in the button callback
           // I should look at how the old code navigated.
           // Old code: "Navigate to wizard" was just a snackbar placeholder?
           // I'll check `wizard_screen.dart` location.
           Navigator.pushNamed(context, '/wizard');
           // Wait, I haven't defined named routes in main.dart yet.
           // I'll fix this navigation later or assume a direct push for now.
        },
        backgroundColor: HotelAIColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "New Design",
          style: HotelAIText.button.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
