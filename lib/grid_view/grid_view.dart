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
  Set<int> correctIndices = {};
  Set<List<int>> correctWords = {};
  int? lastTappedIndex;

  void _handleTap(int index) {
    setState(() {
      if (!correctIndices.contains(index)) {
        if (selectedIndices.contains(index)) {
          selectedIndices.remove(index);
        } else {
          selectedIndices.add(index);
        }
        lastTappedIndex = index;
      }
      widget.onWordSelected(selectedIndices);
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    double gridItemSize = box.size.width / widget.gridSize;
    int column = (localPosition.dx / gridItemSize).floor();
    int row = (localPosition.dy / gridItemSize).floor();
    int index = row * widget.gridSize + column;

    if (index != lastTappedIndex &&
        index >= 0 &&
        index < widget.gridSize * widget.gridSize) {
      _handleTap(index);
    }
  }

  void markCorrectSelection(List<int> indices) {
    setState(() {
      correctWords.add(indices);
      correctIndices.addAll(indices);
      selectedIndices.removeWhere((index) => indices.contains(index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handleDragUpdate,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(), // Disable scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.gridSize,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemCount: widget.gridSize * widget.gridSize,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndices.contains(index);
          bool isCorrect = correctIndices.contains(index);
          return GestureDetector(
            onTap: () => _handleTap(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.greenAccent.withOpacity(0.7)
                    : isSelected
                        ? Colors.blueAccent.withOpacity(0.7)
                        : Colors.white,
                border: Border.all(
                  color: isCorrect
                      ? Colors.greenAccent
                      : isSelected
                          ? Colors.blueAccent
                          : Colors.grey.shade400,
                  width: isCorrect || isSelected ? 1.0 : 0.4,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                widget.gridLetters[index],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isCorrect
                      ? Colors.greenAccent
                      : isSelected
                          ? Colors.blueAccent
                          : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
