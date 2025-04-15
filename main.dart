import 'package:flutter/material.dart';
import 'flashcard_list.dart'; // Import the FlashcardList
import 'flashcard.dart'; // Import the Flashcard class

void main() {
  runApp(const SpanishLearningApp());
}

class SpanishLearningApp extends StatelessWidget {
  const SpanishLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spanish Learning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  FlashcardList flashcardList = FlashcardList();
  int currentFlashcardIndex = 0;
  String selectedOption = '';
  String name = '';

  @override
  void initState() {
    super.initState();

    // Load hardcoded flashcards
    flashcardList.addFlashcard(
      Flashcard(
        spanish: 'Hola',
        english: 'Hello',
        options: ['Hello', 'Cat', 'Dog', 'Book'],
        correctOption: 'Hello',
      ),
    );
    flashcardList.addFlashcard(
      Flashcard(
        spanish: 'Gato',
        english: 'Cat',
        options: ['Hello', 'Cat', 'Dog', 'Table'],
        correctOption: 'Cat',
      ),
    );
    flashcardList.addFlashcard(
      Flashcard(
        spanish: 'Perro',
        english: 'Dog',
        options: ['Table', 'Book', 'Dog', 'Lamp'],
        correctOption: 'Dog',
      ),
    );
    flashcardList.addFlashcard(
      Flashcard(
        spanish: 'Mesa',
        english: 'Table',
        options: ['Lamp', 'Book', 'Table', 'Dog'],
        correctOption: 'Table',
      ),
    );
    flashcardList.addFlashcard(
      Flashcard(
        spanish: 'Libro',
        english: 'Book',
        options: ['Pen', 'Book', 'Table', 'Lamp'],
        correctOption: 'Book',
      ),
    );
  }

  void openFlashcardsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardPage(flashcardList: flashcardList),
      ),
    );
  }

  void resetProgress() {
    setState(() {
      _controller.clear();
      _controller.text = "Enter your name";
      name = '';
      selectedOption = '';
      currentFlashcardIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spanish Learning App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Spanish Learning App",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text("Enter your name:", style: TextStyle(fontSize: 18)),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onTap: () {
                if (_controller.text == "Enter your name") {
                  _controller.clear(); // Clears the textfield when clicked
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = _controller.text;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 8,
                ),
                textStyle: const TextStyle(fontSize: 14),
                minimumSize: const Size(
                  180,
                  40,
                ), // Smaller size for the "Select" button
              ),
              child: const Text("Select"),
            ),
            const SizedBox(height: 40),
            // Buttons for Flashcards, Quizzes, Grammar, Progress, Reset (same size)
            ElevatedButton(
              onPressed: () => openFlashcardsPage(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(200, 50), // Same size for all buttons
              ),
              child: const Text("Flashcards"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: resetProgress,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(200, 50), // Same size for all buttons
              ),
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardPage extends StatefulWidget {
  final FlashcardList flashcardList;
  const FlashcardPage({super.key, required this.flashcardList});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  late Flashcard currentFlashcard;
  String selectedOption = '';
  int currentIndex = 0;
  String feedback = '';

  @override
  void initState() {
    super.initState();
    currentFlashcard = widget.flashcardList.getFlashcardAt(currentIndex);
  }

  void nextFlashcard() {
    setState(() {
      if (currentIndex < widget.flashcardList.length - 1) {
        currentIndex++;
        currentFlashcard = widget.flashcardList.getFlashcardAt(currentIndex);
        selectedOption = ''; // Reset selected option for the next card
        feedback = ''; // Reset feedback for next card
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flashcard: ${currentFlashcard.spanish}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Display the answer options as buttons
            ...currentFlashcard.options.map((option) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedOption = option; // Set selected option
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor:
                      selectedOption == option
                          ? Colors.blue
                          : Colors.grey, // Highlight selected option
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(200, 50),
                ),
                child: Text(option),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show if the selected option is correct or not
                setState(() {
                  if (selectedOption == currentFlashcard.correctOption) {
                    feedback = 'Correct!';
                  } else {
                    feedback =
                        'Incorrect! Correct answer: ${currentFlashcard.correctOption}';
                  }
                });

                // Wait for a brief moment, then go to next card
                Future.delayed(const Duration(seconds: 2), () {
                  nextFlashcard();
                });
              },
              child: const Text("Select"),
            ),
            if (feedback.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: feedback == 'Correct!' ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
