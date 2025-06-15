import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'braille_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE text_braille(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        text_braille TEXT NOT NULL
      )
    ''');
  }

  // Insert a new record
  Future<int> insertTextBraille(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('text_braille', row);
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAllTextBraille() async {
    Database db = await database;
    return await db.query('text_braille', orderBy: 'id DESC');
  }

  // Get a specific record by id
  Future<List<Map<String, dynamic>>> getTextBrailleById(int id) async {
    Database db = await database;
    return await db.query(
      'text_braille',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a record
  Future<int> deleteTextBraille(int id) async {
    Database db = await database;
    return await db.delete(
      'text_braille',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all records
  Future<int> clearAllTextBraille() async {
    Database db = await database;
    return await db.delete('text_braille');
  }
} 