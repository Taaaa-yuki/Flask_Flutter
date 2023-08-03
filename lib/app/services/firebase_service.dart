import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lyrics_app/app/models/favorite_model.dart';

class FirebaseService {
  final CollectionReference _favoriteCollection = FirebaseFirestore.instance.collection('albums');

  Future<List<AlbumModel>> getAlbums() async {
    final QuerySnapshot snapshot = await _favoriteCollection.get();
    return snapshot.docs.map((doc) => AlbumModel.fromFirestore(doc)).toList();
  }

  Future<void> addAlbum(AlbumModel album) async {
    await _favoriteCollection.add(album.toFirestore());
  }

  Future<void> updateAlbum(AlbumModel album) async {
    await _favoriteCollection.doc(album.id).update(album.toFirestore());
  }

  Future<void> deleteAlbum(String albumId) async {
    await _favoriteCollection.doc(albumId).delete();
  }
}
