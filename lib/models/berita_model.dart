class Berita {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String thumbnailUrl;
  final DateTime publishedAt;
  final String? author;

  Berita({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.publishedAt,
    this.author,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'author': author,
    };
  }

  factory Berita.fromMap(Map<String, dynamic> data, String id) {
    return Berita(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      publishedAt: data['publishedAt'] != null 
          ? DateTime.parse(data['publishedAt']) 
          : DateTime.now(),
      author: data['author'],
    );
  }
}