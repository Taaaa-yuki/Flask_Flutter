class LyricsModel {
  String title;
  String artist;
  String body;
  String imageUrl;

  LyricsModel({
    required this.title,
    required this.artist,
    required this.body,
    required this.imageUrl
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      artist: json['artist'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['photo_url'],
    );
  }
}
