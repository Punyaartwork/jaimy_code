class Canons {
  final int id;
  final String canonName;
  final String canon;

  Canons({this.id,this.canonName,this.canon });

  factory Canons.fromJson(Map<String, dynamic> json) {
    return Canons(
      id: json['id'],
      canonName: json['canonName'],
      canon: json['canon'],
    );
  }

  @override
  String toString() {
    return 'Canons{id: $id, canonName: $canonName, canon: $canon}';
  }
}
