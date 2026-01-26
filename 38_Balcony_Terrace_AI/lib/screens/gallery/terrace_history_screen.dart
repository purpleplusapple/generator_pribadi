import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';
import '../../theme/terrace_theme.dart';
import '../../services/terrace_history_repository.dart';
import '../../services/terrace_result_storage.dart';
import '../../model/terrace_ai_config.dart';

class TerraceHistoryScreen extends StatefulWidget {
  const TerraceHistoryScreen({super.key});

  @override
  State<TerraceHistoryScreen> createState() => _TerraceHistoryScreenState();
}

class _TerraceHistoryScreenState extends State<TerraceHistoryScreen> {
  final TerraceHistoryRepository _historyRepo = TerraceHistoryRepository();
  // final TerraceResultStorage _storage = TerraceResultStorage(); // unused for now

  // Mock data for UI visual if DB empty
  final bool _useMock = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bg0,
      appBar: AppBar(
        title: Text('Your Designs', style: terraceTheme.textTheme.headlineMedium?.copyWith(color: DesignTokens.ink0)),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _historyRepo.getHistoryIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final ids = snapshot.data ?? [];

          if (ids.isEmpty && !_useMock) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_toggle_off, size: 64, color: DesignTokens.surface2),
                  const SizedBox(height: 16),
                  const Text('No designs yet', style: TextStyle(color: DesignTokens.muted)),
                  TextButton(onPressed: () {}, child: const Text('Create One Now')),
                ],
              ),
            );
          }

          // Masonry Grid Simulation (2 columns)
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildHistoryCard(1.2),
                      _buildHistoryCard(0.8),
                      _buildHistoryCard(1.0),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildHistoryCard(0.9),
                      _buildHistoryCard(1.3),
                      _buildHistoryCard(1.1),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(double aspectRatio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DesignTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                color: DesignTokens.surface2,
                child: const Center(child: Icon(Icons.image, color: DesignTokens.muted)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cozy Night', style: TextStyle(color: DesignTokens.ink0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Just now', style: TextStyle(color: DesignTokens.muted, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
