class LyricsModel {
  String title;
  String artist;
  String body;

  LyricsModel({
    required this.title,
    required this.artist,
    required this.body
    });
    
    factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      artist: json['artist'],
      title: json['title'],
      body: json['body'],
    );
  }
}
