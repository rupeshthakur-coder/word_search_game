import 'package:bloc/bloc.dart';
import 'package:myapp/grid_view/cubit/grid_view_cubit.dart';

class WordSearchCubit extends Cubit<WordSearchState> {
  WordSearchCubit() : super(const WordSearchState());

  void selectIndex(int index) {
    if (!state.correctIndices.contains(index)) {
      final newSelectedIndices = List<int>.from(state.selectedIndices);

      if (newSelectedIndices.contains(index)) {
        newSelectedIndices.remove(index);
      } else {
        newSelectedIndices.add(index);
      }

      emit(state.copyWith(selectedIndices: newSelectedIndices));
    }
  }

  void markCorrectSelection(List<int> indices) {
    final newCorrectIndices = Set<int>.from(state.correctIndices);
    final newCorrectWords = Set<List<int>>.from(state.correctWords);

    newCorrectIndices.addAll(indices);
    newCorrectWords.add(indices);

    emit(state.copyWith(
      correctIndices: newCorrectIndices,
      correctWords: newCorrectWords,
      selectedIndices: [],
    ));
  }

  void resetGame() {
    emit(const WordSearchState());
  }
}