import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

//del later and replace with real data
  FavouritePage? get product => null;
  Object? get name => 'null';
  selectItem(FavouritePage product) {
    print(product.name);
  }

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
                onTap: () => selectItem(product!),
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                ),
                // trailing: const Icon(Icons.more_vert),
                title: Text(
                  'འཆར་སྣང་། $index',
                  /* textScaleFactor: screenWidth * 0.002, */
                ),
                subtitle: const Text(
                  'རྫོང་ཁ་འདི་འབྲུག་མི་ག་ར་གི་བརྡ་དོན་སྤྲོད་ལེན་གྱི་སྐད་ཡིག་གཙོ་ཅན་ཅིག་སྦེ་བཟོ་ནི།',
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
