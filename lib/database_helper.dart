import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "UserDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'user_table';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnEmail = 'email';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database object
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create the table if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL
          )
          ''');
  }

  // Insert a user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(table, user);
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query(table);
  }

  // Delete all users
  Future<int> deleteAllUsers() async {
    Database db = await database;
    return await db.delete(table);
  }
}
