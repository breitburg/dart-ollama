import 'dart:io';

import 'package:ollama/ollama.dart';

void main() async {
  // Create an Ollama instance
  final ollama = Ollama();

  // Generate a response from a model
  final response = ollama.chat([
    ChatMessage(role: 'system', content: 'You are a helpful assistant.'),
    ChatMessage(role: 'user', content: 'How are you?'),
  ], model: 'llama3');

  // Print the response
  response.listen(stdout.write);
}
