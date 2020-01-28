import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/todo/todo_model.dart';

final Firestore _firestore = Firestore.instance;
CollectionReference _todoCollection = _firestore.collection('todos');

class TodoService {
  Stream<List<Todo>> getAllTodos() {
    return _todoCollection.snapshots(includeMetadataChanges: true).map((QuerySnapshot _querySnapshot) =>
        _querySnapshot.documents.map((DocumentSnapshot _documentSnapshot) =>
            Todo.fromJson(_documentSnapshot)).toList());
  }

  Future<void> updateDocument(Todo todo) {
    return _todoCollection.document(todo.id).updateData(todo.toJson());
  }

  Future<void> addDocument(Todo todo) {
    return _todoCollection.document().setData(todo.toJson());
  }

  Future<void> deleteDocument(String id) {
    return _todoCollection.document(id).delete();
  }
}
