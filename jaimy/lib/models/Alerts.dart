class Alerts {
  final String alertUserId;
  final String alertPhoto;
  final String alertName;
  final String alertDetail;
  final int alertTime;

  Alerts({this.alertUserId,this.alertPhoto,this.alertName ,this.alertDetail, this.alertTime });

  factory Alerts.fromJson(Map<String, dynamic> json) {
    return Alerts(
      alertUserId: json['alertUserId'],
      alertPhoto: json['alertPhoto'],
      alertName: json['alertName'],
      alertDetail: json['alertDetail'],
      alertTime: json['alertTime'],
    );
  }

  @override
  String toString() {
    return 'Alerts{alertUserId: $alertUserId, alertPhoto: $alertPhoto, alertName: $alertName, alertDetail: $alertDetail, alertTime: $alertTime}';
  }
}
