import 'dart:convert';
import 'package:flutter/services.dart'; // For loading assets
import 'dart:math'; // For selecting random flashcards

class FlashcardModel {
  String selectedLevel = 'Easy'; // Default level
  List<Map<String, String>> flashcardsData = [];
  int completedFlashcards = 0;
  int correctFlashcards = 0;

  late Random random; // Random instance for selecting random flashcards

  // Constructor to initialize random
  FlashcardModel() {
    random = Random(); // Initialize Random
  }

  // Load flashcards data from the asset JSON file (for both mobile and web)
  Future<void> loadFlashcardsData() async {
    String filePath = 'assets/flashcards.json'; // Path to your assets
    try {
      // Use rootBundle to load the JSON file from the assets
      String content = await rootBundle.loadString(filePath);
      Map<String, dynamic> jsonData = jsonDecode(content);

      // Ensure we filter data based on the selected level
      flashcardsData = List<Map<String, String>>.from(
        jsonData[selectedLevel].map((x) => Map<String, String>.from(x)),
      );
      print("Flashcards data loaded for level: $selectedLevel");
    } catch (e) {
      print("Error loading flashcards data: $e");
    }
  }

  // Method to get a random flashcard
  Map<String, String> getRandomFlashcard() {
    if (flashcardsData.isEmpty) {
      return {'No Data': 'No flashcards available'};
    }
    return flashcardsData[random.nextInt(flashcardsData.length)];
  }

  // Save progress asynchronously
  Future<void> saveProgress(String name) async {
    // Placeholder: Use SharedPreferences or another method to store user progress
    print("Progress saved for $name.");
  }

  // Reset progress (used when clicking Reset)
  void resetProgress() {
    completedFlashcards = 0;
    correctFlashcards = 0;
  }

  // Set selected level for flashcards
  void setLevel(String level) {
    selectedLevel = level;
  }

  // Get the current progress
  String getProgress() {
    return "$correctFlashcards out of $flashcardsData.length correct";
  }
}
