class NoteModel {
  final String id;
  final String title;
  final String content;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory NoteModel.fromMap(String id, Map<String, dynamic> map) {
    return NoteModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}