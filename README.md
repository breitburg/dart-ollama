Here's a README file for the Ollama library:

# Ollama for Dart

A Dart client for interacting with the Ollama API. This library provides an easy-to-use interface for generating text completions, chat responses, and embeddings using Ollama inference engine.

## Features

- Generate text completions
- Generate chat responses
- Generate embeddings
- Support for streaming responses
- Customizable model parameters

## Installation

Run the following command to install the package:

```bash
dart pub add ollama
```

## Usage

### Initializing the client

```dart
import 'package:ollama/ollama.dart';

final ollama = Ollama();
// Or with a custom base URL:
// final ollama = Ollama(baseUrl: Uri.parse('http://your-ollama-server:11434'));
```

### Generating text completions

```dart
final stream = ollama.generate(
  'Tell me a joke about programming',
  model: 'llama3',
);

await for (final chunk in stream) {
  print(chunk.response);
}
```

### Generating chat responses

```dart
final messages = [
  ChatMessage(role: 'user', content: 'Hello, how are you?'),
];

final stream = ollama.chat(
  messages,
  model: 'llama3',
);

await for (final chunk in stream) {
  print(chunk.message?.content);
}
```

### Generating embeddings

```dart
final embeddings = await ollama.embeddings(
  'Here is an article about llamas...',
  model: 'llama3',
);

print(embeddings);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
