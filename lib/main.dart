import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:myapp/levels/levels_selection_page.dart';

void main() {
  runApp(const WordSearchApp());
}

class WordSearchApp extends StatelessWidget {
  const WordSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Search Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'DM Serif Display'),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  final List<int> _highlightedIndices = [];
  final List<String> _gridLetters = List<String>.filled(49, '');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Speed up the animation
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Populate the grid with letters
    _generateGrid();

    // Sequences of highlighted words, adjusted to the grid and context
    List<List<int>> sequences = [
      [0, 1, 2], // CAN
      [7, 8, 9], // YOU
      [14, 15, 16, 17, 18, 19, 20], // SEARCH
      [21, 22, 23, 24, 25], // WORDS
      [28, 29], // IF
      [35, 36, 37], // YES
      [6, 13, 20, 27], // THEN (Diagonal)
      [8, 15, 22, 29], // LETS (Vertical)
      [28, 21, 14, 7], // PLAY (Diagonal)
    ];

    int currentSequence = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        // Highlight the entire word sequence
        _highlightedIndices.clear();
        _highlightedIndices.addAll(sequences[currentSequence]);
        _controller.forward(from: 0);

        // Move to the next word
        currentSequence = (currentSequence + 1) % sequences.length;
      });
    });
  }

  void _generateGrid() {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//?! there is bug that highlighted text is showing random text than the actual text
    // Define words to be placed
    final List<WordPlacement> words = [
      WordPlacement(
          word: 'CAN', positions: [0, 1, 2], direction: Direction.horizontal),
      WordPlacement(
          word: 'YOU', positions: [7, 8, 9], direction: Direction.horizontal),
      WordPlacement(
          word: 'SEARCH',
          positions: [14, 15, 16, 17, 18, 19, 20],
          direction: Direction.horizontal),
      WordPlacement(
          word: 'WORDS',
          positions: [21, 22, 23, 24, 25],
          direction: Direction.horizontal),
      WordPlacement(
          word: 'IF', positions: [28, 29], direction: Direction.horizontal),
      WordPlacement(
          word: 'YES',
          positions: [35, 36, 37],
          direction: Direction.horizontal),
      WordPlacement(
          word: 'THEN',
          positions: [6, 13, 20, 27],
          direction: Direction.diagonal),
      WordPlacement(
          word: 'LETS',
          positions: [8, 15, 22, 29],
          direction: Direction.vertical),
      WordPlacement(
          word: 'PLAY',
          positions: [28, 21, 14, 7],
          direction: Direction.diagonal),
    ];

    // Initialize grid with random letters
    Random random = Random();
    for (int i = 0; i < _gridLetters.length; i++) {
      _gridLetters[i] = alphabet[random.nextInt(alphabet.length)];
    }

    // Place each word in the grid
    for (var wordPlacement in words) {
      _placeWordInGrid(wordPlacement);
    }
  }

  void _placeWordInGrid(WordPlacement wordPlacement) {
    if (wordPlacement.positions.length != wordPlacement.word.length) {
      debugPrint(
          'Mismatch between word length and positions length for word ${wordPlacement.word}');
      return;
    }

    for (int i = 0; i < wordPlacement.positions.length; i++) {
      int index = wordPlacement.positions[i];
      if (index < 0 || index >= _gridLetters.length) {
        debugPrint('Invalid index $index for word ${wordPlacement.word}');
        return;
      }
      if (_gridLetters[index] == '' ||
          _gridLetters[index] == wordPlacement.word[i].toUpperCase()) {
        // Only set the letter if the position is empty or matches the intended letter
        _gridLetters[index] = wordPlacement.word[i].toUpperCase();
      } else {
        // This position already has a different letter
        debugPrint(
            'Conflicting letter at index $index for word ${wordPlacement.word}');
        return;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123456), // Adjusted to match the theme
        title: const Text(
          'Word Search Game',
          style: TextStyle(fontFamily: 'DM Serif Display', color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFDDEEFF), // Background adjusted to match theme
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350, // Adjust size for 7x7 grid
                height: 350, // Adjust size for 7x7 grid
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, // 7x7 grid
                      ),
                      itemCount: 49, // 7x7 grid
                      itemBuilder: (context, index) {
                        bool isHighlighted =
                            _highlightedIndices.contains(index);
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isHighlighted
                                ? const Color(0xFF00AACC)
                                    .withOpacity(_animation.value) // Cyan
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _gridLetters[index],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isHighlighted
                                    ? Colors.white // Highlighted text color
                                    : const Color(
                                        0xFF123456), // Text color matching theme
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 70),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF123456), // Button color matching theme
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectionPage(),
                    ),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'DM Serif Display',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordPlacement {
  final String word;
  final List<int> positions;
  final Direction direction;

  WordPlacement({
    required this.word,
    required this.positions,
    required this.direction,
  });
}

enum Direction {
  horizontal,
  vertical,
  diagonal,
}
