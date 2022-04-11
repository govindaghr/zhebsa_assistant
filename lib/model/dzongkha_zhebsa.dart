import 'dart:convert';

class DzongkhaZhebsa {
  final int dzongkhadId;
  final int zhebsazId;
  // final int englisheId;
  final DateTime? updateTime;

  DzongkhaZhebsa({
    required this.dzongkhadId,
    required this.zhebsazId,
    this.updateTime,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'dzongkhadId': dzongkhadId,
      'zhebsazId': zhebsazId,
      'updateTime': updateTime?.toIso8601String(),
    };
  }

  factory DzongkhaZhebsa.fromMap(Map<String, dynamic> map) {
    return DzongkhaZhebsa(
      dzongkhadId: map['dzongkhadId']?.toInt() ?? 0,
      zhebsazId: map['zhebsazId']?.toInt() ?? 0,
      updateTime: map['updateTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DzongkhaZhebsa.fromJson(String source) =>
      DzongkhaZhebsa.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'DzongkhaZhebsa(dzongkhadId: $dzongkhadId, zhebsazId: $zhebsazId, updateTime: $updateTime)';
}
