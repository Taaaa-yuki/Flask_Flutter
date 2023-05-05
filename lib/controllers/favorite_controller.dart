import 'package:lyrics_app/models/favorite_model.dart';

class FavoriteController {
  static Future<List<Album>> getFavoriteAlbums() async {
    final favoriteAlbums = [
      Album(
        title: 'Superstar',
        artist: 'Backnumber',
        imageUrl: 'https://m.media-amazon.com/images/I/81g76UaKwBL._AC_SX679_.jpg',
      ),
      Album(
        title: 'RADWIMPS 4〜おかずのごはん〜',
        artist: 'RADWIMPS',
        imageUrl: 'https://m.media-amazon.com/images/I/513EQvSc86L._AC_.jpg',
      ),
      Album(
        title: '楓',
        artist: 'スピッツ',
        imageUrl: 'https://m.media-amazon.com/images/I/51PfS0wxjtL._AC_.jpg',
      ),
      Album(
        title: 'キュン',
        artist: '日向坂46',
        imageUrl: 'https://m.media-amazon.com/images/I/717OxeiAoPL._AC_UL320_.jpg',
      ),
      Album(
        title: 'シンクロニシティ',
        artist: '乃木坂46',
        imageUrl: 'https://m.media-amazon.com/images/I/81OpmuY0R1L._AC_UL320_.jpg',
      ),
      Album(
        title: 'インフルエンサー',
        artist: '乃木坂46',
        imageUrl: 'https://m.media-amazon.com/images/I/81ZzTB6LZUL._AC_UL320_.jpg',
      ),
    ];
    return favoriteAlbums;
  }
}
