import 'package:flutter/material.dart';

class WordSearchGrid extends StatefulWidget {
  final int gridSize;
  final List<String> gridLetters;
  final Function(List<int>) onWordSelected;
  final Set<int> correctIndices;

  const WordSearchGrid({
    super.key,
    required this.gridSize,
    required this.gridLetters,
    required this.onWordSelected,
    required this.correctIndices,
  });

  @override
  State<WordSearchGrid> createState() => _WordSearchGridState();
}

class _WordSearchGridState extends State<WordSearchGrid>
    with SingleTickerProviderStateMixin {
  List<int> selectedIndices = [];
  int? lastTappedIndex;
  String? selectionDirection;

  bool _isAdjacent(int index1, int index2) {
    int row1 = index1 ~/ widget.gridSize;
    int col1 = index1 % widget.gridSize;
    int row2 = index2 ~/ widget.gridSize;
    int col2 = index2 % widget.gridSize;

    return (row1 - row2).abs() <= 1 && (col1 - col2).abs() <= 1;
  }

  bool _isDiagonal(int index1, int index2) {
    int row1 = index1 ~/ widget.gridSize;
    int col1 = index1 % widget.gridSize;
    int row2 = index2 ~/ widget.gridSize;
    int col2 = index2 % widget.gridSize;

    return (row1 - row2).abs() == (col1 - col2).abs();
  }

  bool _isHorizontalOrVertical(int index1, int index2) {
    int row1 = index1 ~/ widget.gridSize;
    int col1 = index1 % widget.gridSize;
    int row2 = index2 ~/ widget.gridSize;
    int col2 = index2 % widget.gridSize;

    return row1 == row2 || col1 == col2;
  }

  bool _canSelectIndex(int index) {
    if (selectedIndices.isEmpty) return true;

    if (selectedIndices.length == 1) {
      return _isAdjacent(selectedIndices.first, index);
    } else if (selectionDirection == "diagonal") {
      return _isDiagonal(selectedIndices.first, index);
    } else if (selectionDirection == "horizontal") {
      return index ~/ widget.gridSize ==
          selectedIndices.first ~/ widget.gridSize;
    } else if (selectionDirection == "vertical") {
      return index % widget.gridSize == selectedIndices.first % widget.gridSize;
    }
    return false;
  }

  void _determineSelectionDirection() {
    if (selectedIndices.length > 1) {
      int firstIndex = selectedIndices.first;
      int secondIndex = selectedIndices[1];

      if (_isDiagonal(firstIndex, secondIndex)) {
        selectionDirection = "diagonal";
      } else if (_isHorizontalOrVertical(firstIndex, secondIndex)) {
        int row1 = firstIndex ~/ widget.gridSize;
        int row2 = secondIndex ~/ widget.gridSize;
        selectionDirection = row1 == row2 ? "horizontal" : "vertical";
      }
    }
  }

  void _handleTap(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
        lastTappedIndex =
            selectedIndices.isNotEmpty ? selectedIndices.last : null;
        if (selectedIndices.length < 2) {
          selectionDirection = null;
        }
      } else if (_canSelectIndex(index)) {
        selectedIndices.add(index);
        lastTappedIndex = index;

        if (selectedIndices.length == 2) {
          _determineSelectionDirection();
        }
      }

      widget.onWordSelected(selectedIndices);
    });
  }

//?! drag need to be properly managed what we can do is we take initial and final position to determine word selected
  void _handleDragUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(details.globalPosition);
    double gridItemSize = box.size.width / widget.gridSize;
    int column = (localPosition.dx / gridItemSize).floor();
    int row = (localPosition.dy / gridItemSize).floor();
    int index = row * widget.gridSize + column;

    if (index != lastTappedIndex &&
        index >= 0 &&
        index < widget.gridSize * widget.gridSize &&
        _canSelectIndex(index)) {
      _handleTap(index);
    }
  }

  void _clearSelection() {
    setState(() {
      selectedIndices.clear();
      lastTappedIndex = null;
      selectionDirection = null;
    });
    widget.onWordSelected(selectedIndices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: _handleDragUpdate,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.gridSize,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: widget.gridSize * widget.gridSize,
          itemBuilder: (context, index) {
            bool isSelected = selectedIndices.contains(index);
            bool isCorrect = widget.correctIndices.contains(index);
            return GestureDetector(
              onTap: () => _handleTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? const Color(0xFF00AACC)
                      : isSelected
                          ? Colors.blueAccent.withOpacity(0.7)
                          : Colors.white,
                  border: Border.all(
                    color: isCorrect
                        ? const Color(0xFF00AACC)
                        : isSelected
                            ? Colors.blueAccent
                            : Colors.grey.shade400,
                    width: isCorrect || isSelected ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Text(
                  widget.gridLetters[index],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? Colors.black
                        : isSelected
                            ? Colors.blueAccent
                            : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearSelection,
        backgroundColor: const Color(0xFF2B4C7E),
        tooltip: 'Clear Selection', // Dark Blue to match the theme
        child: const Icon(Icons.clear, color: Colors.white),
      ),
    );
  }
}
