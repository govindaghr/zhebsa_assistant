import 'dart:convert';

class Zhebsa {
  final int zId;
  final String zWord;
  final String? zPhrase;
  final String? zPronunciation;
  final String? zHistory;
  final String? zFavourite; //timestamp,
  final DateTime? zUpdateTime;

  Zhebsa({
    required this.zId,
    required this.zWord,
    this.zPhrase,
    this.zPronunciation,
    this.zHistory,
    this.zFavourite,
    this.zUpdateTime,
  });

  // Convert a Breed into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'zId': zId,
      'zWord': zWord,
      'zPhrase': zPhrase,
      'zPronunciation': zPronunciation,
      'zHistory': zHistory,
      'zFavourite': zFavourite,
      'zUpdateTime': zUpdateTime,
    };
  }

  factory Zhebsa.fromMap(Map<String, dynamic> map) {
    return Zhebsa(
      zId: map['zId']?.toInt() ?? 0,
      zWord: map['zWord'] ?? '',
      zPhrase: map['zPhrase'] ?? '',
      zPronunciation: map['zPronunciation'] ?? '',
      zHistory: map['zHistory'] ?? '',
      zFavourite: map['zFavourite'] ?? '',
      zUpdateTime: map['zUpdateTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Zhebsa.fromJson(String source) => Zhebsa.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each breed when using the print statement.
  @override
  String toString() =>
      'Zhebsa(zId: $zId, zWord: $zWord, zPhrase: $zPhrase, zPronunciation:$zPronunciation, zHistory: $zHistory, zFavourite: $zFavourite, zUpdateTime: $zUpdateTime)';
}
