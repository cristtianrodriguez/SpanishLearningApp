import 'package:flutter/material.dart';
import 'model.dart'; // Import the model

void main() {
  runApp(SpanishLearningApp());
}

class SpanishLearningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spanish Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  FlashcardModel model = FlashcardModel(); // Instance of model

  @override
  void initState() {
    super.initState();
    model.loadFlashcardsData(); // Load flashcards when the app starts
  }

  // Function to navigate to the level selection screen
  void openLevelSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LevelSelectionScreen(
              onLevelChanged: (level) {
                setState(() {
                  model.setLevel(level);
                  model
                      .loadFlashcardsData(); // Reload flashcards for the selected level
                });

                // After selecting a level, navigate to Flashcards screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardsScreen(model: model),
                  ),
                );
              },
            ),
      ),
    );
  }

  // Function to show coming soon message
  void showComingSoonMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Coming Soon"),
          content: Text("This feature is soon to be developed."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to reset user progress
  void resetProgress() {
    setState(() {
      model.resetProgress();
      _controller.clear();
      _controller.text = "Enter your name";
    });
    print("Progress has been reset");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spanish Learning App")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Spanish Learning App",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text("Enter your name:", style: TextStyle(fontSize: 18)),
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String name = _controller.text;
                if (name.isNotEmpty && name != "Enter your name") {
                  await model.saveProgress(
                    name,
                  ); // Save progress using the model
                  print("Name entered: $name");
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                textStyle: TextStyle(fontSize: 14),
                minimumSize: Size(
                  180,
                  40,
                ), // Smaller size for the "Select" button
              ),
              child: Text("Select"),
            ),
            SizedBox(height: 40),
            // Buttons for Flashcards, Quizzes, Grammar, Progress, Reset (same size)
            _buildCommonButton("Flashcards", () => openLevelSelection(context)),
            SizedBox(height: 10),
            _buildCommonButton("Quizzes", showComingSoonMessage),
            SizedBox(height: 10),
            _buildCommonButton("Grammar", showComingSoonMessage),
            SizedBox(height: 10),
            _buildCommonButton("Progress", showComingSoonMessage),
            SizedBox(height: 40),
            // Reset button
            _buildCommonButton("Reset", resetProgress),
          ],
        ),
      ),
    );
  }

  // Common button builder function to ensure all buttons are the same size
  ElevatedButton _buildCommonButton(String text, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
        minimumSize: Size(200, 50), // Same size for all buttons
      ),
      child: Text(text),
    );
  }
}

class LevelSelectionScreen extends StatelessWidget {
  final Function(String) onLevelChanged;

  LevelSelectionScreen({required this.onLevelChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Difficulty Level")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select Difficulty Level",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              _buildLevelButton("Easy", context),
              SizedBox(height: 10),
              _buildLevelButton("Medium", context),
              SizedBox(height: 10),
              _buildLevelButton("Hard", context),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create the level buttons
  ElevatedButton _buildLevelButton(String level, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onLevelChanged(level);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: TextStyle(fontSize: 18),
        minimumSize: Size(200, 50),
      ),
      child: Text(level),
    );
  }
}

class FlashcardsScreen extends StatelessWidget {
  final FlashcardModel model;

  FlashcardsScreen({required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flashcards")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flashcards for ${model.selectedLevel} Level",
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, String> flashcard = model.getRandomFlashcard();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(flashcard.keys.first),
                      content: Text(flashcard.values.first),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Show Random Flashcard"),
            ),
          ],
        ),
      ),
    );
  }
}
