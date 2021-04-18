
class Online {
  final String id;
  final String name;
  final String profile;
  final String sex;
  final String age;
  final int intExp;
  final int intMinute;
  final int intKnow;
  final int intRelex;
  final int intWave;
  final int intMeditate;
  final int time;
  final String detail;
  final int intJai;
  final String userId;
  final String tokenId;

  Online({this.id, this.name, this.profile, this.sex, this.age, this.intExp, this.intMinute,this.intKnow, this.intRelex, this.intWave, this.intMeditate,this.time,this.detail,this.intJai,this.userId,this.tokenId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
      'sex': sex,
      'age': age,
      'intExp': intExp,
      'intMinute': intMinute,
      'intKnow': intKnow,
      'intRelex': intRelex,
      'intWave': intWave,
      'intMeditate': intMeditate,
      'time': time,
      'detail': detail,
      'intJai': intJai,
      'userId':userId,
      'tokenId':tokenId
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Online{id: $id, name: $name, age: $age, profile: $profile, sex: $sex, age: $age, intExp: $intExp, intMinute: $intMinute, intKnow: $intKnow, intRelex: $intRelex, intWave: $intWave, intMeditate: $intMeditate, time: $time, detail: $detail, intJai: $intJai, userId: $userId, tokenId: $tokenId}';
  }
}
