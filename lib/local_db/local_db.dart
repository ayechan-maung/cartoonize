import 'package:cartoonize/local_db/file_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('notes.db');
    return _database!;
  }

  Future<Database> _initDatabase(String path) async {
    var databasePath = await getDatabasesPath();

    String filePath = join(databasePath, path);
    return await openDatabase(filePath, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute(''' 
    CREATE TABLE $tableImgFiles (
      ${FieldsConst.id} $idType,
      ${FieldsConst.imageUrl} $textType,
      ${FieldsConst.description} $textType,
      ${FieldsConst.time} $textType
    )
  ''');
  }

  Future<ImgFile> storeImage(ImgFile note) async {
    final db = await instance.database;
    note.id = await db.insert(tableImgFiles, note.toJson());
    return note;
  }

  Future<List<ImgFile>> getAllImages() async {
    final db = await instance.database;

    final orderBy = '${FieldsConst.id} ASC';
    final result = await db.query(tableImgFiles, orderBy: orderBy);

    print('res-->' + result.toString());

    return result.map((e) => ImgFile.fromJson(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableImgFiles, where: '${FieldsConst.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
