import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController? titleController;
  TextEditingController? contentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = new TextEditingController();
    contentController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo 추가'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: '제목'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: '내용'),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Todo todo = Todo(
                    title: titleController!.value.text,
                    content: contentController!.value.text,
                    active: 0
                  );
                  Navigator.of(context).pop(todo);
                },
                child: Text('저장하기')),
            ],
          ),
        ),
      ),
    );
  }
}
