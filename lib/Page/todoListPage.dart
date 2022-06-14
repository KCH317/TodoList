import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/db/dbHelper.dart';

class TodoListPage extends StatefulWidget {
  // const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('TodoListPage'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder (
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
                            style: TextStyle(fontSize: 30),
                          ),
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Text('체크 : ${todo.active == 1 ? 'true' : 'false'}'),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                          // 내용수정
                          onTap: () async {
                            TextEditingController controller = new TextEditingController(text: todo.content);
                            // 내용수정 및 체크 on/off
                            Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.text,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (){
                                      setState(() {
                                        todo.active == 1 ? todo.active = 0 : todo.active = 1;
                                        todo.content = controller.value.text;
                                      });
                                      Navigator.of(context).pop(todo);
                                    },
                                      child: Text('예')
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(todo);
                                      },
                                      child: Text('아니오')
                                    ),
                                  ],
                                );
                              }
                            );
                            _updateTodo(result);
                          },
                          // 리스트 삭제
                          onLongPress: () async {
                            Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: Text('${todo.content}를 삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(todo);
                                      },
                                      child: Text('예')
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('아니오')
                                    ),
                                  ],
                                );
                              }
                            );
                            _deleteTodo(result);
                          },
                        );
                      },
                      itemCount: (snapshot.data as List<Todo>).length,
                    );
                  }  else {
                    return Text('No TodoList');
                  }
              }
            },
            future: todoList,
          ),
        ),
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final todo =
                  await Navigator.of(context).pushNamed('/mainPage/addTodo');
              if (todo != null) {
                _insertTodo(todo as Todo);
              }
            },
            heroTag: null,
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('모든 할 일을 완료'),
                      content: Text('모든 할 일을 완료할까요?'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('예')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('아니오')),
                      ],
                    );
                  });
              if (result == true) {
                _allFinishList();
              }
            },
            heroTag: null,
            child: Icon(Icons.update),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }

  // 삽입
  void _insertTodo(Todo todo) async {
    final DBHelper database = await DBHelper();
    await database.insert(todo);
    setState(() {
      todoList = getTodos();
    });
  }

  // 조회
  Future<List<Todo>> getTodos() async {
    return await DBHelper().getAllTodo();
  }

  // 갱신
  void _updateTodo(Todo todo) async {
    final DBHelper database = await DBHelper();
    await database.update(todo);

    setState(() {
      todoList = getTodos();
    });
  }

  // 삭제
  void _deleteTodo(Todo todo) async {
    final DBHelper database = await DBHelper();
    await database.delete(todo);

    setState(() {
      todoList = getTodos();
    });
  }

  // 모든 리스트 완료하기
  void _allFinishList() async {
    final DBHelper database = await DBHelper();
    await database.rawQuery('update todos set active = 1 where active = 0');
    setState(() {
      todoList = getTodos();
    });
  }

}
