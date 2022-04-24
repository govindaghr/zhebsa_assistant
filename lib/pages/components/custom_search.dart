import 'package:flutter/material.dart';
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

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      dividerTheme: const DividerThemeData(
        color: Colors.white,
      ),

      scaffoldBackgroundColor: Colors.white,
      inputDecorationTheme: searchFieldDecorationTheme ??
          const InputDecorationTheme(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ), // cursor color

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
    final suggestionList = query.isEmpty
        ? recentData
        : allData.where((element) {
            return element.toLowerCase().contains(query.toLowerCase());
          }).toList();

    /* List suggestionList = [];
    if (query.isNotEmpty) {
      var dummyListData = [];
      for (var suggestionList in allData) {
        if (suggestionList.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(suggestionList);
        }
      }
      suggestionList = [];
      suggestionList.addAll(dummyListData);
    } else {
      suggestionList = [];
      suggestionList = recentData;
    } */
    return _buildSuggestionsSuccess(suggestionList);
  }

  _buildSuggestionsSuccess(suggestionList) => ListView.builder(
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
              Icons.history,
            ),
            title: RichText(
              text: TextSpan(
                text: suggestion,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          );

          /*  return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(
              Icons.history,
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
          ); */
        },
      );
}
