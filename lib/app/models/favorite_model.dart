import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumModel {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;

  AlbumModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory AlbumModel.fromFirestore(DocumentSnapshot doc) {
    final firebaseData = doc.data() as Map<String, dynamic>;
    return AlbumModel(
      id: doc.id,
      title: firebaseData['title'],
      artist: firebaseData['artist'],
      imageUrl: firebaseData['imageUrl'],
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
