# Spanish Learning App

This is a Flutter-based Spanish learning app that provides an interactive flashcard system. It allows users to view flashcards, choose answers, and receive feedback on whether they selected the correct answer.

## Model Overview

The model consists of two key classes:

### FlashcardModel:
- **FlashcardModel** is responsible for managing the flashcards, handling the selection of levels, and tracking user progress.

### Flashcard:
- **Flashcard** represents a single flashcard, containing a Spanish word, its English translation, possible options, and the correct answer.

## UML Diagram

Below is the UML diagram for the **FlashcardModel** class, represented in **Mermaid syntax**:

```mermaid
classDiagram
    class FlashcardModel {
        +String selectedLevel
        +List<Flashcard> flashcardsData
        +int completedFlashcards
        +int correctFlashcards
        +Random random
        +loadFlashcardData()
        +getRandomFlashcard()
        +saveProgress(name: String)
        +resetProgress()
        +setLevel(level: String)
        +getProgress(): String
    }

    class Flashcard {
        +String spanish
        +String english
        +List<String> options
        +String correctOption
        +Flashcard(spanish: String, english: String, options: List<String>, correctOption: String)
    }

    FlashcardModel "1" --> "many" Flashcard
