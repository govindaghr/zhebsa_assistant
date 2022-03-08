// import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_icon_controller.dart';
import 'package:zhebsa_assistant/pages/controllers/audio_icon_controller.dart';

class CustomSearch extends SearchDelegate {
  final allData = [
    'ཀ་ར་གཏང་།',
    'ཁ༌བཀོད།',
    'བཀའ་སློབ།',
    'ཁྲག',
    'སྐུ་ཁྲག',
  ];
  final recentData = [
    'བཀའ་སློབ།',
    'ཁྲག',
    'སྐུ་ཁྲག',
  ];

  CustomSearch({
    String hintText = "འཚོལ།",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  //adding getx controller
  IconController controller = Get.put(IconController());

  // add it to your class as a static member
  // static AudioCache player = AudioCache();
  // or as a local variable
  // final player = AudioCache();
  bool isPlayingPronunciation = false;
  static AudioPlayer audioPlayer = AudioPlayer();
  final audioCache =
      AudioCache(prefix: 'assets/audio/', fixedPlayer: audioPlayer);

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

  _pausePronunciation() async {
    await audioPlayer.pause();
  }

  _stopPronunciation() async {
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
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
    super.dispose();
  } */

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // final InputDecorationTheme? searchFieldDecorationTheme;
    return theme.copyWith(
      dividerTheme: const DividerThemeData(
        color: Colors.white,
      ),
      // primaryIconTheme: const IconThemeData(color: Colors.white),

      scaffoldBackgroundColor: Colors.white, // for the body color
      // brightness: Brightness.dark,
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(
            // focusedBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: Colors.white),
            // ),
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ), // cursor color

      // primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      // primaryTextTheme: theme.textTheme,
      textTheme: Theme.of(context).textTheme.copyWith(
            headline6: const TextStyle(
              color: Colors.white,
              // fontSize: 20.0,
              decorationThickness: 0.0000001,
            ),
          ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      // icon: const Icon(Icons.arrow_back),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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
                  query,
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
                        _stopPronunciation();
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentData
        : allData.where((p) {
            final dataLower = p.toLowerCase();
            final queryLower = query.toLowerCase();
            return dataLower.startsWith(queryLower);
          }).toList();
    return buildSuggestionsSuccess(suggestionList);
  }

  Widget buildSuggestionsSuccess(List<String> suggestionList) =>
      ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          final suggestion = suggestionList[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(
              Icons.dangerous,
            ),
            title: RichText(
              text: TextSpan(
                  text: queryText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: const TextStyle(color: Colors.black45),
                    ),
                  ]),
            ),
            // title: Text(suggestionList[index]),
          );
        },
      );
}
