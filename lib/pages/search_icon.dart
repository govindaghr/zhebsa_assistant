import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zhebsa_assistant/database/za_darabase.dart';
import 'package:zhebsa_assistant/pages/components/custom_search.dart';
import 'package:zhebsa_assistant/pages/components/view_zhebsa_of_day.dart';

class SearchIcon extends StatefulWidget {
  const SearchIcon({Key? key}) : super(key: key);

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  final DatabaseService _databaseService = DatabaseService();

  var allData = [];
  var searchHistory = [];

  @override
  void initState() {
    super.initState();
    _databaseService.populateSearch().then((data) {
      setState(() {
        allData = data;
        // searchHistory = allData;
      });
    });

    _databaseService.showFavourite().then((value) {
      setState(() {
        searchHistory = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => showSearch(
                      context: context,
                      delegate: CustomSearch(allData, searchHistory)),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 9.5, top: 1.6),
                        child: Icon(
                          Icons.search_sharp,
                          color: Colors.deepOrange,
                          size: 30.0,
                        ),
                      ),
                      Text(
                        "འཚོལ།/Search",
                        style: Theme.of(context).textTheme.bodyText2?.merge(
                              const TextStyle(
                                  color: Colors.deepOrange, fontSize: 16.0),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'wordOfTheDay'.tr,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ZhebsaOfDayDetail(searchQuery: 'བཀའ་སློབ།'),
                        ),
                      ),
                      // leading: Icon(Icons.album),
                      title: const Text('བཀའ་སློབ།'),
                      subtitle: const SelectableText(
                        'བླམ་གི་བཀའ་སློབ་གནངམ་ཨིན།',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
