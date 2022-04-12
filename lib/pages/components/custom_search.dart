import 'package:flutter/material.dart';
import '../../model/dzongkha_zhebsa.dart';
import 'search_result.dart';

class CustomSearch extends SearchDelegate {
  List allData;
  List recentData;
  CustomSearch(
    this.allData,
    this.recentData, {
    String hintText = "འཚོལ།/Search",
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  // final DatabaseService _databaseService = DatabaseService();
  // SearchController searchController = Get.put(SearchController());

  /* Future<List> filterSeach(String query) async {
    var dummySearchList = allData;
    if (query.isNotEmpty) {
      var dummyListData = [];
      for (var recentData in dummySearchList) {
        var txtData = SearchDataModel.fromMap(recentData);
        if (txtData.sWord.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(recentData);
        }
      }
      recentData = [];
      recentData.addAll(dummyListData);
      return recentData;
    } else {
      recentData = [];
      recentData = allData;
      return recentData;
    }
  } */

  /* List allData = [
    'ཀ་ར་གཏང་།',
    'ཁ༌བཀོད།',
    'བཀའ་སློབ།',
    'ཁྲག',
    'སྐུ་ཁྲག',
    'བཀབ་ནེ།',
  ]; */
  /*  List recentData = [
    'བཀབ་ནེ།',
    'བཀའ་སློབ།',
    'ཁྲག',
    'སྐུ་ཁྲག',
  ]; */

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
          // stopPronunciation();
          SearchResults(searchQuery: "").stopPronunciation();
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
        // stopPronunciation();
        SearchResults(searchQuery: "").stopPronunciation();
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
    return SearchResults(searchQuery: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var dummySearchList = allData;
    if (query.isNotEmpty) {
      var dummyListData = [];
      for (var recentData in dummySearchList) {
        var txtData = SearchDataModel.fromMap(recentData);
        if (txtData.sWord.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(recentData);
        }
      }
      recentData = [];
      recentData.addAll(dummyListData);
    } else {
      recentData = [];
      recentData = allData;
    }
    return buildSuggestionsSuccess(recentData);
  }

  Widget buildSuggestionsSuccess(suggestionList) => ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          SearchDataModel txtData =
              SearchDataModel.fromMap(suggestionList[index]);
          // final String suggestion = txtData as String;
          // final queryText = suggestion.substring(0, query.length);
          // final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = txtData.sWord;
              showResults(context);
            },
            leading: const Icon(
              Icons.dangerous,
            ),
            title: RichText(
              text: TextSpan(
                text: txtData.sWord,
                style: const TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
                /* children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ], */
              ),
            ),
            // title: Text(suggestionList[index]),
          );
        },
      );
}
