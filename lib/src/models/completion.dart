import 'package:ollama/src/models/message.dart';

/// Represents each chunk of the completion that is generated.
class CompletionChunk {
  final String? _text;
  final ChatMessage? message;
  final String model;
  final DateTime createdAt;
  final CompletionDetails? details;

  /// Constructor for [CompletionChunk].
  ///
  /// The parameters [model], [createdAt] are required.
  /// The parameters [text] and [message] are optional, but at least one of them must be provided.
  /// The parameter [details] is optional.
  CompletionChunk({
    required this.model,
    required this.createdAt,
    String? text,
    this.message,
    this.details,
  })  : assert(text != null || message != null),
        _text = text;

  /// The text of the completion chunk.
  ///
  /// If [text] is provided, it will be returned.
  /// Otherwise, the content of [message] will be returned.
  String get text => _text ?? message!.content;

  /// Factory constructor to create a [CompletionChunk] from JSON data.
  factory CompletionChunk.fromJson(Map<String, dynamic> json) {
    return CompletionChunk(
      model: json['model'],
      createdAt: DateTime.parse(json['created_at']),
      text: json['response'],
      message: json['message'] != null
          ? ChatMessage.fromJson(json['message'])
          : null,
      details: json['done'] ? CompletionDetails.fromJson(json) : null,
    );
  }

  @override
  String toString() => text;
}

/// Represents the detailed information provided once the response generation is complete.
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

  /// Constructor for [CompletionDetails], all parameters are optional.
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

  /// The number of tokens generated per second, calculated as `evalCount` / `evalDuration`.
  double? get speed {
    if (evalCount == null || evalDuration == null) return null;
    return evalCount! / evalDuration!.inSeconds;
  }

  /// Factory constructor to create a [CompletionDetails] from JSON data.
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
