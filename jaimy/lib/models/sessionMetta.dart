
class SessionMetta {
  final String id;
  final String name;
  final String profile;
  final String sex;
  final int intDay;
  final int intMonth;
  final String day;
  final String month;
  final String metta;


  SessionMetta({this.id, this.name, this.profile, this.sex,  this.intDay, this.intMonth, this.day, this.month , this.metta});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = name;
    data["profile"] = profile;
    data["sex"] = sex;
    data["intDay"] = intDay;
    data["intMonth"] = intMonth;
    data["day"] = day;
    data["month"] = month;
    data["metta"] = metta;
    return data;
  }

}