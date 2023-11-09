# Ollama for Dart

This library provides an interface for interacting with Ollama, a tool that allows you to run LLMs (Large Language Models) locally. With this library, you can create an Ollama instance and use it to generate responses.

## Usage

If you want to generate response from a model, you can use the `ask` method. This method takes a prompt and a model name, and returns a `CompletionChunk` object.

```dart
import 'package:ollama/ollama.dart';

void main() async {
  // Create an Ollama instance
  final ollama = Ollama();

  // Generate a response from a model
  final response = await ollama.ask('Tell me about llamas', model: 'llama2');

  // Print the response
  print(response.text);
}
```

Stream responses can be generated using the `generate` method. This method takes a prompt and a model name, and returns a `Stream<CompletionChunk>`.

```dart
import 'package:ollama/ollama.dart';

void main() async {
  // Create an Ollama instance
  final ollama = Ollama();

  // Generate a response from a model
  final response = ollama.generate('Tell me about llamas', model: 'llama2');

  // Print the response
  await for (final chunk in response) {
    stdout.write(chunk.text);
  }
}
```