import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/todo.dart';

class DBHelper {
  var _db;

  // db 가져오기
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), 'todo_database.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
    return _db;
  }

  // Table 생성
  static void _createDb(Database db) {
    db.execute(
      "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "title TEXT, content TEXT, active INTEGER)",
    );
  }

  // 전체조회
  Future<List<Todo>> getAllTodo() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      int active = maps[i]['active'] == 1 ? 1: 0;
      return Todo(
          title: maps[i]['title'].toString(),
          content: maps[i]['content'].toString(),
          active: active,
          id: maps[i]['id']
      );
    });
  }

  // 조회
  Future<dynamic> getTodo(int id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = (await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    ));

    return maps.isNotEmpty ? maps : null;
  }

  // 삽입
  Future<void> insert(Todo todo) async {
    final db = await database;

    await db.insert("todos", todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 갱신
  Future<void> update(Todo todo) async {
    final db = await database;

    await db.update(
      "todos",
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  // 삭제
  Future<void> delete(Todo todo) async {
    final db = await database;

    await db.delete(
      "todos",
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }

  /** rawQuery
   * 필수값 : title, content, id
   */
  Future<List<Todo>> rawQuery(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return List.generate(maps.length, (i){
      return Todo(
        title: maps[i]['title'].toString(),
        content: maps[i]['content'].toString(),
        id: maps[i]['id']
      );
    });
  }

}