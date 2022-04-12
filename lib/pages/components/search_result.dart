import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  final String searchQuery;
  const SearchResults({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  static bool isPlayingPronunciation = false;
  static AudioPlayer audioPlayer = AudioPlayer();

  final audioCache =
      AudioCache(prefix: 'assets/audio/', fixedPlayer: audioPlayer);

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

  @override
  void dispose() {
    stopPronunciation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
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
                  widget.searchQuery,
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
                const Expanded(
                  child: ListTile(
                    title: Text('ཞེ་ས།'),
                    subtitle: Text('ཐུགས་འགན།'), //ཞེ་སའི་ཚིག
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
              child: const ListTile(
                title: Text('དཔེར་བརྗོད།'),
                subtitle: SelectableText('བླམ་གི་ཐུགས་འགན་ཨིན་མས།'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
