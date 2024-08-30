import 'package:flutter/material.dart';
import 'package:myapp/levels/level_list_paage.dart';

import 'package:myapp/levels/levels.dart';

class LevelSelectionPage extends StatelessWidget {
  const LevelSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Level',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B4C7E), // Dark Blue
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Difficulty:',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B4C7E), // Dark Blue
              ),
            ),
            SizedBox(height: 20),
            DifficultyButton(
              difficulty: Difficulty.Easy,
              label: 'Easy',
              color: Color(0xFF2B4C7E), // Green
            ),
            SizedBox(height: 10),
            DifficultyButton(
              difficulty: Difficulty.Medium,
              label: 'Medium',
              color: Color(0xFF2B4C7E), // Orange
            ),
            SizedBox(height: 10),
            DifficultyButton(
              difficulty: Difficulty.Hard,
              label: 'Hard',
              color: Color(0xFF2B4C7E), // Red
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFE3EDF7), // Light Blue Background
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final String label;
  final Color color;

  const DifficultyButton({super.key, 
    required this.difficulty,
    required this.label,
    required this.color,
  });

  void _onDifficultySelected(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelListPage(difficulty: difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _onDifficultySelected(context),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
