class ModelOptions {
  /// Enable Mirostat sampling for controlling perplexity.
  /// 0 = disabled (default), 1 = Mirostat, 2 = Mirostat 2.0
  final int? mirostat;

  /// Influences how quickly the algorithm responds to feedback from the
  /// generated text. A lower learning rate will result in slower adjustments,
  /// while a higher learning rate will make the algorithm more responsive.
  /// Default: 0.1
  final double? mirostatEta;

  /// Controls the balance between coherence and diversity of the output.
  /// A lower value will result in more focused and coherent text. Default: 5.0
  final double? mirostatTau;

  /// Sets the size of the context window used to generate the next token.
  /// Default: 2048
  final int? numCtx;

  /// The number of GQA groups in the transformer layer.
  /// Required for some models, for example it is 8 for llama3:70b
  final int? numGqa;

  /// The number of layers to send to the GPU(s).
  /// On macOS it defaults to 1 to enable metal support, 0 to disable.
  final int? numGpu;

  /// Sets the number of threads to use during computation.
  /// By default, Ollama will detect this for optimal performance.
  /// It is recommended to set this value to the number of physical CPU cores
  /// your system has (as opposed to the logical number of cores).
  final int? numThread;

  /// Sets how far back for the model to look back to prevent repetition.
  /// Default: 64, 0 = disabled, -1 = numCtx
  final int? repeatLastN;

  /// Sets how strongly to penalize repetitions.
  /// A higher value (e.g., 1.5) will penalize repetitions more strongly,
  /// while a lower value (e.g., 0.9) will be more lenient. Default: 1.1
  final double? repeatPenalty;

  /// The temperature of the model.
  /// Increasing the temperature will make the model answer more creatively.
  /// Default: 0.8
  final double? temperature;

  /// Sets the random number seed to use for generation.
  /// Setting this to a specific number will make the model generate
  /// the same text for the same prompt. Default: 0
  final int? seed;

  /// Sets the stop sequences to use.
  /// When this pattern is encountered the LLM will stop generating text
  /// and return. Multiple stop patterns may be set by specifying
  /// multiple separate `stop` parameters in a modelfile.
  final String? stop;

  /// Tail free sampling is used to reduce the impact of less probable tokens
  /// from the output. A higher value (e.g., 2.0) will reduce the impact more,
  /// while a value of 1.0 disables this setting. default: 1
  final double? tfsZ;

  /// Maximum number of tokens to predict when generating text.
  /// Default: 128, -1 = infinite generation, -2 = fill context
  final int? numPredict;

  /// Reduces the probability of generating nonsense.
  /// A higher value (e.g. 100) will give more diverse answers,
  /// while a lower value (e.g. 10) will be more conservative. Default: 40
  final int? topK;

  /// Works together with top-k.
  /// A higher value (e.g., 0.95) will lead to more diverse text,
  /// while a lower value (e.g., 0.5) will generate more focused
  /// and conservative text. Default: 0.9
  final double? topP;

  ModelOptions({
    this.mirostat,
    this.mirostatEta,
    this.mirostatTau,
    this.numCtx,
    this.numGqa,
    this.numGpu,
    this.numThread,
    this.repeatLastN,
    this.repeatPenalty,
    this.temperature,
    this.seed,
    this.stop,
    this.tfsZ,
    this.numPredict,
    this.topK,
    this.topP,
  });

  factory ModelOptions.fromJson(Map<String, dynamic> json) {
    return ModelOptions(
      mirostat: json['mirostat'],
      mirostatEta: json['mirostat_eta'],
      mirostatTau: json['mirostat_tau'],
      numCtx: json['num_ctx'],
      numGqa: json['num_gqa'],
      numGpu: json['num_gpu'],
      numThread: json['num_thread'],
      repeatLastN: json['repeat_last_n'],
      repeatPenalty: json['repeat_penalty'],
      temperature: json['temperature'],
      seed: json['seed'],
      stop: json['stop'],
      tfsZ: json['tfs_z'],
      numPredict: json['num_predict'],
      topK: json['top_k'],
      topP: json['top_p'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mirostat': mirostat,
      'mirostat_eta': mirostatEta,
      'mirostat_tau': mirostatTau,
      'num_ctx': numCtx,
      'num_gqa': numGqa,
      'num_gpu': numGpu,
      'num_thread': numThread,
      'repeat_last_n': repeatLastN,
      'repeat_penalty': repeatPenalty,
      'temperature': temperature,
      'seed': seed,
      'stop': stop,
      'tfs_z': tfsZ,
      'num_predict': numPredict,
      'top_k': topK,
      'top_p': topP,
    };
  }
}
