class SessionHistory {
  final String id;
  final String url;
  final String title;
  final String artist;
  final String artwork;
  final String description;
  final int time;
  final String day;
  final int intDay;
  final int topicId;
  final String topicName;

  SessionHistory({this.id, this.url, this.title, this.artwork, this.artist, this.description, this.time, this.day, this.intDay, this.topicId, this.topicName});

  /*factory Musiclike.fromJson(Map<String, dynamic> json) {
    return Musiclike(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      artwork: json['artwork'],
      artist: json['artist'],
      description: json['description'],
    );
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["url"] = this.url;
    data["title"] = this.title;
    data["artist"] = this.artist;
    data["artwork"] = this.artwork;
    data["description"] = this.description;
    data["time"] = this.time;
    data["day"] = this.day;
    data["intDay"] = this.intDay;
    data["topicId"] = this.topicId;
    data["topicName"] = this.topicName;
    return data;
  }

}