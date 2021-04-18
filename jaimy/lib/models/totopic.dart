
import 'package:JaiMy/models/tmusic.dart';

class toTopic {
  final String id;
  final String categoryId;
  final String lessonId;
  final String topicName;
  final String topicDetail;
  final String topicPhoto;
  final String topicTime;
  final String topicCount;
  final String topicView;
  final String topicColor;
  final String topicBg;
  List<Tmusic> audios;


  toTopic({this.id, this.categoryId, this.lessonId, this.topicName, this.topicDetail, this.topicPhoto, this.topicTime, this.topicCount, this.topicView, this.topicBg, this.topicColor, this.audios});

  factory toTopic.fromJson(Map<String, dynamic> json) {
    return toTopic(
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
        topicColor: json['topicColor'],
        audios: json['audios']
    );
  }

  @override
  String toString() {
    return 'toTopic{id: $id, categoryId: $categoryId, lessonId: $lessonId, topicName: $topicName, topicDetail: $topicDetail, topicPhoto: $topicPhoto, topicTime:$topicTime, topicCount: $topicCount, topicBg: $topicBg, topicColor: $topicColor, audios: $audios}';
  }
}
