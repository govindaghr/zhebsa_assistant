class Zhebsa {
  // static final List<String> values = [zId, zWord, zPhrase];

  final int zId;
  final String zWord;
  final String? zPhrase;
  final String? zPronunciation;
  final String? zHistory;
  final String? zFavourite; //timestamp,
  final String? zUpdateTime;

  Zhebsa({
    required this.zId,
    required this.zWord,
    this.zPhrase,
    this.zPronunciation,
    this.zHistory,
    this.zFavourite,
    required this.zUpdateTime,
  });

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

  // Convert a Zhebsa into a Map. The keys must correspond to the names of the
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

  Map<String, dynamic> toMapFavourite() {
    return {
      'zId': zId,
      'zFavourite': zFavourite,
    };
  }
}

//ZhebsaWordOfDay Model
class ZhebsaWordOfDay {
  late final int wodID;
  late final String wodDay;
  ZhebsaWordOfDay({required this.wodID, required this.wodDay});

  factory ZhebsaWordOfDay.fromMap(Map<String, dynamic> map) {
    return ZhebsaWordOfDay(wodID: map['wodID'], wodDay: map['wodDay']);
  }

  Map<String, dynamic> toMap() {
    return {'wodID': wodID, 'wodDay': wodDay};
  }
}
