import 'package:flutter/material.dart';

import 'components/view_zhebsa_of_day.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

/* //del later and replace with real data
  FavouritePage? get product => null;
  Object? get name => 'null';
  selectItem(FavouritePage product) {
    print(product.name);
  } */

  @override
  Widget build(BuildContext context) {
    // setPageTitle('Favourite Page', context);
    return Scaffold(
      body: ListView.builder(
        itemCount: 15,
        padding: const EdgeInsets.all(12),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2,
            child: SizedBox(
              width: double.infinity,
              child: ListTile(
                // leading: FlutterLogo(size: 56.0),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ZhebsaOfDayDetail(searchQuery: 'བཀབ་ནེ།'),
                  ),
                ),
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                ),
                // trailing: const Icon(Icons.more_vert),
                title: const Text(
                  'བཀབ་ནེ། ', //$index
                  /* textScaleFactor: screenWidth * 0.002, */
                ),
                subtitle: const Text(
                  'ང་གི་བཀབ་ནེ།',
                  /* textScaleFactor: screenWidth * 0.002, */
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                // tileColor: Colors.deepOrangeAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
