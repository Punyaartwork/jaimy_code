
class Liker {
  final String likeId;
  final String userId;

  Liker({ this.likeId,this.userId});

  Map<String, dynamic> toMap() {
    return {
      'likeId':likeId,
      'userId':userId,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Liker{likeId: $likeId, userId: $userId}';
  }
}
