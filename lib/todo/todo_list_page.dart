import 'package:flutter/material.dart';
import 'package:flutter_app/todo/todo_model.dart';
import 'package:flutter_app/todo/todo_service.dart';

class TodoListPage extends StatelessWidget {
  final TodoService _todoService = TodoService();
  String todoContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, size: 32.0),
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  content: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your todo.'
                    ),
                    onChanged: (String value) {
                      todoContent = value;
                    },
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text('Add'),
                      onPressed: () async {
                        final Todo todo = Todo(
                          content: todoContent,
                          completed: false
                        );
                        await _todoService.addDocument(todo);
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
            },
          )
        ],
      ),
      body: StreamBuilder<List<Todo>>(
          stream: _todoService.getAllTodos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final List<Todo> todos = snapshot.data;
            return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.0);
                },
                itemCount: todos.length,
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, index) {
                  final Todo todo = todos[index];
                  return Dismissible(
                    background: Container(
                      color: Colors.red,
                    ),
                    key: Key(todo.id),
                    onDismissed: (DismissDirection direction) async {
                      await _todoService.deleteDocument(todo.id);
                    },
                    child: Container(
                      color: Colors.grey.shade300,
                      child: ListTile(
                        leading: todo.completed
                            ? Icon(Icons.check, color: Colors.green, size: 32.0)
                            : Icon(Icons.check, color: Colors.grey, size: 32.0),
                        title:
                            Text(todo.content, style: TextStyle(fontSize: 32.0)),
                        selected: todo.completed,
                        onTap: () async {
                          todo.completed = !todo.completed;
                          await _todoService.updateDocument(todo);
                        },
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
