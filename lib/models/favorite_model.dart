import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory Album.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Album(
      id: doc.id,
      title: data['title'],
      artist: data['artist'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
    };
  }
}
