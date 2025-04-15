import 'flashcard.dart';

class FlashcardList {
  final List<Flashcard> _flashcards = [];

  List<Flashcard> get flashcards => _flashcards;

  void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
  }

  Flashcard getFlashcardAt(int index) => _flashcards[index];

  int get length => _flashcards.length;
}
