import 'dart:convert';
import 'dart:io';

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
    String? system,
    String? format,
    bool stream = true,
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
      'stream': stream,
      'context': context,
      'format': format,
    }));

    final response = await request.close();

    await for (final chunk in response.transform(utf8.decoder)) {
      final json = jsonDecode(chunk);
      yield CompletionChunk.fromJson(json);
    }
  }

  /// Ask a question and get a single response.
  ///
  /// This is a convenience method that will return the last response
  Future<CompletionChunk> ask(
    String prompt, {
    required String model,
    String? system,
    String? format,
    List<int>? context,
  }) async {
    final stream = generate(
      prompt,
      model: model,
      system: system,
      stream: false,
      context: context,
      format: format,
    );

    return await stream.last;
  }
}

class CompletionChunk {
  final String text;
  final String model;
  final DateTime createdAt;
  final CompletionDetails? details;

  CompletionChunk({
    required this.model,
    required this.createdAt,
    required this.text,
    this.details,
  });

  factory CompletionChunk.fromJson(Map<String, dynamic> json) {
    return CompletionChunk(
      model: json['model'],
      createdAt: DateTime.parse(json['created_at']),
      text: json['response'],
      details: json['done'] ? CompletionDetails.fromJson(json) : null,
    );
  }

  @override
  String toString() => text;
}

class CompletionDetails {
  final Duration? totalDuration;
  final Duration? loadDuration;
  final int? sampleCount;
  final Duration? sampleDuration;
  final int? promptEvalCount;
  final Duration? promptEvalDuration;
  final int? evalCount;
  final Duration? evalDuration;
  final List<int>? context;

  CompletionDetails({
    this.totalDuration,
    this.loadDuration,
    this.sampleCount,
    this.sampleDuration,
    this.promptEvalCount,
    this.promptEvalDuration,
    this.evalCount,
    this.evalDuration,
    this.context,
  });

  /// The number of tokens generated per second.
  double? get speed {
    if (evalCount == null || evalDuration == null) return null;
    return evalCount! / evalDuration!.inSeconds;
  }

  factory CompletionDetails.fromJson(Map<String, dynamic> json) {
    return CompletionDetails(
      totalDuration: json['total_duration'] != null
          ? Duration(microseconds: json['total_duration'])
          : null,
      loadDuration: json['load_duration'] != null
          ? Duration(microseconds: json['load_duration'])
          : null,
      sampleCount: json['sample_count'],
      sampleDuration: json['sample_duration'] != null
          ? Duration(microseconds: json['sample_duration'])
          : null,
      promptEvalCount: json['prompt_eval_count'],
      promptEvalDuration: json['prompt_eval_duration'] != null
          ? Duration(microseconds: json['prompt_eval_duration'])
          : null,
      evalCount: json['eval_count'],
      evalDuration: json['eval_duration'] != null
          ? Duration(microseconds: json['eval_duration'])
          : null,
      context: json['context'] != null ? List<int>.from(json['context']) : null,
    );
  }
}
