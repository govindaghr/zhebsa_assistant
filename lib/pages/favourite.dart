import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

//del later and replace with real data
  FavouritePage? get product => null;
  Object? get name => 'null';
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
              leading: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              ),
              // trailing: const Icon(Icons.more_vert),
              title: Text('འཆར་སྣང་། $index'),
              subtitle: const Text(
                  'རྫོང་ཁ་འདི་འབྲུག་མི་ག་ར་གི་བརྡ་དོན་སྤྲོད་ལེན་གྱི་སྐད་ཡིག་གཙོ་ཅན་ཅིག་སྦེ་བཟོ་ནི།'),
              // tileColor: Colors.deepOrangeAccent,
            ),
          );
        },
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
