class Dzongkha {
  final int dId;
  final String dWord;
  final String? dPhrase;
  final String? dHistory;
  final String? dFavourite; //timestamp,
  final String dUpdateTime;

  Dzongkha({
    required this.dId,
    required this.dWord,
    this.dPhrase,
    this.dHistory,
    this.dFavourite,
    required this.dUpdateTime,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'dId': dId,
      'dWord': dWord,
      'dPhrase': dPhrase,
      'dHistory': dHistory,
      'dFavourite': dFavourite,
      'dUpdateTime': dUpdateTime,
    };
  }

  factory Dzongkha.fromMap(Map<String, dynamic> map) {
    return Dzongkha(
      dId: map['dId']?.toInt() ?? 0,
      dWord: map['dWord'] ?? '',
      dPhrase: map['dPhrase'] ?? '',
      dHistory: map['dHistory'] ?? '',
      dFavourite: map['dFavourite'] ?? '',
      dUpdateTime: map['dUpdateTime'] ?? '',
    );
  }
}
