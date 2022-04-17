import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:zhebsa_assistant/model/dzongkha.dart';
import 'package:zhebsa_assistant/model/dzongkha_zhebsa.dart';
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

  bool isFavourite = false;

  _setFaviurite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  List dzongkhaInput = [];
  List zhesaInput = [];
  List toZhebsaId = [];
  List zhesaID = [];
  List zhebsa = [];
  var did;
  var zid;
  // bool isZhesaSearch = true;

  @override
  void initState() {
    _dzongkhaText();
    _zhesaText();
    super.initState();
  }

  Future<void> _dzongkhaText() async {
    await _databaseService.searchDzongkha(sQuery).then((data) {
      // print(data);
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
      // did = (await _databaseService.searchDzoWord(sQuery));
      zhesaID.addAll(await _databaseService.getZhebsaSearchId(did));
      // print('zhebsa id: $zhesaID');
      // print('did $did');

//get data for zhesa
      zhebsa = (await _databaseService.getZhebsaSearch(zhesaID));
      // List zhebsa1 = (await _databaseService.showAllZhebsa1(zhesaID));
      print(zhebsa);

      for (var item in zhebsa) {
        print('item: ${item[0]["zWord"]}');
      }
    }
    /* await _databaseService.searchDzongkha(sQuery).then((data) {
      setState(() {
        dzongkhaInput = data;
        /* if (dzongkhaInput.isNotEmpty) {
          for (var dzId in dzongkhaInput) {
            var dzoId = Dzongkha.fromMap(dzId);
            // did.add(dzoId.dId);
            did = dzoId.dId;
            // isZhesaSearch = true;
          }
        } */
      });
    });
    if (dzongkhaInput.isNotEmpty) {
      /* await _databaseService.getZhebsaSearchId(did).then((data) {
        final List dummyListData = [];
        print(data);
        /* for (var element in data) {
          var zhData = DzongkhaZhebsa.fromMap(element).zhebsazId;
          dummyListData.add(zhData);
          print(dummyListData);
        } */
        for (int i = 0; i < data.length; i++) {
          dummyListData.add(data[i]['ZhebsazId']);
        }
        zhesaID.addAll(dummyListData);
        print(zhesaID);
      }); */

      /* did = (await _databaseService.searchDzoWord(sQuery));

      zhesaID.addAll(await _databaseService.getZhebsaSearchId(did));
      print('zhebsa id: $zhesaID');
      // getAllZhesa();

      print('did $did'); */
    } */
  }

  Future<void> _zhesaText() async {
    await _databaseService.searchZhesaWord(sQuery).then((value) {
      setState(() {
        zhesaInput = value;
        if (zhesaInput.isNotEmpty) {
          for (var zhId in zhesaInput) {
            var zheId = Zhebsa.fromMap(zhId);
            // zid.add(zheId.zId);
            zid = zheId.zId;
            // isZhesaSearch = false;
          }
          // print(zid);
        }
      });
    });
  }

  /* Future<List<Zhebsa>> _getZhebsa() async {
    // return await _databaseService.showAllZhebsa1(zhesaID);
    /* var zhebsaList = [];
    for (var zhid in zhesaID) {
      _databaseService.getData(zhid).then((value) {
        zhebsaList.add(value);
      });
    } */
    // return _databaseService.showAllZhebsa();
    return _databaseService.getData(zhesaID);
    // return zhebsaList;
  } */
/* Future<List<Zhebsa>> _getZhebsa() async {
    return await _databaseService.showAllZhebsa();
  } */
  /* checkId() {
    dzongkhaInput.isNotEmpty ? print('Dzongkha $did') : print('Zhesa $zid');
  } */

  Future<List<Zhebsa>> _getZhebsa() async {
    print(zhesaID);
    return await _databaseService.getZhebsaSearch(zhesaID);
  }

  @override
  void dispose() {
    stopPronunciation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // checkId();
    if (dzongkhaInput.isNotEmpty) {
      // return _displayDzongkha(dzongkhaInput);
      // return _displayZhesa(zhebsa);
      return _displayZhesa1();
    } else {
      return _displayZhesa(zhebsa);
    }
  }

  Widget _displayZhesa1() {
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
              itemCount: zhebsa.length,
              itemBuilder: (context, index) {
                // Zhebsa txtData = Zhebsa.fromMap(zhebsa[index]);
                final txtData = snapshot.data![index];
                return ListTile(
                  title: Text(txtData.zWord),
                );
              },
            );
          } else {
            return const Text('no data');
          }
        });
  }

  Widget _displayDzongkha(List dzongkhaInput) {
    return ListView.builder(
      itemCount: dzongkhaInput.length,
      itemBuilder: (context, index) {
        Dzongkha txtData = Dzongkha.fromMap(dzongkhaInput[index]);
        // print(txtData.dWord);
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
                      onPressed: () => _setFaviurite(),
                      icon: Icon(
                        isFavourite
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
                      subtitle: Text(txtData.dWord), //ཞེ་སའི་ཚིག
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        isPlayingPronunciation
                            ? stopPronunciation()
                            : _playPronunciation('aac_teenage_dream.mp3');
                        setState(() {
                          isPlayingPronunciation = !isPlayingPronunciation;
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
                  title: Text('དཔེར་བརྗོད།'),
                  subtitle: SelectableText('བླམ་གི་ཐུགས་འགན་ཨིན་མས།'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _displayZhesa(List zhebsa1) {
    return ListView.builder(
      itemCount: zhebsa1.length,
      itemBuilder: (context, index) {
        Zhebsa txtData = Zhebsa.fromMap(zhebsa1[index]);
        // print(txtData.zWord);
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
                      onPressed: () => _setFaviurite(),
                      icon: Icon(
                        isFavourite
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
                            : _playPronunciation('aac_teenage_dream.mp3');
                        setState(() {
                          isPlayingPronunciation = !isPlayingPronunciation;
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
                  title: Text('དཔེར་བརྗོད།'),
                  subtitle: SelectableText('${txtData.zPhrase}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
