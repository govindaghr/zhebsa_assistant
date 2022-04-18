import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:zhebsa_assistant/model/dzongkha.dart';
import 'package:zhebsa_assistant/model/zhebsa.dart';

import '../../database/za_darabase.dart';

class SearchResults extends StatefulWidget {
  final String searchQuery;
  const SearchResults({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final DatabaseService _databaseService = DatabaseService();
  // final searchQuery = SearchResults(searchQuery: searchQuery);
  static bool isPlayingPronunciation = false;
  static AudioPlayer audioPlayer = AudioPlayer();

  final audioCache =
      AudioCache(prefix: 'assets/audio/', fixedPlayer: audioPlayer);

  String get sQuery => widget.searchQuery;

  _playPronunciation(fineName) async {
    await audioCache.play(fineName, mode: PlayerMode.LOW_LATENCY);

    audioPlayer.state = PlayerState.PLAYING;
  }

  stopPronunciation() async {
    await audioPlayer.stop();
    // audioCache.clearAll();
    isPlayingPronunciation = false;
    audioPlayer.state = PlayerState.STOPPED;
  }

  // bool isFavourite = false;
  late List<bool> isFavourite = [true, false];

  _setFaviurite(String? zFavourite, int index) async {
    print(zFavourite);
    print(index);
    setState(() {
      isFavourite[index] = !isFavourite[index];
    });
    /* if (zFavourite == null) {
      setState(() {
        isFavourite[index] = !isFavourite[index];
      });
    } else {
      setState(() {
        isFavourite[index] = !isFavourite[index];
      });
    } */
  }

  List dzongkhaInput = [];
  List zhesaInput = [];
  List toZhebsaId = [];
  List zhesaID = [];
  List dzongkhaID = [];
  List zhebsa = [];
  late int did;
  late int zid;
  // bool isZhesaSearch = true;

  @override
  void initState() {
    _zhesaText();
    _dzongkhaText();
    super.initState();
  }

  Future<void> _dzongkhaText() async {
    await _databaseService.searchDzongkha(sQuery).then((data) {
      setState(() {
        dzongkhaInput = data;
        if (dzongkhaInput.isNotEmpty) {
          for (var dzId in dzongkhaInput) {
            var dzoId = Dzongkha.fromMap(dzId);
            did = dzoId.dId;
          }
        }
      });
    });

    if (dzongkhaInput.isNotEmpty) {
      List zhID = [];
      await _databaseService.getZhebsaSearchId(did).then((value) {
        zhID.addAll(value);
        setState(() {
          zhesaID = zhID;
        });
      });
    }
  }

  Future<void> _zhesaText() async {
    await _databaseService.searchZhesaWord(sQuery).then((value) {
      setState(() {
        zhesaInput = value;
        if (zhesaInput.isNotEmpty) {
          for (var zhId in zhesaInput) {
            var zheId = Zhebsa.fromMap(zhId);
            zid = zheId.zId;
          }
        }
      });
    });

    if (zhesaInput.isNotEmpty) {
      List dzID = [];
      await _databaseService.getDzongkhaSearchId(zid).then((value) {
        dzID.addAll(value);
        setState(() {
          dzongkhaID = dzID;
        });
      });
    }
  }

  Future<List<Zhebsa>> _getZhebsa() async {
    return await _databaseService.getZhebsaSearch(zhesaID);
  }

  Future<List<Dzongkha>> _getDzongkha() async {
    return await _databaseService.getDzongkhaSearch(dzongkhaID);
  }

  @override
  void dispose() {
    stopPronunciation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dzongkhaInput.isNotEmpty) {
      return _displayZhesa();
    } else if (zhesaInput.isNotEmpty) {
      return _displayDzongkha();
    } else {
      return _displayDzongkha();
    }
  }

  Widget _displayZhesa() {
    return FutureBuilder<List<Zhebsa>>(
        future: _getZhebsa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final txtData = snapshot.data![index];
                /*  txtData.zFavourite == null
                    ? isFavourite[index] = false
                    : isFavourite[index] = true; */
                return Card(
                  elevation: 10,
                  color: Colors.white70,
                  shadowColor: Colors.amber[500],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange[400],
                          border: Border.all(
                            color: Colors.amber.shade100,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sQuery,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isFavourite[index] = !isFavourite[index];
                                });
                              },
                              /* () =>
                                  _setFaviurite(txtData.zFavourite, index), */
                              icon: Icon(
                                isFavourite[index]
                                    ? Icons.favorite_sharp
                                    : Icons.favorite_border_sharp,
                                size: 30.0,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('ཞེ་ས།'),
                              subtitle: Text(txtData.zWord), //ཞེ་སའི་ཚིག
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: IconButton(
                              onPressed: () {
                                isPlayingPronunciation
                                    ? stopPronunciation()
                                    : _playPronunciation(
                                        '${txtData.zPronunciation}');
                                setState(() {
                                  isPlayingPronunciation =
                                      !isPlayingPronunciation;
                                });
                              },
                              icon: Icon(
                                isPlayingPronunciation
                                    ? Icons.stop_circle_outlined
                                    : Icons.volume_up,
                                size: 50.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: ListTile(
                          title: const Text('དཔེར་བརྗོད།'),
                          subtitle: SelectableText('${txtData.zPhrase}'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('No Data');
          }
        });
  }

  Widget _displayDzongkha() {
    return FutureBuilder<List<Dzongkha>>(
        future: _getDzongkha(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final txtData = snapshot.data![index];
                return Card(
                  elevation: 10,
                  color: Colors.white70,
                  shadowColor: Colors.amber[500],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange[400],
                          border: Border.all(
                            color: Colors.amber.shade100,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sQuery,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Center(
                            child: IconButton(
                              onPressed: () =>
                                  _setFaviurite(txtData.dFavourite, index),
                              icon: Icon(
                                isFavourite.isEmpty
                                    ? Icons.favorite_sharp
                                    : Icons.favorite_border_sharp,
                                size: 30.0,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('ཕལ་སྐད།།'),
                              subtitle: Text(txtData.dWord), //ཞེ་སའི་ཚིག
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: ListTile(
                          title: const Text('དཔེར་བརྗོད།'),
                          subtitle: SelectableText('${txtData.dPhrase}'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('No Data');
          }
        });
  }
}
