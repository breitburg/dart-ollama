/// Represents each chunk of the completion that is generated.
class CompletionChunk {
  final String text;
  final String model;
  final DateTime createdAt;
  final CompletionDetails? details;

  /// Constructor for [CompletionChunk].
  ///
  /// The parameters [model], [createdAt], and [text] are required.
  /// The [details] parameter is only applicable when the response is completely generated
  /// (i.e., when `done` is true in the response JSON)
  CompletionChunk({
    required this.model,
    required this.createdAt,
    required this.text,
    this.details,
  });

  /// Factory constructor to create a [CompletionChunk] from JSON data.
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
