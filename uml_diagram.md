# Spanish Learning App

## Model: Flashcard Model

This section contains the UML diagram for the **Flashcard Model** used in the app. The model is responsible for handling the flashcard data, including the Spanish and English translations, options for multiple choice, and the correct answer.

### Flashcard Model UML Diagram (Mermaid Syntax)

```mermaid
classDiagram
    class Flashcard {
      +String spanish
      +String english
      +List<String> options
      +String correctOption
      +Flashcard(spanish: String, english: String, options: List<String>, correctOption: String)
    }
