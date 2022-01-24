import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // setPageTitle('Favourite Page', context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FavouritePage'),
      ),
      body: const Center(
        child: Text('FavouritePage Screen'),
      ),
    );
  }
}
