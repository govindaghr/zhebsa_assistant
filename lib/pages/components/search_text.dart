import 'package:flutter/material.dart';

import '../../database/za_darabase.dart';
import '../../model/dzongkha_zhebsa.dart';

class SearchText extends StatefulWidget {
  const SearchText({Key? key}) : super(key: key);

  @override
  SearchTextState createState() => SearchTextState();
}

class SearchTextState extends State<SearchText> {
  final DatabaseService _databaseService = DatabaseService();

  TextEditingController teSeach = TextEditingController();
  var allData = [];
  var items = [];

  @override
  void initState() {
    super.initState();
    _databaseService.populateSearch().then((data) {
      setState(() {
        allData = data;
        items = allData;
        print(items);
      });
    });
  }

  void filterSeach(String query) async {
    var dummySearchList = allData;
    if (query.isNotEmpty) {
      var dummyListData = [];
      for (var item in dummySearchList) {
        var txtData = SearchDataModel.fromMap(item);
        if (txtData.sWord.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items = [];
        items = allData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: teSeach,
          onChanged: (value) {
            setState(() {
              filterSeach(value);
            });
          },
          decoration: InputDecoration(
            // fillColor: Colors.white,
            hintText: "འཚོལ།/Search",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                teSeach.text = '';
                // search(teSeach.text);
                filterSeach(teSeach.text);
              },
            ),
          ),
        ),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Text("List view search",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10), */
                  TextFormField(
                    controller: teSeach,
                    onChanged: (value) {
                      setState(() {
                        filterSeach(value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "འཚོལ།/Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          teSeach.text = '';
                          // search(teSeach.text);
                          filterSeach(teSeach.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _listView(items)
          ]),
    );
  }
}

Widget _listView(items) {
  return Expanded(
    child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          SearchDataModel txtData = SearchDataModel.fromMap(items[i]);
          return ListTile(
            leading: CircleAvatar(
              child: Text(txtData.sWord),
            ),
            title: Text(txtData.sWord),
          );
        }),
  );
}
