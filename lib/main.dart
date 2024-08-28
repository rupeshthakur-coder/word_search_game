import 'package:flutter/material.dart';
import 'package:myapp/levels/levels.dart';

void main() {
  runApp(WordSearchApp());
}

class WordSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Search Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'DM Serif Display'),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search Game'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordSearchGame(difficulty: Difficulty.Easy),
                  ),
                );
              },
              child: Text('Play Easy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordSearchGame(difficulty: Difficulty.Medium),
                  ),
                );
              },
              child: Text('Play Medium'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordSearchGame(difficulty: Difficulty.Hard),
                  ),
                );
              },
              child: Text('Play Hard'),
            ),
          ],
        ),
      ),
    );
  }
}
