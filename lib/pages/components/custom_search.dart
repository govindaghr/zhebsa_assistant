import 'package:flutter/material.dart';

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
    return Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_city, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
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
