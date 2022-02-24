import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

//del later and replace with real data
  FavouritePage? get product => null;
  Object? get name => null;
  void selectItem(FavouritePage product) {
    print(product.name);
  }

  @override
  Widget build(BuildContext context) {
    // setPageTitle('Favourite Page', context);
    return Scaffold(
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2,
            child: ListTile(
              // leading: FlutterLogo(size: 56.0),
              onTap: () => selectItem(product!),
              leading: Icon(Icons.list),
              trailing: Icon(Icons.more_vert),
              title: Text('Two-line ListTile'),
              subtitle: Text('Here is a second line'),
            ),
          );
        },
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
