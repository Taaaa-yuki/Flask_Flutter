import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';

class FirebaseService {
  final CollectionReference _favoriteCollection = FirebaseFirestore.instance.collection('albums');

  Future<List<Album>> getAlbums() async {
    final snapshot = await _favoriteCollection.get();
    return snapshot.docs.map((doc) => Album.fromFirestore(doc)).toList();
  }

  Future<void> addAlbum(Album album) async {
    await _favoriteCollection.add(album.toFirestore());
  }

  Future<void> updateAlbum(Album album) async {
    await _favoriteCollection.doc(album.id).update(album.toFirestore());
  }

  Future<void> deleteAlbum(String albumId) async {
    await _favoriteCollection.doc(albumId).delete();
  }
}
