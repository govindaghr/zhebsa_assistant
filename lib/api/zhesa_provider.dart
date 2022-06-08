import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:zhebsa_assistant/database/za_darabase.dart';
import 'package:dio/dio.dart';

class ZhesaAPIProvider {
  // Response response;
  var dio = Dio();
  static final DatabaseService _databaseService = DatabaseService();
  Future<List> getAllZhesa() async {
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

        var zhesaList = await db
            .query('Zhebsa', where: 'zID = ?', whereArgs: [zhesa[i]['id']]);
        // print(zhesaList[i]['zUpdateTime']);
        if (zhesaList.isNotEmpty) {
          var zhesaSame = await db.query('Zhebsa',
              where: 'zID = ? AND zUpdateTime = ?',
              whereArgs: ['$zhesaID', '$pubdate']);
          if (zhesaSame.isNotEmpty) {
            String file = 'assets/audio.mp3';
            //////////////////////////////////////////////
            await dio.download(audio, readFileAsync(file));

            print('No Change $zhesaSame');
          } else {
            /* await db.rawUpdate('UPDATE Zhebsa SET zWord = ?, zPhrase = ?, zUpdateTime = ?, zPeonunciation = ? WHERE zId = ?',
                [zWord, zPhrase, pubdate, audio, zhesaID]); */
            await db.rawUpdate(
                'UPDATE Zhebsa SET zWord = ?, zPhrase = ?, zUpdateTime = ? WHERE zId = ?',
                [zWord, zPhrase, pubdate, zhesaID]);
            print('update $zhesaList');
          }
          // await db.rawQuery('SELECT zID FROM Zhebsa WHERE zID = $zhesaID AND zUpdateTime = "$pubdate"');
          // print(zhesaSame);
        } else {
          print('Insert data $zhesaID');
        }
        // print(zhesa[i]['id']);
      }

      /* var zhesaList = await db.rawQuery(
          'SELECT zID FROM Zhebsa WHERE ZID NOT IN(SELECT wodID FROM ZhebsaWordOfDay)');
      print(zhesaList[0]); */
      return (response.data as List).map((zhesa) {
        // print('Inserting $zhesa');
        // DBProvider.db.createEmployee(Employee.fromJson(employee));
      }).toList();
    } else {
      return [];
    }
    // return 0;
  }

  Future<dynamic> readFileAsync(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);

    // String xmlString = await rootBundle.loadString(filePath);
    // print(xmlString);
    // await Directory(dirname(filePath));
    // return parseXml(xmlString);
    final Directory root = findRoot(await getApplicationDocumentsDirectory());
    // final path = join(root, filePath);
    // print('$root$filePath');
    print(filePath);
    // print(path);
    return (filePath);
  }

  Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }
}
