import 'dart:convert';
import 'dart:io';

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
}
