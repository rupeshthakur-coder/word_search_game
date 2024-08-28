import 'package:flutter/material.dart';
import 'package:myapp/grid_view.dart';
import 'package:myapp/logics/word_pacement.dart';

class WordSearchGame extends StatefulWidget {
  @override
  _WordSearchGameState createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> {
  late WordSearchLogic wordSearchLogic;
  final int gridSize = 10;
  final List<String> words = ['FLUTTER', 'DART', 'WIDGET', 'STATE', 'WIDGET', 'BUILD'];

  List<String> foundWords = [];

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: Text('Word Search')),
      body: Column(
        children: [
          // Display words to find
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
          // Display the word search grid
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
