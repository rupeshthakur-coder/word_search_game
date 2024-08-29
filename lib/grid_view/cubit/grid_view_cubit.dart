import 'package:equatable/equatable.dart';

class WordSearchState extends Equatable {
  final List<int> selectedIndices;
  final Set<int> correctIndices;
  final Set<List<int>> correctWords;

  const WordSearchState({
    this.selectedIndices = const [],
    this.correctIndices = const {},
    this.correctWords = const {},
  });

  WordSearchState copyWith({
    List<int>? selectedIndices,
    Set<int>? correctIndices,
    Set<List<int>>? correctWords,
  }) {
    return WordSearchState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
      correctIndices: correctIndices ?? this.correctIndices,
      correctWords: correctWords ?? this.correctWords,
    );
  }

  @override
  List<Object?> get props => [selectedIndices, correctIndices, correctWords];
}