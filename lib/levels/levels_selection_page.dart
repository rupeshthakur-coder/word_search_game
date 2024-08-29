import 'package:flutter/material.dart';
import 'package:myapp/levels/level_list_paage.dart';
import 'package:myapp/levels/levels.dart';


class LevelSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Level')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Difficulty:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DifficultyButton(
              difficulty: Difficulty.Easy,
              label: 'Easy',
              color: Colors.green,
            ),
            DifficultyButton(
              difficulty: Difficulty.Medium,
              label: 'Medium',
              color: Colors.orange,
            ),
            DifficultyButton(
              difficulty: Difficulty.Hard,
              label: 'Hard',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final String label;
  final Color color;

  DifficultyButton({
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
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: () => _onDifficultySelected(context),
      child: Text(label, style: TextStyle(fontSize: 18)),
    );
  }
}
