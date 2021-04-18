
class Week {
  final String weekIcon;
  final String weekName;
  final String weekDetail;
  final String weekImage;
  final String weekText;
  final String weekPlayId;
  final String weekPlayUrl;
  final String weekPlayTitle;
  final String weekPlayImage;
  final String weekPlayArtist;
  final String weekPlayAlbum;


  Week({this.weekIcon, this.weekName, this.weekDetail,
    this.weekImage, this.weekText, this.weekPlayId, this.weekPlayUrl,
    this.weekPlayTitle,
    this.weekPlayImage, this.weekPlayArtist, this.weekPlayAlbum});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["weekIcon"] = weekIcon;
    data["weekName"] = weekName;
    data["weekDetail"] = weekDetail;
    data["weekImage"] = weekImage;
    data["weekText"] = weekText;
    data["weekPlayId"] = weekPlayId;
    data["weekPlayUrl"] = weekPlayUrl;
    data["weekPlayTitle"] = weekPlayTitle;
    data["weekPlayImage"] = weekPlayImage;
    data["weekPlayArtist"] = weekPlayArtist;
    data["weekPlayAlbum"] = weekPlayAlbum;
    return data;
  }

}