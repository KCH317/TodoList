import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Page/finishListPage.dart';
import 'package:todolist/Page/mainPage.dart';
import 'package:todolist/fragment/addTodo.dart';
import 'package:todolist/splash.dart';
import 'package:path/path.dart' as PATH;

/**
 * TodoList 앱
 * - 설명 : 할 일을 기록하고 관리한다.
 * - 화면 : 스플래쉬, 할 일, 완료한 일
 *
 * - 사용 기술 : flutter, sqlite
 *
 * @author : 권찬호
 * @createDate : 2022.06.08
 */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(primarySwatch: Colors.amber),
      initialRoute: '/',
      routes: {
        '/' : (context) => Splash(database),
        '/mainPage' : (context) => MainPage(database),
        '/mainPage/addTodo' : (context) => AddTodo(),
        '/finish' : (context) => FinishListPage(),
      },
    );

  }

  // db 시작
  Future<Database> initDatabase() async {
    return openDatabase(
      PATH.join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, content TEXT, active BOOL)",
        );
      },
      version: 1,
    );
  }


}

