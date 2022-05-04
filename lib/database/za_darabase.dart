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
    /* var dt = DateTime.now();
    var dtStr = dt.toIso8601String(); */
    // dt = DateTime.tryParse(dtStr)!;//DATE_TIME

    /* var dtInt = dt.millisecondsSinceEpoch;////CURRENT_TIMESTAMP
    dt = DateTime.fromMillisecondsSinceEpoch(dtInt);
 */
    await db
        .rawInsert('''INSERT INTO Dzongkha(dId,dWord,dPhrase,dUpdateTime) VALUES
 (1,'ཀ་ར་གཏང་།','མི་ཚུ་ཁྱིམ་ཀ་ར་གཏང་དེས།','2022-05-04T08:08:51.426')
,(2,'ཀླད་པ།','མི་གི་ཀླདཔ་རུད་ནི་ཟེར་ག་ཏེ་འོང་ནི།','2022-05-04T08:08:51.426')
,(3,'དཀར་མེ།','ལྷ་ཁང་ནང་དཀར་མེ་ཕུལ་དགོ།','2022-05-04T08:08:51.426')
,(4,'དཀར་ཡོལ།','དཀར་ཡོལ་ཆགས་ཡར་སོ་ནུག།','2022-05-04T08:08:51.426')
,(5,'བཀབ་ནེ།','བཀབ་ནེ་བཀབ་མི་འདི་ཁུངས་ཡོད།','2022-05-04T08:08:51.426')
,(6,'བཀའ་རྒྱ་ཐོབ།','ཡིག་ཚང་བཀའ་རྒྱ་ཐོབ་ཅི་སྨ་རེ།','2022-05-04T08:08:51.426')
,(7,'རྐང་ཁྲི།','རྐང་ཁྲི་གུ་སྡོད་དེ་བློ་སླབ།','2022-05-04T08:08:51.426')
,(8,'སྡོད་ཁྲི།','སློབ་ཕྲུག་ཚུ་སྡོད་ཁྲི་གུ་སྡོད་མ་བཅུག་པས།','2022-05-04T08:08:51.426')
,(9,'རྐང་རྗེན།','རྐང་རྗེན་སྦེ་འགྱོ་བ་ཅིན་ རྐང་མར་རྩང་འཛུལ་འོང་།','2022-05-04T08:08:51.426')
,(10,'རྐང་རྗེས།','མིའི་རྐང་རྗེས་འདི་མིག་ཏེ་གིས་མཐོང་མས།','2022-05-04T08:08:51.426')
,(11,'རྐང་རྟིང་།','བུམོ་གི་རྐང་རྟིང་རིང་རང་རིང་པས།','2022-05-04T08:08:51.426')
,(12,'རྐང་སྟེགས།','རྐང་སྟེགས་གུ་འཛེགས་སྡོད་ནུག།','2022-05-04T08:08:51.426')
,(13,'རྐང༌སྟོང༌།','རྐང་སྟོང་སྦེ་འགྱོ་སྟེ་རྩང་འཛུལ་ཏེ་ལམ་འགྱོ་མ་ཚུགས།','2022-05-04T08:08:51.426')
,(14,'རྐང་ཐང་།','རྐང་ཐང་སྦེ་འགྱོ་རུང་ལྷོད་ཚུགས།','2022-05-04T08:08:51.426')
,(15,'རྐང་མཐིལ།','རྐང་མཐིལ་གུ་གླངམོ་ཆེའི་པར་འདུག།','2022-05-04T08:08:51.426')
,(16,'རྐང་གདན།','རྐང་གདན་ཡོད་རུང་ གཞན་ཁ་ལས་སོང་ནུག།','2022-05-04T08:08:51.426')
,(17,'རྐང་གདུབ།','མི་ཚུ་ལུ་རྐང་གདུབ་རེ་རེ་སྦེ་བཙུགས་སྡོད་སར་མཐོང་ཅི།','2022-05-04T08:08:51.426')
,(18,'སྐད་ཧན།','བུ་མོའི་སྐད་འདི་སྐྱེས་པའི་རྣ་བར་ཧན་རང་ཧན་པས།','2022-05-04T08:08:51.426')
,(19,'སྐལཝ།','མི་ཤི་མི་འདི་ལོག་སྐལཝ་ག་ཏེ་ལན་ཡི་ག་མི་ཤེས།','2022-05-04T08:08:51.426')
,(20,'སྐེ།','གསུང་སྐུད་འདི་སྐེ་ལུ་བཏགས་དགོ།','2022-05-04T08:08:51.426')
,(21,'སྐེ་རྒྱན།','བུམོ་ཚུ་སྐེ་རྒྱན་བཏགསཔ་ད་རང་ལེགས་པས།','2022-05-04T08:08:51.426')
,(22,'སྐེ་དར།','གོ་གནས་མ་ཐོབ་རུང་ སྐེ་དར་གནང་དེས།','2022-05-04T08:08:51.426')
,(23,'སྐོར་ར།','ལྷ་ཁང་སྐོར་ར་རྐྱབ་སྟེ་སྡོད་ནུག།','2022-05-04T08:08:51.426')
,(24,'སྐྱ།','སྐྱ་གསེརཔོ་ཡོད་ཚད་ཅིགཔ་ཕྱི་ལསཔ་མེན།','2022-05-04T08:08:51.426')
,(25,'སྐྱ་བཏོག','སློབ་ཕྲུག་ཚུ་སྐྱ་བཏོག་པ་ཅིན་ཧིང་སངས་ས་མཐོངམ་མས།','2022-05-04T08:08:51.426')
,(26,'སྐྱེ།','ཨ་ལོ་སྐྱེ་ནི་འདི་ཁྲིམས་མེན།','2022-05-04T08:08:51.426')
,(27,'སྐྱེ་སྐར།','ཁོ་གི་སྐྱེ་སྐར་གྱི་ཉིནམ་ལུ་སྨོན་ལམ་བཏབ་ནུག།','2022-05-04T08:08:51.426')
,(28,'སྐྱེ༌བའི༌ཉིནམ།','ད་རིས་ངེའི་སྐྱེ་བའི་ཉིནམ་ཨིན།','2022-05-04T08:08:51.426')
,(29,'སྐྱེ་བ།','ངེའི་ཆ་རོགས་གྱོངས་མི་འདི་གི་སྐྱེ་བ་འདི་ཁ་ཨིན་མས།','2022-05-04T08:08:51.426')
,(30,'སྐྱེ་བ་ལེན།','ད་ལྟོ་མི་སྦེ་སྐྱེ་བ་ལེན་ཏེ་ཡོད།','2022-05-04T08:08:51.426');''');
    await db.rawInsert(
        '''INSERT INTO Zhebsa(zId,zWord,zPhrase,zPronunciation,zUpdateTime) VALUES
 (1,'སྐུ་དཀར་གསོལ།','ད་རིས་གཡུས་ཁའི་མི་ཚུ་གིས་མཆོད་རྟེན་སྐུ་དཀར་གསོལ་དེས།','F000001.mp3','2022-05-04T08:08:51.426')
,(2,'དབུ་ཀླད།','བློན་པོ་གི་དབུ་ཀླད་འདི་ར་དྲགས་པས།','F000002.mp3','2022-05-04T08:08:51.426')
,(3,'མཆོད་མེ།','ལྷ་ཁང་ནང་ལུ་མཆོད་མེ་ཕུལ་བ་ཅིན་ རང་བསོད་ནམས་བསགས་འོང་།','F000003.mp3','2022-05-04T08:08:51.426')
,(4,'ཞལ་དཀར།','བླ་མའི་ཞལ་དཀར་ནང་ལུ་ཨོམ་ལེ་ཤ་བླུགས་ནུག།','F000004.mp3','2022-05-04T08:08:51.426')
,(5,'སྐུ་གཟན།','བློན་པོའི་སྐུ་གཟན་འདི་གི་ཁ་དོག་ལི་ཝང་ཨིན།','F000005.mp3','2022-05-04T08:08:51.426')
,(6,'ན༌བཟའ།','སློབ་དཔོན་གྱིས་ན་བཟའ་ལེགས་ཤོམ་སྦེ་མ་བཞེས་པས།','F000006.mp3','2022-05-04T08:08:51.426')
,(7,'བཀའ་རྒྱ༌ཕེབས།','ཡིག་ཚང་ལས་བཀའ་རྒྱ་ཕེབས་ཏེ་ཡོད།','F000007.mp3','2022-05-04T08:08:51.426')
,(8,'བཞུགས་ཁྲི།','རྒྱལ་པོའི་བཞུགས་ཁྲི་གུ་བླམ་གིས་བཞུགས་ཆི་ནུག།','F000008.mp3','2022-05-04T08:08:51.426')
,(9,'ཞབས་རྗེན།','དང་ཕུའི་དུས་ལུ་རྒྱལ་རིགས་ཚུ་ཡང་ ཞབས་རྗེན་སྦེ་ཨིན་པས།','F000009.mp3','2022-05-04T08:08:51.426')
,(10,'ཞབས་རྗེས།','གནས་ཁག་ལས་ཕར་ཨོ་རྒྱན་གུ་རུ་རིན་པོ་ཆེའི་ཞབས་རྗེས་ཡོད།','F000010.mp3','2022-05-04T08:08:51.426')
,(11,'ཞབས་རྟིང་།','སློབ་དཔོན་གྱི་ཞབས་རྟིང་ཁར་རྨ་འདུག།','F000011.mp3','2022-05-04T08:08:51.426')
,(12,'ཞབས་སྟེགས།','བྱང་སེམས་ཅན་གྱི་རྒྱལ་པོ་མཆོག་གིས་ཞབས་འདི་ཞབས་སྟེགས་ཡོད་རུང་ དེ་ཁར་མི་བཞག།','F000012.mp3','2022-05-04T08:08:51.426')
,(13,'ཞབས་སྟོང།','དང་ཕུའི་བླམ་ཚུ་ཞབས་སྟོང་སྦེ་བྱོན་པའི་ལོ་རྒྱུས་འདུག།','F000013.mp3','2022-05-04T08:08:51.426')
,(14,'ཞབས་ཐང་།','སྤྲུལ་སྐུ་སྐུ་ན་ཆུང་བ་ལས་ཞབས་ཐང་སྦེ་འབྱོན་མ་ཚུགས་ནུག།','F000014.mp3','2022-05-04T08:08:51.426')
,(15,'ཞབས་མཐིལ།','བླམ་མའི་ཞབས་མཐིལ་དཀརཔོ་སྦེ་འདུག།','F000015.mp3','2022-05-04T08:08:51.426')
,(16,'ཞབས་གདན།','དགེ་སློང་ཚུ་ཞབས་གདན་གུ་བཞུགས་ནུག།','F000016.mp3','2022-05-04T08:08:51.426')
,(17,'ཞབས་གདུབ།','དང་ཕུའི་ཕམ་ཚུ་ལུ་ཕྱག་གདུབ་དང་ཞབས་གདུབ་ལེ་ཤ་འོང་།','F000017.mp3','2022-05-04T08:08:51.426')
,(18,'གསུང་སྙན།','གསུང་སྙན་པ་དབྱངས་ཅན་ལྷ་མོ་ཨིན།','F000018.mp3','2022-05-04T08:08:51.426')
,(19,'སྐུ་སྐལ།','བླམ་མའི་སྐུ་སྐལ་སློབ་མ་གིས་ཞུ་ནུག།','F000019.mp3','2022-05-04T08:08:51.426')
,(20,'མགུལ།','རྒྱལ་པོའི་མགུལ་གྱི་ནང་ལས་གསུང་སྐད་སྦོམ་སྦེ་འཐེནམ་ཨིན།','F000020.mp3','2022-05-04T08:08:51.426')
,(21,'མགུལ་རྒྱན།','དྲགོས་ལུ་མགུལ་རྒྱན་ཅིག་ཕེབས་ནུག།','F000021.mp3','2022-05-04T08:08:51.426')
,(22,'མགུལ་དར།','རྒཔོ་དྲགོས་ལས་མགུལ་དར་ཞུ་བར་འབྱོན་ནུག།','F000022.mp3','2022-05-04T08:08:51.426')
,(23,'ཞབས་སྐོར།','མངའ་བདག་རྒྱལ་པོ་གི་རྒྱལ་ཁབ་མཐའ་དབུས་མེད་པར་ཞབས་སྐོར་གནང་ནུག།','F000023.mp3','2022-05-04T08:08:51.426')
,(24,'དབུ་སྐྲ།','རྒྱལ་པའི་དབུ་སྐྲ་ཐུང་ཀུ་འདུག།','F000024.mp3','2022-05-04T08:08:51.426')
,(25,'དབུ་སྐྲ་བསིལ།','དགེ་སློང་ཚུ་ཨ་རྟག་རང་དབུ་སྐྲ་བསིལ་དགོཔ་ཨིན།','F000025.mp3','2022-05-04T08:08:51.426')
,(26,'འཁྲུངས།','སྤྱི་ལོ་༡༩༥༥ལུ་འབྲུག་རྒྱལ་བཞི་པ་མཆོག་སྐུ་འཁྲུངས་ནུག།','F000026.mp3','2022-05-04T08:08:51.426')
,(27,'འཁྲུངས་སྐར།','རྒྱལ་པའི་འཁྲུངས་སྐར་དུས་ཆེན་ལོ་ཨ་རྟག་རང་བརྩི་སྲུང་ཞུཝ་ཨིན།','F000027.mp3','2022-05-04T08:08:51.426')
,(28,'སྐུ་སྐྱེ།','བླ་མའི་སྐུ་སྐྱེ་འདི་བླམ་ཁོ་རའི་ཚ་བོ་ཨིན།','F000028.mp3','2022-05-04T08:08:51.426')
,(29,'ཡང་སྲིད།','འབྲུག་ལུ་ཡང་སྲིད་ལེ་ཤ་འཁྲུངས་ཏེ་ཡོད།','F000029.mp3','2022-05-04T08:08:51.426')
,(30,'སྐུ་སྐྱེ་བཞེས།','བླམ་འདི་ཧེ་མ་སྤྲུལ་སྐུའི་སྐུ་སྐྱེ་བཞེས་སྦེ་བཞུགས་ནུག།','F000030.mp3','2022-05-04T08:08:51.426');''');
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
