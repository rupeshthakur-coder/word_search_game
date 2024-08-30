import 'package:flutter/material.dart';
import 'package:myapp/levels/levels.dart';

class LevelListPage extends StatelessWidget {
  final Difficulty difficulty;

  const LevelListPage({super.key, required this.difficulty});

  void _onLevelSelected(BuildContext context, int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WordSearchGame(difficulty: difficulty, level: level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${difficulty.toString().split('.').last} Levels'),
        backgroundColor: const Color(0xFF2B4C7E), // Dark Blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: 20, // 20 levels per difficulty
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B4C7E), // Dark Blue
                padding: const EdgeInsets.all(4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _onLevelSelected(context, index),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFE3EDF7), // Light Blue Background
    );
  }
}
