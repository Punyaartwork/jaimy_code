
class Topic {
  final int id;
  final int categoryId;
  final int lessonId;
  final String topicName;
  final String topicDetail;
  final String topicPhoto;
  final int topicTime;
  final int topicCount;
  final int topicView;
  final String topicColor;
  final String topicBg;


  Topic({this.id, this.categoryId, this.lessonId, this.topicName, this.topicDetail, this.topicPhoto, this.topicTime, this.topicCount, this.topicView, this.topicBg, this.topicColor});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
        id: json['id'],
        categoryId: json['categoryId'],
        lessonId: json['lessonId'],
        topicName: json['topicName'],
        topicDetail: json['topicDetail'],
        topicPhoto: json['topicPhoto'],
        topicTime: json['topicTime'],
        topicCount: json['topicCount'],
        topicView: json['topicView'],
        topicBg: json['topicBg'],
        topicColor: json['topicColor']
    );
  }

  @override
  String toString() {
    return 'Topic{id: $id, categoryId: $categoryId, lessonId: $lessonId, topicName: $topicName, topicDetail: $topicDetail, topicPhoto: $topicPhoto, topicTime:$topicTime, topicCount: $topicCount, topicBg: $topicBg, topicColor: $topicColor}';
  }
}
