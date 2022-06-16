import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zhebsa_assistant/database/za_darabase.dart';
import 'package:zhebsa_assistant/model/dzongkha.dart';
import 'package:zhebsa_assistant/model/dzongkha_zhebsa.dart';
import 'package:zhebsa_assistant/model/zhebsa.dart';
// import 'package:permission_handler/permission_handler.dart';

class ZhesaAPIProvider {
  // Response response;
  var dio = Dio();
  static final DatabaseService _databaseService = DatabaseService();

  // get context => null;

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/assets/audio/$uniqueFileName';
    return path;
  }

  Future downloadFile(audio, fileName) async {
    try {
      Dio dio = Dio();
      var savePath = await getFilePath(fileName);
      await dio.download(audio, savePath);
      /* showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(fileName),
          );
        },
      ); */
      // print(fileName);
      // print(savePath);

    } catch (e) {
      // print(e.toString());

    }
  }

  // requests storage permission
  /*  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  } */

  Future<void> getAllZhesa() async {
    final db = await _databaseService.database;
    var url = "http://zhebsa.herokuapp.com/webapp/zhebsa";
    Response response = await dio.get(url);
    if (response.statusCode == 200) {
      var zhesa = response.data;
      for (int i = 0; i < zhesa.length; i++) {
        var pubdate = zhesa[i]['publish_date'];
        var zhesaID = zhesa[i]['id'];
        var zWord = zhesa[i]['zhebsa_word'];
        var zPhrase = zhesa[i]['z_phrase'];
        var audio = zhesa[i]['audio'];

        String pronunciation = audio.substring(audio.lastIndexOf("/") + 1);

        var zhesaList = await db
            .query('Zhebsa', where: 'zID = ?', whereArgs: [zhesa[i]['id']]);
        // print(zhesaList[i]['zUpdateTime']);
        if (zhesaList.isNotEmpty) {
          var zhesaSame = await db.query('Zhebsa',
              where: 'zID = ? AND zUpdateTime = ?',
              whereArgs: ['$zhesaID', '$pubdate']);
          if (zhesaSame.isEmpty) {
            downloadFile(audio, pronunciation);
            await db.rawUpdate(
                'UPDATE Zhebsa SET zWord = ?, zPhrase = ?, zUpdateTime = ?, zPronunciation = ? WHERE zId = ?',
                [zWord, zPhrase, pubdate, pronunciation, zhesaID]);
            // print('update $zhesaList');
          }
        } else {
          // print('Insert data $zhesaID');
          downloadFile(audio, pronunciation);
          Zhebsa zhebsa = Zhebsa(
              zId: zhesaID,
              zWord: zWord,
              zPhrase: zPhrase,
              zPronunciation: pronunciation,
              zUpdateTime: pubdate);
          _databaseService.insertZhebsa(zhebsa);
        }
      }
    } else {
      /* ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error! Check your Internet Connection'),
        ),
      ); */
    }
  }

  Future<void> getAllDzongkha() async {
    final db = await _databaseService.database;
    var purl = "http://zhebsa.herokuapp.com/webapp/phelkay";
    Response responsep = await dio.get(purl);
    if (responsep.statusCode == 200) {
      var phelkay = responsep.data;
      for (int i = 0; i < phelkay.length; i++) {
        var publishDate = phelkay[i]['publish_date'];
        var phalkayID = phelkay[i]['id'];
        var phelkayWord = phelkay[i]['phelkay_word'];
        var pPhrase = phelkay[i]['p_phrase'];

        var phelkayList = await db
            .query('Dzongkha', where: 'dId = ?', whereArgs: [phalkayID]);
        if (phelkayList.isNotEmpty) {
          var phelkaySame = await db.query('Dzongkha',
              where: 'dId = ? AND dUpdateTime = ?',
              whereArgs: [phalkayID, publishDate]);
          if (phelkaySame.isEmpty) {
            await db.rawUpdate(
                'UPDATE Dzongkha SET dWord = ?, dPhrase = ?, dUpdateTime = ? WHERE dId = ?',
                [phelkayWord, pPhrase, publishDate, phalkayID]);
            // print('update $phelkayList');
          }
        } else {
          Dzongkha dzongkha = Dzongkha(
              dId: phalkayID,
              dWord: phelkayWord,
              dPhrase: pPhrase,
              dUpdateTime: publishDate);
          _databaseService.insertDzongkha(dzongkha);
        }
      }
    }
  }

  Future<void> getAllZhesaDzongkha() async {
    var zpurl = "http://zhebsa.herokuapp.com/webapp/zhesaphelkay";
    Response responsezp = await dio.get(zpurl);
    if (responsezp.statusCode == 200) {
      //Clear the table and insert the new records
      _databaseService.deleteALLDzongkhaZhebsa();
      var zhesaphelkay = responsezp.data;
      // Insert all the records back into the relational table
      for (int i = 0; i < zhesaphelkay.length; i++) {
        var zheID = zhesaphelkay[i]['id'];
        var phelkay = zhesaphelkay[i]['phelkay'];
        // print(phelkay);
        for (var j = 0; j < phelkay.length; j++) {
          // print(phelkay[j]);
          var phelkayId = phelkay[j];
          DzongkhaZhebsa dzongkhaZhebsa =
              DzongkhaZhebsa(dzongkhadId: phelkayId, zhebsazId: zheID);
          _databaseService.insertDzongkhaZhebsa(dzongkhaZhebsa);
          // print('pid $phelkayId');
          // print('zid $zheID');
        }
      }
    }
  }
  //Create a method to delete all records from dzongkha and zhebsa where ID not in DzongkhaZhebsa Table
  //similarly, remove a file for those records in Zhebsa that do not have id in DzongkhaZhebsa Table
}
