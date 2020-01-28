import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String content;
  bool completed;

  Todo({this.id, this.content, this.completed});

  factory Todo.fromJson(DocumentSnapshot json) => Todo(
    id: json.documentID,
    content: json.data['content'],
    completed: json.data['completed']
  );

  Map<String, dynamic> toJson() => {
    'content': content,
    'completed': completed
  };
}