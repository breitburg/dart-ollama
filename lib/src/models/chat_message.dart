/// A ChatMessage class that represents a message in a chat.
///
/// A ChatMessage object can contain the following properties:
/// * `role`: the role of the message sender. It can be either system,
/// user, or assistant.
/// * `content`: the content of the message.
/// * `images` (optional): a list of images included in the message,
/// used primarily for multimodal models such as llava.
class ChatMessage {
  final String role;
  final String content;
  final List<String>? images;

  /// Creates a new instance of ChatMessage.
  ///
  /// The [role] and [content] are required parameters.
  /// The [images] parameter is optional.
  ChatMessage({required this.role, required this.content, this.images})
      : assert(['system', 'user', 'assistant'].contains(role));

  /// Creates a new instance of `ChatMessage` from a json object.
  ///
  /// The [json] parameter is a Map that contains the data for the new instance.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['content'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  /// Converts the `ChatMessage` instance into a json format.
  ///
  /// Returns a Map that represents the json structure of the `ChatMessage` instance.
  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content, 'images': images};
  }

  @override
  String toString() => '$role: \'$content\'';
}
