

class Jaier {
  final String id;
  final String name;
  final String profile;
  final String sex;
  final bool isOpen;
  final String jai;
  final int intJai;
  final String day;
  final String month;
  final String time;


  Jaier({this.id, this.name, this.profile, this.sex, this.isOpen, this.jai, this.intJai, this.day, this.month, this.time});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = name;
    data["profile"] = profile;
    data["sex"] = sex;
    data["isOpen"] = isOpen;
    data["jai"] = jai;
    data["intJai"] = intJai;
    data["day"] = day;
    data["month"] = month;
    data["time"] = time;
    return data;
  }

}

