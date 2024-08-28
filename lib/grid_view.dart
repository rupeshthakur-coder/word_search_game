import 'package:flutter/material.dart';

class WordSearchGrid extends StatefulWidget {
  final int gridSize;
  final List<String> gridLetters;
  final Function(List<int>) onWordSelected;

  WordSearchGrid({
    required this.gridSize,
    required this.gridLetters,
    required this.onWordSelected,
  });

  @override
  _WordSearchGridState createState() => _WordSearchGridState();
}

class _WordSearchGridState extends State<WordSearchGrid> {
  List<int> selectedIndices = [];

  void _handleTap(int index) {
    setState(() {
      // Add or remove the index from the selected indices list
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });

    // Call the onWordSelected callback with the current selected indices
    widget.onWordSelected(selectedIndices);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.gridSize,
      ),
      itemCount: widget.gridSize * widget.gridSize,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndices.contains(index);
        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.white,
            ),
            child: Text(
              widget.gridLetters[index],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
