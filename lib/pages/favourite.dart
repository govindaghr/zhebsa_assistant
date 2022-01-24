import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // setPageTitle('Favourite Page', context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        transformAlignment: Alignment.topCenter,
        child: const Center(
          child: Text('FavouritePage Screen'),
        ),
      ),
    );
  }
}
