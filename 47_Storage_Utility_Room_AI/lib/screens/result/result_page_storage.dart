import 'package:flutter/material.dart';
import '../../theme/storage_theme.dart';
import '../../widgets/result/tap_swipe_compare.dart';
import 'organization_notes_panel.dart';

class ResultPageStorage extends StatelessWidget {
  const ResultPageStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StorageColors.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Design Result", style: StorageTheme.darkTheme.textTheme.headlineMedium),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
        ],
      ),
      body: Column(
        children: [
          // Main Visual (Hero)
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              child: TapSwipeCompare(
                beforeImage: const AssetImage("assets/onboarding/guide_bad.jpg"),
                afterImage: const AssetImage("assets/examples/ex_01.jpg"),
              ),
            ),
          ),

          // Details
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const OrganizationNotesPanel(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Regenerate (Edit Prompts)"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
