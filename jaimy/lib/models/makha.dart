

class Makha {
  final String id;
  final String name;
  final String profile;
  final String sex;
  final int rankDay;
  final int rankMonth;
  final int intDay;
  final int intMonth;
  final String day;
  final String month;
  final String time;
  final String detail;
  final int intJai;
  final String userId;
  final String tokenId;


  Makha({this.id, this.name, this.profile, this.sex, this.rankDay, this.rankMonth, this.intDay, this.intMonth, this.day, this.month, this.time, this.detail, this.intJai, this.userId, this.tokenId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = name;
    data["profile"] = profile;
    data["sex"] = sex;
    data["rankDay"] = rankDay;
    data["rankMonth"] = rankMonth;
    data["intDay"] = intDay;
    data["intMonth"] = intMonth;
    data["day"] = day;
    data["month"] = month;
    data["time"] = time;
    data["detail"] = detail;
    data["intJai"] = intJai;
    data["userId"] = userId;
    data["userId"] = userId;
    data["tokenId"] = tokenId;
    return data;
  }

}

