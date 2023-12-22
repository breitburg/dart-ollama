import 'dart:io';

import 'package:ollama/ollama.dart';
import 'package:ollama/src/models/chat_message.dart';

void main() async {
  // Create an Ollama instance
  final ollama = Ollama();

  // Generate a response from a model
  final response = ollama.chat([
    ChatMessage(role: 'assistant', content: 'Hi!'),
    ChatMessage(role: 'user', content: 'How are you?'),
    ChatMessage(role: 'assistant', content: 'I am fine, thanks.'),
    ChatMessage(role: 'user', content: 'That\'s good to hear!'),
  ], model: 'llama2');

  // Print the response
  await for (final chunk in response) {
    print(chunk.text);
  }
}
