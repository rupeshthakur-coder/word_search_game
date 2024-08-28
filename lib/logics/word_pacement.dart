import 'dart:math';

class WordSearchLogic {
  final int gridSize;
  final List<String> words;
  List<String> grid;

  WordSearchLogic({required this.gridSize, required this.words})
      : grid = List.filled(gridSize * gridSize, '') {
    _placeWords();
    _fillEmptyCells();
  }

  void _placeWords() {
    final rand = Random();
    for (var word in words) {
      bool placed = false;

      while (!placed) {
        // Random starting position
        int startX = rand.nextInt(gridSize);
        int startY = rand.nextInt(gridSize);

        // Random direction (0: horizontal, 1: vertical, 2: diagonal)
        int direction = rand.nextInt(3);

        // Calculate the ending position
        int endX = startX;
        int endY = startY;

        switch (direction) {
          case 0: // Horizontal
            endX = startX + word.length - 1;
            break;
          case 1: // Vertical
            endY = startY + word.length - 1;
            break;
          case 2: // Diagonal
            endX = startX + word.length - 1;
            endY = startY + word.length - 1;
            break;
        }

        // Check if the word fits in the grid
        if (endX < gridSize && endY < gridSize) {
          // Check for overlap
          bool canPlace = true;
          for (int i = 0; i < word.length; i++) {
            int x = startX + (direction == 0 || direction == 2 ? i : 0);
            int y = startY + (direction == 1 || direction == 2 ? i : 0);
            int index = y * gridSize + x;

            if (grid[index].isNotEmpty && grid[index] != word[i]) {
              canPlace = false;
              break;
            }
          }

          // Place the word if possible
          if (canPlace) {
            for (int i = 0; i < word.length; i++) {
              int x = startX + (direction == 0 || direction == 2 ? i : 0);
              int y = startY + (direction == 1 || direction == 2 ? i : 0);
              int index = y * gridSize + x;

              grid[index] = word[i];
            }
            placed = true;
          }
        }
      }
    }
  }

  void _fillEmptyCells() {
    final rand = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (var i = 0; i < grid.length; i++) {
      if (grid[i].isEmpty) {
        grid[i] = letters[rand.nextInt(letters.length)];
      }
    }
  }
}
