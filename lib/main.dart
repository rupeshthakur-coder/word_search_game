import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/grid_view/cubit/grid_view_state.dart';

import 'package:myapp/levels/levels_selection_page.dart'; 
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
      home: BlocProvider(
        create: (_) => WordSearchCubit(),
        child: HomeScreen(),
      ),
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
      body: BlocProvider(
        create: (_) => WordSearchCubit(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelSelectionPage(),
                    ),
                  );
                },
                child: Text('Select Level'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
