# Ollama for Dart

Ollama is a Dart library for facilitating local execution of Large Language Models (LLMs). Users can use the library to instantiate Ollama for response generation purposes.

# Features
- Generate completions for a given prompt or messages
- Generating vector embeddings

## Usage

After importing the Ollama library,

```dart
import 'package:ollama/ollama.dart';
```

you can instantiate Ollama with the following code:

```dart
var ollama = Ollama();
```

### Generate Completions

To generate completions for a given prompt, use the `generate` method:

```dart
final result = await ollama.generate(
  'What is the capital of France?', 
   model: 'base_model',
);
print(result);
```