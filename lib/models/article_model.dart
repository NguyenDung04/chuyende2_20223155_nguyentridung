class ArticleModel {
  final int id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  bool isFavorite;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    this.isFavorite = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;
    final String title = (json['title'] ?? '').toString();
    final String body = (json['body'] ?? '').toString();

    return ArticleModel(
      id: id,
      title: title,
      description: body.length > 80 ? '${body.substring(0, 80)}...' : body,
      content: body,
      imageUrl: 'https://picsum.photos/seed/news$id/600/400',
      publishedAt: DateTime.now().subtract(Duration(days: id)),
      isFavorite: false,
    );
  }
}