import 'dart:convert';
import 'dart:io';

import 'package:ollama/src/models/chat_message.dart';
import 'package:ollama/src/models/completion.dart';
import 'package:ollama/src/models/parameters.dart';

class Ollama {
  /// The base URL for the Ollama API.
  final Uri baseUrl;

  /// The HTTP client used to make requests.
  final HttpClient _client = HttpClient();

  /// Create a new Ollama client.
  ///
  /// If no address is provided, the default is `http://localhost:11434`.
  Ollama({Uri? baseUrl}) : baseUrl = baseUrl ?? Uri.http('localhost:11434');

  /// Generate a response for a given prompt with a provided model.
  ///
  /// This is a streaming endpoint, so will be a series of responses.
  /// The final response object will include statistics and additional
  /// data from the request.
  ///
  /// [prompt] is the prompt to use for the response.
  /// [model] is the model to use for the response.
  /// [images] is a list of image URLs to use for the response.
  /// [system] is the system to use for the response.
  /// [format] is the format to use for the response.
  /// [template] is the template to use for the response.
  /// [options] is the options to use for the response.
  /// [chunked] is whether the response should be streamed as it is generated.
  /// [raw] is useful when you want to define your own template.
  /// [context] is the context to use for the response.
  Stream<CompletionChunk> generate(
    String prompt, {
    required String model,
    List<String>? images,
    String? system,
    String? format,
    String? template,
    ModelOptions? options,
    // If true, the response will be streamed as it is generated.
    // If false, the response will be returned as a single chunk at the end.
    bool chunked = true,
    bool raw = false,
    List<int>? context,
  }) async* {
    final url = baseUrl.resolve('api/generate');

    // Open a POST request to a server and send the request body.
    final request = await _client.postUrl(url);

    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'prompt': prompt,
      'model': model,
      'system': system,
      'stream': chunked,
      'context': context,
      'format': format,
      'raw': raw,
      'images': images,
      'template': template,
      'options': options?.toJson(),
    }));

    final response = await request.close();

    await for (final chunk in response.transform(utf8.decoder)) {
      final json = jsonDecode(chunk);
      yield CompletionChunk.fromJson(json);
    }
  }

  /// Generate the next message in a chat with a provided model.
  ///
  /// This is a streaming endpoint, so there will be a series of responses.
  /// The final response object will include statistics and additional data from the request.
  ///
  /// [messages] is a list of [ChatMessage]s that have been sent so far.
  /// [model] is the model to use for the response.
  /// [format] is the format to use for the response.
  /// [template] is the template to use for the response.
  /// [options] is the options to use for the response.
  /// [chunked] is whether the response should be streamed as it is generated.
  Stream<CompletionChunk> chat(
    List<ChatMessage> messages, {
    required String model,
    String? format,
    String? template,
    ModelOptions? options,
    bool chunked = true,
  }) async* {
    final url = baseUrl.resolve('api/chat');

    // Open a POST request to a server and send the request body.
    final request = await _client.postUrl(url);

    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'messages': [for (final message in messages) message.toJson()],
      'model': model,
      'stream': chunked,
      'format': format,
      'template': template,
      'options': options?.toJson(),
    }));

    final response = await request.close();

    await for (final chunk in response.transform(utf8.decoder)) {
      final json = jsonDecode(chunk);
      yield CompletionChunk.fromJson(json);
    }
  }

  /// Generate embeddings from a model for a given prompt.
  ///
  /// Send a POST request to the /api/embeddings endpoint which returns a list of doubles representing
  /// the multi-dimensional word representations in the model's vocabulary.
  ///
  /// [prompt] is the text to generate embeddings for.
  /// [model] is the name of the model to generate embeddings.
  /// [options] (optional) is additional model parameters. See Modelfile documentation for details.
  ///
  /// Example:
  /// ```dart
  /// final client = Ollama();
  /// final embeddings = await client.embeddings(
  ///   'Here is an article about llamas...',
  ///   model: 'llama2'
  /// );
  /// print(embeddings);
  /// ```
  ///
  /// Returns a [Future] that completes with a list of doubles representing the generated embeddings.
  Future<List<double>> embeddings(String prompt,
      {required String model, ModelOptions? options}) async {
    final url = baseUrl.resolve('api/embeddings');

    // Open a POST request to a server and send the request body.
    final request = await _client.postUrl(url);

    request.headers.contentType = ContentType.json;
    request.write(jsonEncode({
      'model': model,
      'prompt': prompt,
      'options': options?.toJson(),
    }));

    final response = await request.close();

    final responseBody = await response.transform(utf8.decoder).join();
    final jsonResponse = jsonDecode(responseBody);

    List<double> embeddings = List<double>.from(jsonResponse['embedding']);

    return embeddings;
  }
}
