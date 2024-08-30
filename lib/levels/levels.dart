import 'package:flutter/material.dart';
import 'package:myapp/grid_view/grid_view.dart';
import 'package:myapp/logics/word_pacement.dart';

// ignore: constant_identifier_names
enum Difficulty { Easy, Medium, Hard }

class WordSearchGame extends StatefulWidget {
  final Difficulty difficulty;
  final int level;

  const WordSearchGame(
      {super.key, required this.difficulty, required this.level});

  @override
  State<WordSearchGame> createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> {
  late WordSearchLogic wordSearchLogic;
  late int gridSize;
  late List<String> words;
  List<String> foundWords = [];
  List<int> selectedIndices = [];
  Set<int> correctIndices =
      {}; // To track indices of all correctly found letters

  final List<List<String>> easyWords = [
    ['CAT', 'DOG', 'BIRD'],
    ['SUN', 'MOON', 'STAR'],
    ['FISH', 'HEN', 'ANT'],
    ['BAT', 'RAT', 'MAT'],
    ['CUP', 'MUG', 'JUG'],
    ['CAR', 'BUS', 'VAN'],
    ['MAP', 'GAP', 'NAP'],
    ['PIN', 'BIN', 'TIN'],
    ['BEE', 'FLY', 'ANT'],
    ['POT', 'PAN', 'CAN'],
    ['BOOK', 'NOTE', 'PEN'],
    ['LEAF', 'TREE', 'ROOT'],
    ['EYE', 'EAR', 'LIP'],
    ['HAT', 'CAP', 'COAT'],
    ['CHAIR', 'DESK', 'TABLE'],
    ['LAMP', 'BULB', 'LIGHT'],
    ['FLOOR', 'WALL', 'ROOF'],
    ['MILK', 'JUICE', 'WATER'],
    ['SOAP', 'SHAMPOO', 'LOTION'],
    ['FORK', 'SPOON', 'KNIFE'],
  ];

  final List<List<String>> mediumWords = [
    ['ELEPHANT', 'GIRAFFE', 'KANGAROO'],
    ['MONKEY', 'TIGER', 'LEOPARD'],
    ['PENGUIN', 'OSTRICH', 'DOLPHIN'],
    ['CROCODILE', 'ALLIGATOR', 'HIPPO'],
    ['RHINO', 'BUFFALO', 'ANTELOPE'],
    ['ZEBRA', 'LION', 'CHEETAH'],
    ['PANDA', 'KOALA', 'LEMUR'],
    ['WHALE', 'SHARK', 'OCTOPUS'],
    ['FLAMINGO', 'PEACOCK', 'PARROT'],
    ['GORILLA', 'ORANGUTAN', 'CHIMP'],
    ['WOLF', 'FOX', 'JACKAL'],
    ['PYTHON', 'COBRA', 'VIPER'],
    ['RAVEN', 'CROW', 'SPARROW'],
    ['KITE', 'FALCON', 'EAGLE'],
    ['OTTER', 'BEAVER', 'RACCOON'],
    ['FERRET', 'MINK', 'WEASEL'],
    ['SNAKE', 'LIZARD', 'GECKO'],
    ['FROG', 'TOAD', 'NEWT'],
    ['BAT', 'MOLE', 'SHREW'],
    ['SALMON', 'TROUT', 'BASS'],
  ];

  final List<List<String>> hardWords = [
    ['HIPPOPOTAMUS', 'CHIMPANZEE', 'CROCODILE'],
    ['RHINOCEROS', 'ALLIGATOR', 'SQUIRREL'],
    ['ARMADILLO', 'WOODPECKER', 'PORCUPINE'],
    ['PLATYPUS', 'ECHIDNA', 'WOMBAT'],
    ['CASSOWARY', 'OSTRICH', 'EMU'],
    ['KOMODO', 'IGUANA', 'MONITOR'],
    ['MANATEE', 'DUGONG', 'NARWHAL'],
    ['QUOKKA', 'NUMBAT', 'QUOLL'],
    ['TAPIR', 'OKAPI', 'DHOLE'],
    ['MOLE', 'SHREW', 'VOLVOX'],
    ['RACCOON', 'BADGER', 'WOLVERINE'],
    ['GIRAFFE', 'ZEBRA', 'IMPALA'],
    ['ANACONDA', 'PYTHON', 'BOA'],
    ['LIZARD', 'SALAMANDER', 'GECKO'],
    ['OCTOPUS', 'CUTTLEFISH', 'SQUID'],
    ['MANTIS', 'LOCUST', 'GRASSHOPPER'],
    ['SCORPION', 'TARANTULA', 'CENTIPEDE'],
    ['HONEYBADGER', 'WOLVERINE', 'FERRET'],
    ['WALRUS', 'SEAL', 'SEA LION'],
    ['NARWHAL', 'BELUGA', 'ORCA'],
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize game settings based on difficulty and level
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
    String selectedWord =
        selectedIndices.map((index) => wordSearchLogic.grid[index]).join();

    if (words.contains(selectedWord) && !foundWords.contains(selectedWord)) {
      setState(() {
        foundWords.add(selectedWord); // Mark the word as found
        correctIndices
            .addAll(selectedIndices); // Store indices of the found word
        this.selectedIndices.clear(); // Clear selections for the next word
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Word Search - Level ${widget.level + 1}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B4C7E), // Dark Blue
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Words to Find:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B4C7E), // Dark Blue
              ),
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
                    color: isFound
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color(0xFF2B4C7E), // Dark Blue
                    decoration: isFound ? TextDecoration.lineThrough : null,
                  ),
                ),
                backgroundColor: isFound
                    ? const Color(0xFF2B4C7E)
                    : const Color(0xFFE3EDF7), // Light Blue
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: WordSearchGrid(
              gridSize: gridSize,
              gridLetters: wordSearchLogic.grid,
              correctIndices: correctIndices, // Pass correct indices to grid
              onWordSelected: (indices) {
                setState(() {
                  selectedIndices = indices;
                });
                _onWordSelected(indices);
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE3EDF7), // Light Blue Background
    );
  }
}
