import 'package:flutter/material.dart';
import 'package:zhebsa_assistant/database/za_darabase.dart';
import 'package:zhebsa_assistant/model/zhebsa.dart';

import '../database/za_darabase.dart';
import 'components/view_zhebsa_of_day.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Zhebsa>> _getZhebsa() async {
    return await _databaseService.showAllZhebsa();
  }

  // late Future<List<Zhebsa>> future;

  @override
  Widget build(BuildContext context) {
    /*  return Center(
      child: _buildFavourite(),
    ); */
    return FutureBuilder<List<Zhebsa>>(
      future: _getZhebsa(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // snapshot.hasError ? print(snapshot.error) : print('object');
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final zhesa = snapshot.data![index];
              return _buildFavourite(zhesa, context);
            },
          );
        } else {
          return const Text('no data');
        }
      },
    );
  }

  Widget _buildFavourite(Zhebsa zhesa, BuildContext context) {
    return Card(
      elevation: 2,
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          // leading: FlutterLogo(size: 56.0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ZhebsaOfDayDetail(searchQuery: zhesa.zWord),
            ),
          ),
          leading: const Icon(
            Icons.favorite,
            color: Colors.redAccent,
          ),
          // trailing: const Icon(Icons.more_vert),
          title: Text(
            zhesa.zWord,
            /* textScaleFactor: screenWidth * 0.002, */
          ),
          subtitle: Text(
            zhesa.zPhrase!,
            /* textScaleFactor: screenWidth * 0.002, */
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          // tileColor: Colors.deepOrangeAccent,
        ),
      ),
    );
  }
}
