import 'package:flutter/material.dart';
import 'package:todolist/db/dbHelper.dart';
import 'package:todolist/model/todo.dart';

class FinishListPage extends StatefulWidget {
  const FinishListPage({Key? key}) : super(key: key);

  @override
  State<FinishListPage> createState() => _FinishListPageState();
}

class _FinishListPageState extends State<FinishListPage> {
  Future<List<Todo>>? finishList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finishList = getFinishList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료한 일'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];
                        return ListTile(
                          title: Text(
                            todo.title!,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Text('상태 : 완료!'),
                                Padding(padding: EdgeInsets.all(2)),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
                  }
              }
              return Text('No data');
            },
            future: finishList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('완료한 일 삭제'),
                content: Text('완료한 일을 모두 삭제할까요?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Text('예')
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop(false);
                      },
                      child: Text('아니오')
                  ),
                ],
              );
            }
          );
          if (result == true) {
            _removeAllTodos();
          }
        },
        child: Icon(Icons.remove),
      ),
    );
  }

  /**
   *  - 설명 : active가 1인 값을 불러온다.
   */
  Future<List<Todo>> getFinishList() async {
    final DBHelper database = await DBHelper();
    return await database
        .rawQuery("select title, content, id from todos where active = 1");
  }

  void _removeAllTodos() async {
    final DBHelper database = await DBHelper();
    await database.rawQuery('delete from todos where active=1');
    setState(() {
      finishList = getFinishList();
    });
  }
}
