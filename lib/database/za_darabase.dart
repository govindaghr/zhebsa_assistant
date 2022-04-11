import 'dart:convert';

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
    final path = join(databasePath, 'zhebsa_assistant0.db');

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

    //Insert raw data to database
    var dt = DateTime.now();
    var dtStr = dt.toIso8601String();
    // dt = DateTime.tryParse(dtStr)!;//DATE_TIME

    /* var dtInt = dt.millisecondsSinceEpoch;////CURRENT_TIMESTAMP
    dt = DateTime.fromMillisecondsSinceEpoch(dtInt);
 */
    await db.rawInsert(
        'INSERT INTO Dzongkha(dId, dWord, dPhrase, dUpdateTime) VALUES(1, "བཀབ་ནེ།", "བཀབ་ནེ་བཀབ་གོ།", "$dtStr"),(2, "ཁ།", "ཁ། inn", "$dtStr"), (3, "བརྩེ་བ།", "བརྩེ་བ། kindness", "$dtStr")');
    await db.rawInsert(
        'INSERT INTO Zhebsa(zId, zWord, zPhrase, zPronunciation, zUpdateTime) VALUES(1, "སྐུ་གཟན།", "སྐུ་གཟན yes", "2.mp3", "$dtStr"), (2, "ན༌བཟའ།", "ན༌བཟའ་ཨིན།", "2.mp3", "$dtStr"), (3, "ཞལ།", "ཞལ། is correct", "3.mp3", "$dtStr"), (4, "བརྩེ་བ།", "བརྩེ་བ། honoriffic", "4.mp3", "$dtStr")');
    await db.rawInsert(
        'INSERT INTO DzongkhaZhebsa (DzongkhadId, ZhebsazId, updateTime) VALUES(1, 1, "$dtStr"), (1, 2, "$dtStr"), (2, 3, "$dtStr"), (3, 4, "$dtStr")');
  }

  // Define a function that inserts Dzongkha into the database
  Future<void> insertDzongkha(Dzongkha dzongkha) async {
    // Get a reference to the database.
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

  Future<Dzongkha> populateSearch(int searchText) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Dzongkha', where: 'dId = ?', whereArgs: [searchText]);
    return Dzongkha.fromMap(maps[0]);
  }

  // A method that retrieves all the words from the dzongkha table.
  Future<List<Dzongkha>> showAllDzongkha() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the Dzongkha.
    final List<Map<String, dynamic>> maps = await db.query('Dzongkha');

    // Convert the List<Map<String, dynamic> into a List<Dzongkha>.
    return List.generate(maps.length, (index) => Dzongkha.fromMap(maps[index]));
  }

  Future<Dzongkha> showDzongkha(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('Dzongkha', where: 'dId = ?', whereArgs: [id]);
    return Dzongkha.fromMap(maps[0]);
  }

  // A method that updates a breed data from the breeds table.
  Future<void> updateDzongkhaFavourite(Dzongkha dzongkha) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Update the given favourite dzongkha
    await db.update(
      'Dzongkha',
      dzongkha.toMap(),
      // Ensure that the dzongkha has a matching id.
      where: 'dId = ?',
      // Pass the dzongkha's id as a whereArg to prevent SQL injection.
      whereArgs: [dzongkha.dId],
    );
  }

  // A method that deletes a breed data from the breeds table.
  Future<void> deleteDzongkha(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the Dzongkha from the database.
    await db.delete(
      'Dzongkha',
      // Use a `where` clause to delete a specific row.
      where: 'id = ?',
      // Pass the Dzongkha's id as a whereArg to prevent SQL injection.
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

  /*  Future<List<Zhebsa>> showAllZhebsa() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Zhebsa',
        columns: ['zID', 'zWord', 'zPhrase', 'zPronunciation']);
    return List.generate(maps.length, (index) => Zhebsa.fromMap(maps[index]));
  } */
  Future<List<Zhebsa>> showAllZhebsa() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Zhebsa');
    return List.generate(maps.length, (index) => Zhebsa.fromMap(maps[index]));
  }

  Future<void> updateFavouriteZhebsa(Zhebsa zhebsa) async {
    final db = await _databaseService.database;
    await db.update('Zhebsa', zhebsa.toMap(),
        where: 'zId = ?', whereArgs: [zhebsa.zId]);
  }

  /* Future<void> insertZhebsa(Zhebsa zhebsa) async {
    final db = await _databaseService.database;
    await db.insert(
      'Zhebsa',
      zhebsa.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } */

  /*  Future<List<Zhebsa>> showAllZhebsa() async {
    final db = await _databaseService.database;
    final result = await db.query('Zhebsa',
        columns: ['zID', 'zWord', 'zPhrase', 'zPronunciation']);
    return result.map((json) => Zhebsa.fromJson(json)).toList();
  } */

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
