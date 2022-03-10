import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/audio_icon_controller.dart';

class SearchResults extends StatelessWidget {
  final String searchQuery;
  SearchResults({Key? key, required this.searchQuery}) : super(key: key);

//adding getx controller
  final IconController controller = Get.put(IconController());

  // add it to your class as a static member
  // static AudioCache player = AudioCache();
  // or as a local variable
  // final player = AudioCache();
  static bool isPlayingPronunciation = false;
  static AudioPlayer audioPlayer = AudioPlayer();
  final audioCache =
      AudioCache(prefix: 'assets/audio/', fixedPlayer: audioPlayer);

  // static String get query => searchQuery;

  // AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;

  _playPronunciation(fineName) async {
    // audioCache.play(fineName, mode: PlayerMode.LOW_LATENCY);
    await audioCache.fixedPlayer!.stop();
    final file = await audioCache.loadAsFile(fineName);
    final bytes = await file.readAsBytes();
    await audioCache.playBytes(bytes);
    isPlayingPronunciation = true;
    audioPlayer.state = PlayerState.PLAYING;
    controller.isPlaying.value = true;
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

  /*  @override
  _pausePronunciation() async {
    await audioPlayer.pause();
  }

  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
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
                        _playPronunciation('teenage_dream.amr');
                      }
                    },
                    icon: Obx(
                      () => Icon(
                        controller.isPlaying.value
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
            /* Container(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                children: const <Widget>[
                  Text(
                    'དཔེར་བརྗོད།',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'རྫོང་ཁ་གོང་འཕེལ་ལྷན་ཚོགས་ཀྱི་རྫོང་ཁའི་ཚིག་མཛོད།',
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ), */
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
