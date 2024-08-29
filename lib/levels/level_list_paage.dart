import 'package:flutter/material.dart';
import 'package:myapp/levels/levels.dart';

class LevelListPage extends StatelessWidget {
  final Difficulty difficulty;

  LevelListPage({required this.difficulty});

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
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemCount: 20, // 20 levels per difficulty
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => _onLevelSelected(context, index),
            child: Text(
              ' ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
