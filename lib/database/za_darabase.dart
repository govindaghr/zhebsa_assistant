import 'dart:math';
import 'package:zhebsa_assistant/model/dzongkha.dart';
import 'package:zhebsa_assistant/model/zhebsa.dart';
import 'package:zhebsa_assistant/model/dzongkha_zhebsa.dart';
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
    final path = join(databasePath, 'zhebsa_assistant_sync.db');

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
    /* await db.execute(
      'CREATE TABLE DzongkhaZhebsa(DzongkhadId INTEGER NOT NULL, ZhebsazId INTEGER NOT NULL, updateTime  TEXT, PRIMARY KEY (DzongkhadId, ZhebsazId), FOREIGN KEY(DzongkhadId) REFERENCES Dzongkha(dId) ON DELETE SET NULL, FOREIGN KEY(ZhebsazId) REFERENCES Zhebsa(zId) ON DELETE SET NULL)',
    ); */
    await db.execute(
      'CREATE TABLE DzongkhaZhebsa(DzongkhadId INTEGER NOT NULL, ZhebsazId INTEGER NOT NULL, updateTime  TEXT, PRIMARY KEY (DzongkhadId, ZhebsazId))',
    );

    await db.execute(
      '''CREATE TABLE ZhebsaWordOfDay(
        wodID INTEGER NOT NULL,
        wodDay TEXT)''',
    );

    //Insert raw data to database
    /* var dt = DateTime.now();
    var dtStr = dt.toIso8601String(); */
    // dt = DateTime.tryParse(dtStr)!;//DATE_TIME

    /* var dtInt = dt.millisecondsSinceEpoch;////CURRENT_TIMESTAMP
    dt = DateTime.fromMillisecondsSinceEpoch(dtInt);
 */
    await db
        .rawInsert('''INSERT INTO Dzongkha(dId,dWord,dPhrase,dUpdateTime) VALUES
 (1,'ཀ་ར་གཏང་།','མི་ཚུ་ཁྱིམ་ཀ་ར་གཏང་དེས།','2022-05-18T17:44:56.587')
,(2,'ཀླད་པ།','མི་གི་ཀླདཔ་རུད་ནི་ཟེར་ག་ཏེ་འོང་ནི།','2022-05-18T17:44:56.587')
,(3,'དཀར་མེ།','ལྷ་ཁང་ནང་དཀར་མེ་ཕུལ་དགོ།','2022-05-18T17:44:56.587');
''');

    await db.rawInsert(
        '''INSERT INTO Zhebsa(zId,zWord,zPhrase,zPronunciation,zUpdateTime) VALUES
 (1,'སྐུ་དཀར་གསོལ།','ད་རིས་གཡུས་ཁའི་མི་ཚུ་གིས་མཆོད་རྟེན་སྐུ་དཀར་གསོལ་དེས།',NULL,'2022-05-18T17:51:15.871')
,(2,'དབུ་ཀླད།','འདི་སངས་རྒྱས་ཀྱི་དབུ་ཀླད་ཨིན།',NULL,'2022-05-18T17:51:15.871')
,(3,'མཆོད་མེ།','ལྷ་ཁང་ནང་ལུ་མཆོད་མེ་ཕུལ་བ་ཅིན་ རང་བསོད་ནམས་བསག་འོང་།',NULL,'2022-05-18T17:51:15.871');
''');

    await db.rawInsert(
        '''INSERT INTO DzongkhaZhebsa(DzongkhadId,ZhebsazId,updateTime) VALUES
 (1,1,'2022-05-18T17:44:56.581')
,(2,2,'2022-05-18T17:44:56.581')
,(3,3,'2022-05-18T17:44:56.581');
''');
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
          'SELECT zID FROM Zhebsa WHERE zID NOT IN(SELECT wodID FROM ZhebsaWordOfDay)');
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
    await db.insert(
      'Dzongkha',
      dzongkha.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<void> insertDzongkhaZhebsa(DzongkhaZhebsa dzongkhaZhebsa) async {
    final db = await _databaseService.database;
    await db.insert(
      'DzongkhaZhebsa',
      dzongkhaZhebsa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteALLDzongkhaZhebsa() async {
    final db = await _databaseService.database;
    await db.rawDelete('DELETE FROM DzongkhaZhebsa');
  }

  /* Future<List<Dzongkha>> showAllDzongkha() async {
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
  } */

  /* Future<List<Zhebsa>> showAllZhebsa() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Zhebsa');
    return List.generate(maps.length, (index) => Zhebsa.fromMap(maps[index]));
  }

  
  Future<void> deletezhebsa(int id) async {
    final db = await _databaseService.database;
    await db.delete('Zhebsa', where: 'zId = ?', whereArgs: [id]);
  } */

  /* Future<void> updateFavouriteZhebsa(Zhebsa zhebsa) async {
    final db = await _databaseService.database;
    await db.update('Zhebsa', zhebsa.toMap(),
        where: 'zId = ?', whereArgs: [zhebsa.zId]);
  }
 */

}
