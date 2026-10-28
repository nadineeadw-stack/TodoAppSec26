import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _todos => _firestore.collection('todos');

  // CREATE
  Future<void> addTodo(TodoModel todo) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in before adding a task.');
    }

    await _todos.add({
      ...todo.toMap(),
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // UPDATE: Edit title and description
  Future<void> updateTodo(TodoModel todo) async {
    await _todos.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
    });
  }

  // UPDATE: Change completion status
  Future<void> updateTodoStatus(String id, bool isDone) async {
    await _todos.doc(id).update({'isDone': isDone});
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    await _todos.doc(id).delete();
  }
}
