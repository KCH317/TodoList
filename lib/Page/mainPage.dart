import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todolist/Page/finishListPage.dart';
import 'todoListPage.dart';

class MainPage extends StatefulWidget {
  final Future<Database> db;
  MainPage(this.db);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          TodoListPage(),
          FinishListPage()
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.calendar_today_outlined),),
          Tab(icon: Icon(Icons.star_border_purple500_outlined),),
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      ),
    );
  }
}
