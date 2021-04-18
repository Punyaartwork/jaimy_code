
class Tmusic {
  final int id;
  final String url;
  final String title;
  final String artist;
  final String artwork;
  final String description;


  Tmusic({this.id, this.url, this.title, this.artwork, this.artist, this.description});

  factory Tmusic.fromJson(Map<String, dynamic> json) {
    return Tmusic(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      artwork: json['artwork'],
      artist: json['artist'],
      description: json['description'],
    );
  }
}

