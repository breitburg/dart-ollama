import 'dart:io';

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
