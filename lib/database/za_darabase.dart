import 'dart:math';

import '../model/dzongkha.dart';
import '../model/zhebsa.dart';
import '../model/dzongkha_zhebsa.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//DatabaseHelper
class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'zhebsa_assistant.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store dzongkha
  // and a table to store zhebsa.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {dzongkha} TABLE statement on the database.
    await db.execute(
      '''CREATE TABLE Dzongkha(
        dId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        dWord TEXT NOT NULL UNIQUE, 
        dPhrase TEXT, 
        dHistory TEXT, 
        dFavourite TEXT, 
        dUpdateTime TEXT)''',
    );
    // Run the CREATE {zhebsa} TABLE statement on the database.
    await db.execute(
      '''CREATE TABLE Zhebsa(
        zId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
        zWord TEXT NOT NULL UNIQUE, 
        zPhrase TEXT, 
        zPronunciation TEXT, 
        zHistory TEXT, 
        zFavourite TEXT, 
        zUpdateTime TEXT)''',
    );

    // Run the CREATE {dzongkha_zhebsa} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE DzongkhaZhebsa(DzongkhadId INTEGER NOT NULL, ZhebsazId INTEGER NOT NULL, updateTime  TEXT, PRIMARY KEY (DzongkhadId, ZhebsazId), FOREIGN KEY(DzongkhadId) REFERENCES Dzongkha(dId) ON DELETE SET NULL, FOREIGN KEY(ZhebsazId) REFERENCES Zhebsa(zId) ON DELETE SET NULL)',
    );

    await db.execute(
      '''CREATE TABLE ZhebsaWordOfDay(
        wodID INTEGER NOT NULL,
        wodDay TEXT)''',
    );

    //Insert raw data to database
    var dt = DateTime.now();
    var dtStr = dt.toIso8601String();
    // dt = DateTime.tryParse(dtStr)!;//DATE_TIME

    /* var dtInt = dt.millisecondsSinceEpoch;////CURRENT_TIMESTAMP
    dt = DateTime.fromMillisecondsSinceEpoch(dtInt);
 */
    await db
        .rawInsert('''INSERT INTO Dzongkha(dId,dWord,dPhrase,dUpdateTime) VALUES
 (1,'ཀ་ར་གཏང་།',NULL,'2022-05-01T13:01:01.845')
,(2,'ཀླད་པ།',NULL,'2022-05-01T13:01:01.845')
,(3,'དཀར་མེ།',NULL,'2022-05-01T13:01:01.845')
,(4,'དཀར་ཡོལ།',NULL,'2022-05-01T13:01:01.845')
,(5,'བཀབ་ནེ།',NULL,'2022-05-01T13:01:01.845')
,(6,'བཀའ་རྒྱ་ཐོབ།',NULL,'2022-05-01T13:01:01.845')
,(7,'རྐང་ཁྲི།',NULL,'2022-05-01T13:01:01.845')
,(8,'སྡོད་ཁྲི།',NULL,'2022-05-01T13:01:01.845')
,(9,'རྐང་རྗེན།',NULL,'2022-05-01T13:01:01.845')
,(10,'རྐང་རྗེས།',NULL,'2022-05-01T13:01:01.845')
,(11,'རྐང་རྟིང་།',NULL,'2022-05-01T13:01:01.845')
,(12,'རྐང་སྟེགས།',NULL,'2022-05-01T13:01:01.845')
,(13,'རྐང༌སྟོང༌།',NULL,'2022-05-01T13:01:01.845')
,(14,'རྐང་ཐང་།',NULL,'2022-05-01T13:01:01.845')
,(15,'རྐང་མཐིལ།',NULL,'2022-05-01T13:01:01.845')
,(16,'རྐང་གདན།',NULL,'2022-05-01T13:01:01.845')
,(17,'རྐང་གདུབ།',NULL,'2022-05-01T13:01:01.845')
,(18,'སྐད་ཧན།',NULL,'2022-05-01T13:01:01.845')
,(19,'སྐལཝ།',NULL,'2022-05-01T13:01:01.845')
,(20,'སྐེ།',NULL,'2022-05-01T13:01:01.845')
,(21,'སྐེ་རྒྱན།',NULL,'2022-05-01T13:01:01.845')
,(22,'སྐེ་དར།',NULL,'2022-05-01T13:01:01.845')
,(23,'སྐོར་ར།',NULL,'2022-05-01T13:01:01.845')
,(24,'སྐྱ།',NULL,'2022-05-01T13:01:01.845')
,(25,'སྐྱ་བཏོག',NULL,'2022-05-01T13:01:01.845')
,(26,'སྐྱེ།',NULL,'2022-05-01T13:01:01.845')
,(27,'སྐྱེ་སྐར།',NULL,'2022-05-01T13:01:01.845')
,(28,'སྐྱེ༌བའི༌ཉིནམ།',NULL,'2022-05-01T13:01:01.845')
,(29,'སྐྱེ་བ།',NULL,'2022-05-01T13:01:01.845')
,(30,'སྐྱེ་བ་ལེན།',NULL,'2022-05-01T13:01:01.845');''');
    await db.rawInsert(
        '''INSERT INTO Zhebsa(zId,zWord,zPhrase,zPronunciation,zUpdateTime) VALUES
 (1,'སྐུ་དཀར་གསོལ།','ད་རི་གཡུས་ཁའི་མི་ཚུ་གི་མཆོད་རྟེན་སྐུ་དཀར་གསོལ་དེས།','F000001.mp3','2022-05-01T13:01:01.844')
,(2,'དབུ་ཀླད།','བློན་པོ་གི་དབུ་ཀླད་དྲགས་སྦེ།','F000002.mp3','2022-05-01T13:01:01.845')
,(3,'མཆོད་མེ།','ལྷ་ཁང་ནང་ལུ་མཆོད་མེ་འདུག།','F000003.mp3','2022-05-01T13:01:01.845')
,(4,'ཞལ་དཀར།',NULL,'F000004.mp3','2022-05-01T13:01:01.845')
,(5,'སྐུ་གཟན།',NULL,'F000005.mp3','2022-05-01T13:01:01.845')
,(6,'ན༌བཟའ།',NULL,'F000006.mp3','2022-05-01T13:01:01.845')
,(7,'བཀའ་རྒྱ༌ཕེབས།',NULL,'F000007.mp3','2022-05-01T13:01:01.845')
,(8,'བཞུགས་ཁྲི།',NULL,'F000008.mp3','2022-05-01T13:01:01.845')
,(9,'ཞབས་རྗེན།',NULL,'F000009.mp3','2022-05-01T13:01:01.845')
,(10,'ཞབས་རྗེས།',NULL,'F000010.mp3','2022-05-01T13:01:01.845')
,(11,'ཞབས་རྟིང་།',NULL,'F000011.mp3','2022-05-01T13:01:01.845')
,(12,'ཞབས་སྟེགས།',NULL,'F000012.mp3','2022-05-01T13:01:01.845')
,(13,'ཞབས་སྟོང།',NULL,'F000013.mp3','2022-05-01T13:01:01.845')
,(14,'ཞབས་ཐང་།',NULL,'F000014.mp3','2022-05-01T13:01:01.845')
,(15,'ཞབས་མཐིལ།',NULL,'F000015.mp3','2022-05-01T13:01:01.845')
,(16,'ཞབས་གདན།',NULL,'F000016.mp3','2022-05-01T13:01:01.845')
,(17,'ཞབས་གདུབ།',NULL,'F000017.mp3','2022-05-01T13:01:01.845')
,(18,'གསུང་སྙན།',NULL,'F000018.mp3','2022-05-01T13:01:01.845')
,(19,'སྐུ་སྐལ།',NULL,'F000019.mp3','2022-05-01T13:01:01.845')
,(20,'མགུལ།',NULL,'F000020.mp3','2022-05-01T13:01:01.845')
,(21,'མགུལ་རྒྱན།',NULL,'F000021.mp3','2022-05-01T13:01:01.845')
,(22,'མགུལ་དར།',NULL,'F000022.mp3','2022-05-01T13:01:01.845')
,(23,'ཞབས་སྐོར།',NULL,'F000023.mp3','2022-05-01T13:01:01.845')
,(24,'དབུ་སྐྲ།',NULL,'F000024.mp3','2022-05-01T13:01:01.845')
,(25,'དབུ་སྐྲ་བསིལ།',NULL,'F000025.mp3','2022-05-01T13:01:01.845')
,(26,'འཁྲུངས།',NULL,'F000026.mp3','2022-05-01T13:01:01.845')
,(27,'འཁྲུངས་སྐར།',NULL,'F000027.mp3','2022-05-01T13:01:01.845')
,(28,'སྐུ་སྐྱེ།',NULL,'F000028.mp3','2022-05-01T13:01:01.845')
,(29,'ཡང་སྲིད།',NULL,'F000029.mp3','2022-05-01T13:01:01.845')
,(30,'སྐུ་སྐྱེ་བཞེས།',NULL,'F000030.mp3','2022-05-01T13:01:01.845');''');
    await db.rawInsert(
        '''INSERT INTO DzongkhaZhebsa(DzongkhadId,ZhebsazId,updateTime) VALUES
 (1,1,'2022-05-01T13:01:01.844')
,(2,2,'2022-05-01T13:01:01.844')
,(3,3,'2022-05-01T13:01:01.844')
,(4,4,'2022-05-01T13:01:01.844')
,(5,5,'2022-05-01T13:01:01.844')
,(5,6,'2022-05-01T13:01:01.844')
,(6,7,'2022-05-01T13:01:01.844')
,(7,8,'2022-05-01T13:01:01.844')
,(8,8,'2022-05-01T13:01:01.844')
,(9,9,'2022-05-01T13:01:01.844')
,(10,10,'2022-05-01T13:01:01.844')
,(11,11,'2022-05-01T13:01:01.844')
,(12,12,'2022-05-01T13:01:01.844')
,(13,13,'2022-05-01T13:01:01.844')
,(14,14,'2022-05-01T13:01:01.844')
,(15,15,'2022-05-01T13:01:01.844')
,(16,16,'2022-05-01T13:01:01.844')
,(17,17,'2022-05-01T13:01:01.844')
,(18,18,'2022-05-01T13:01:01.844')
,(19,19,'2022-05-01T13:01:01.844')
,(20,20,'2022-05-01T13:01:01.844')
,(21,21,'2022-05-01T13:01:01.844')
,(22,22,'2022-05-01T13:01:01.844')
,(23,23,'2022-05-01T13:01:01.844')
,(24,24,'2022-05-01T13:01:01.844')
,(25,25,'2022-05-01T13:01:01.844')
,(26,26,'2022-05-01T13:01:01.844')
,(27,27,'2022-05-01T13:01:01.844')
,(28,27,'2022-05-01T13:01:01.844')
,(29,28,'2022-05-01T13:01:01.844')
,(29,29,'2022-05-01T13:01:01.844')
,(30,30,'2022-05-01T13:01:01.844');''');
  }

  Future<List> populateSearch() async {
    final db = await _databaseService.database;
    return await db.rawQuery(
        'SELECT dWord AS sWord FROM Dzongkha UNION SELECT zWord FROM Zhebsa');
  }

  Future<List> populateHistory() async {
    final db = await _databaseService.database;
    return await db.rawQuery(
        'SELECT * FROM (SELECT dWord AS hWord, dHistory as hHistory FROM Dzongkha WHERE dHistory !="" UNION SELECT zWord, zHistory FROM Zhebsa WHERE zHistory !="") ORDER BY 2 DESC LIMIT 10');
  }

  Future<List> searchDzongkha(String word) async {
    final db = await _databaseService.database;
    return await db.query('Dzongkha', where: 'dWord = ?', whereArgs: [word]);
  }

  Future<List> searchZhesaWord(String word) async {
    final db = await _databaseService.database;
    return await db.query('Zhebsa', where: 'zWord = ?', whereArgs: [word]);
  }

  Future<List> getZhebsaSearchId(int did) async {
    final db = await _databaseService.database;
    final List zhesaIdList = []; //DzongkhadId, ZhebsazId, updateTime
    var data = await db.query('DzongkhaZhebsa',
        columns: ['ZhebsazId'],
        where: 'DzongkhadId = ?',
        whereArgs: [did]); //columns: ['ZhebsazId']

    for (int i = 0; i < data.length; i++) {
      zhesaIdList.add(data[i]['ZhebsazId']);
    }
    return zhesaIdList;
  }

  Future<List> getDzongkhaSearchId(int zid) async {
    final db = await _databaseService.database;
    final List dzongkhaIdList = []; //DzongkhadId, ZhebsazId, updateTime
    var data = await db.query('DzongkhaZhebsa',
        columns: ['DzongkhadId'],
        where: 'ZhebsazId = ?',
        whereArgs: [zid]); //columns: ['ZhebsazId']

    for (int i = 0; i < data.length; i++) {
      dzongkhaIdList.add(data[i]['DzongkhadId']);
    }
    return dzongkhaIdList;
  }

  Future<List> getZhebsaSearch(List zhesaID) async {
    final db = await _databaseService.database;
    return await db.query('Zhebsa',
        where: 'zId IN (${('?' * (zhesaID.length)).split('').join(', ')})',
        whereArgs: zhesaID);
  }

  Future<List> getDzongkhaSearch(List dzongkhaID) async {
    final db = await _databaseService.database;
    return await db.query('Dzongkha',
        where: 'dId IN (${('?' * (dzongkhaID.length)).split('').join(', ')})',
        whereArgs: dzongkhaID);
  }

  Future<void> updateFavourite(
      int id, String favourite, String tableName) async {
    final db = await _databaseService.database;
    if (tableName == 'Zhebsa') {
      await db.rawUpdate(
          'UPDATE Zhebsa SET zFavourite = ? WHERE zId = ?', [favourite, id]);
    } else if (tableName == 'Dzongkha') {
      await db.rawUpdate(
          'UPDATE Dzongkha SET dFavourite = ? WHERE dId = ?', [favourite, id]);
    }
  }

  Future<List<FavouriteDataModel>> showFavourite() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM (SELECT dWord AS fWord, dPhrase AS fPhrase, dFavourite AS favouroite FROM Dzongkha WHERE dFavourite !="" UNION SELECT zWord, zPhrase, zFavourite FROM Zhebsa WHERE zFavourite !="") ORDER BY 3 DESC');
    return List.generate(
        maps.length, (index) => FavouriteDataModel.fromMap(maps[index]));
  }

  Future<void> updateHistory(int id, String history, String tableName) async {
    final db = await _databaseService.database;
    if (tableName == 'Zhebsa') {
      await db.rawUpdate(
          'UPDATE Zhebsa SET zHistory = ? WHERE zId = ?', [history, id]);
    } else if (tableName == 'Dzongkha') {
      await db.rawUpdate(
          'UPDATE Dzongkha SET dHistory = ? WHERE dId = ?', [history, id]);
    }
  }

  Future<void> insertWordOfDay(ZhebsaWordOfDay zhebsaWordOfDay) async {
    final db = await _databaseService.database;
    await db.insert('ZhebsaWordOfDay', zhebsaWordOfDay.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List> showWordOfDay() async {
    var checkid = [];
    var dt = DateTime.now();
    String date =
        "${dt.year.toString()}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    String firstDay = dt.day.toString();

    final db = await _databaseService.database;
    if (firstDay == '01') {
      // reset every month
      await db.delete('ZhebsaWordOfDay');
    }

    var check = await db.query("ZhebsaWordOfDay",
        where: 'wodDay = ?', whereArgs: [date], columns: ['wodID']);
    for (var item in check) {
      checkid.add(item['wodID']);
    }

    if (check.isEmpty) {
      var zid;
      var zhesaList = await db.rawQuery(
          'SELECT zID FROM Zhebsa WHERE ZID NOT IN(SELECT wodID FROM ZhebsaWordOfDay)');
      final _random = Random();
      var wordID = zhesaList[_random.nextInt(zhesaList.length)];
      zid = wordID['zId'];
      ZhebsaWordOfDay zhebsaWordOfDay =
          ZhebsaWordOfDay(wodID: zid, wodDay: date);
      insertWordOfDay(zhebsaWordOfDay);
      checkid.add(zid);
    }

    // print(checkid);

    return getZhebsaSearch(checkid);
  }

  // Define a function that inserts Dzongkha into the database
  Future<void> insertDzongkha(Dzongkha dzongkha) async {
    final db = await _databaseService.database;

    // Insert the Dzongkha into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same word is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'Dzongkha',
      dzongkha.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dzongkha>> showAllDzongkha() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Dzongkha');
    return List.generate(maps.length, (index) => Dzongkha.fromMap(maps[index]));
  }

  Future<Dzongkha> showDzongkha(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Dzongkha', where: 'dId = ?', whereArgs: [id]);
    return Dzongkha.fromMap(maps[0]);
  }

  Future<void> updateDzongkhaFavourite(Dzongkha dzongkha) async {
    final db = await _databaseService.database;
    await db.update(
      'Dzongkha',
      dzongkha.toMap(),
      where: 'dId = ?',
      whereArgs: [dzongkha.dId],
    );
  }

  Future<void> deleteDzongkha(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Dzongkha',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertZhebsa(Zhebsa zhebsa) async {
    final db = await _databaseService.database;
    await db.insert(
      'Zhebsa',
      zhebsa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Zhebsa>> showAllZhebsa() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Zhebsa');
    return List.generate(maps.length, (index) => Zhebsa.fromMap(maps[index]));
  }

  /* Future<void> updateFavouriteZhebsa(Zhebsa zhebsa) async {
    final db = await _databaseService.database;
    await db.update('Zhebsa', zhebsa.toMap(),
        where: 'zId = ?', whereArgs: [zhebsa.zId]);
  }
 */
  Future<void> deletezhebsa(int id) async {
    final db = await _databaseService.database;
    await db.delete('Zhebsa', where: 'zId = ?', whereArgs: [id]);
  }

  Future<void> insertDzongkhaZhebsa(DzongkhaZhebsa dzongkhaZhebsa) async {
    final db = await _databaseService.database;
    await db.insert(
      'DzongkhaZhebsa',
      dzongkhaZhebsa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
