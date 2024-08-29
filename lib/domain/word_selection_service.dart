import 'package:flutter/material.dart';

class WordSearchService {
  final int gridSize;
  final List<String> words;
  final List<String> grid;

  Set<int> correctIndices = {};
  Set<List<int>> correctWords = {};
  List<int> selectedIndices = [];

  WordSearchService({required this.gridSize, required this.words, required this.grid});

  void handleTap(int index, Function(List<int>) onWordSelected) {
    if (!correctIndices.contains(index)) {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
      onWordSelected(selectedIndices);
    }
  }

  void handleDragUpdate(Offset localPosition, Function(List<int>) onWordSelected, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    double gridItemSize = box.size.width / gridSize;
    int column = (localPosition.dx / gridItemSize).floor();
    int row = (localPosition.dy / gridItemSize).floor();
    int index = row * gridSize + column;

    if (index >= 0 && index < gridSize * gridSize) {
      handleTap(index, onWordSelected);
    }
  }

  bool checkIfWordFound(List<int> selectedIndices, Function(String) onWordFound) {
    String selectedWord = selectedIndices.map((index) => grid[index]).join();
    if (words.contains(selectedWord) && !correctWords.any((indices) => _compareLists(indices, selectedIndices))) {
      correctWords.add(List.from(selectedIndices));
      correctIndices.addAll(selectedIndices);
      onWordFound(selectedWord);
      return true;
    }
    return false;
  }

  bool _compareLists(List<int> a, List<int> b) {
    return a.length == b.length && a.every((element) => b.contains(element));
  }
}