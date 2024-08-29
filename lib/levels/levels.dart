import 'package:flutter/material.dart';
import 'package:myapp/grid_view/grid_view.dart';
import 'package:myapp/logics/word_pacement.dart';

enum Difficulty { Easy, Medium, Hard }

class WordSearchGame extends StatefulWidget {
  final Difficulty difficulty;
  final int level;

  WordSearchGame({required this.difficulty, required this.level});

  @override
  _WordSearchGameState createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> {
  late WordSearchLogic wordSearchLogic;
  late int gridSize;
  late List<String> words;
  List<String> foundWords = [];

  final List<List<String>> easyWords = [
    ['CAT', 'DOG', 'BIRD'], // Level 1
    ['SUN', 'MOON', 'STAR'], // Level 2
    ['FISH', 'HEN', 'ANT'], // Level 3
    // Add 17 more lists of words for each level
  ];

  final List<List<String>> mediumWords = [
    ['ELEPHANT', 'GIRAFFE', 'KANGAROO'], // Level 1
    ['MONKEY', 'TIGER', 'LEOPARD'], // Level 2
    ['PENGUIN', 'OSTRICH', 'DOLPHIN'], // Level 3
    // Add 17 more lists of words for each level
  ];

  final List<List<String>> hardWords = [
    ['HIPPOPOTAMUS', 'CHIMPANZEE', 'CROCODILE'], // Level 1
    ['RHINOCEROS', 'ALLIGATOR', 'SQUIRREL'], // Level 2
    ['ARMADILLO', 'WOODPECKER', 'PORCUPINE'], // Level 3
    // Add 17 more lists of words for each level
  ];

  @override
  void initState() {
    super.initState();

    switch (widget.difficulty) {
      case Difficulty.Easy:
        gridSize = 8;
        words = easyWords[widget.level];
        break;
      case Difficulty.Medium:
        gridSize = 12;
        words = mediumWords[widget.level];
        break;
      case Difficulty.Hard:
        gridSize = 16;
        words = hardWords[widget.level];
        break;
    }
    wordSearchLogic = WordSearchLogic(gridSize: gridSize, words: words);
  }

  void _onWordSelected(List<int> selectedIndices) {
    String selectedWord = selectedIndices
        .map((index) => wordSearchLogic.grid[index])
        .join();

    if (words.contains(selectedWord) && !foundWords.contains(selectedWord)) {
      setState(() {
        foundWords.add(selectedWord);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Word Search - Level ${widget.level + 1}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Words to Find:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 10.0,
            children: words.map((word) {
              bool isFound = foundWords.contains(word);
              return Chip(
                label: Text(
                  word,
                  style: TextStyle(
                    color: isFound ? Colors.green : Colors.black,
                    decoration: isFound ? TextDecoration.lineThrough : null,
                  ),
                ),
                backgroundColor: isFound ? Colors.green.withOpacity(0.3) : null,
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Expanded(
            child: WordSearchGrid(
              gridSize: gridSize,
              gridLetters: wordSearchLogic.grid,
              onWordSelected: _onWordSelected,
            ),
          ),
        ],
      ),
    );
  }
}
