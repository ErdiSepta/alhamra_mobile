import 'package:cloud_firestore/cloud_firestore.dart';

class Berita {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String thumbnailUrl;
  final Timestamp publishedAt;
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
      'publishedAt': publishedAt,
      'author': author,
    };
  }

  factory Berita.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? data = doc.data();
    return Berita(
      id: doc.id,
      title: data?['title'] ?? '',
      content: data?['content'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
      thumbnailUrl: data?['thumbnailUrl'] ?? '',
      publishedAt: data?['publishedAt'] ?? Timestamp.now(),
      author: data?['author'],
    );
  }
}