import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/audio_icon_controller.dart';

class SearchResult extends StatefulWidget {
  final String searchQuery;
  const SearchResult({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchResult> createState() =>
      _SearchResultState(searchQuery: searchQuery);
}

class _SearchResultState extends State<SearchResult> {
  String searchQuery;

  _SearchResultState({required this.searchQuery});

  //adding getx controller
  final IconController controller = Get.put(IconController());

  static bool isPlayingPronunciation = false;
  static AudioPlayer audioPlayer = AudioPlayer();
  final audioCache =
      AudioCache(prefix: 'assets/audio/', fixedPlayer: audioPlayer);

  _playPronunciation(fineName) async {
    await audioCache.play(fineName, mode: PlayerMode.LOW_LATENCY);
    audioPlayer.state = PlayerState.PLAYING;
    controller.isPlaying.value = true;
    isPlayingPronunciation = true;
    /* 
      Check the functionality to update button back to stop 
      once the playing PlayerState.COMPLETED is completed
       */
    controller.update();
  }

  stopPronunciation() async {
    await audioPlayer.stop();
    // audioCache.clearAll();
    isPlayingPronunciation = false;
    audioPlayer.state = PlayerState.STOPPED;
    controller.isPlaying.value = false;
    controller.update();
  }

  // bool isFavourite = false;
  _setFaviurite() {
    controller.isFavourite.isTrue
        ? controller.isFavourite.value = false
        : controller.isFavourite.value = true;
    controller.update();
  }

  /* AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;
  String filePath = 'music.mp3'; 

   AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
   playLocal() async {
    int result = await audioPlayer.play('localPath', isLocal: true);
  }
  
  player.onPlayerCompletion.listen((event) {
    onComplete();
    setState(() {
      position = duration;
    });
  });
*/
  /* @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    // audioCache.clearAll();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        color: Colors.white70,
        shadowColor: Colors.amber[500],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
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
                  searchQuery,
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
                    icon: Obx(
                      () => Icon(
                        controller.isFavourite.isTrue
                            ? Icons.favorite_sharp
                            : Icons.favorite_border_sharp,
                        size: 30.0,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: ListTile(
                    title: Text('ཞེ་ས།'),
                    subtitle: Text('ཞེ་སའི་ཚིག'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      if (isPlayingPronunciation) {
                        stopPronunciation();
                      } else {
                        _playPronunciation('aac_teenage_dream.mp3');
                      }
                    },
                    icon: Obx(
                      () => Icon(
                        controller.isPlaying.isTrue
                            ? Icons.stop_circle_outlined
                            : Icons.volume_up,
                        size: 50.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 30.0),
              child: const ListTile(
                title: Text('དཔེར་བརྗོད།'),
                subtitle:
                    Text('རྫོང་ཁ་གོང་འཕེལ་ལྷན་ཚོགས་ཀྱི་རྫོང་ཁའི་ཚིག་མཛོད།'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
