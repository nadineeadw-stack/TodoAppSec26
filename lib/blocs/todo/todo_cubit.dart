import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/todo_repository.dart';
import '../../models/todo_model.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;

  TodoCubit(this._repository) : super(const TodoInitial());

  // READ
  Future<void> fetchTodos() async {
    emit(const TodoLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const TodoFailure('Please sign in first.'));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('todos')
          .where('userId', isEqualTo: user.uid)
          .get();

      final todos = snapshot.docs.map((doc) {
        return TodoModel.fromMap(doc.data(), doc.id);
      }).toList();

      todos.sort((a, b) => b.id.compareTo(a.id));

      emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodoFailure('Failed to fetch tasks: $e'));
    }
  }

  // CREATE
  Future<void> addTodo({
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      emit(const TodoFailure('Title cannot be empty.'));
      return;
    }

    emit(const TodoLoading());

    try {
      final todo = TodoModel(
        id: '',
        title: title.trim(),
        description: description.trim(),
      );

      await _repository.addTodo(todo);
      await fetchTodos();
    } catch (e) {
      emit(TodoFailure('Failed to save task: $e'));
    }
  }

  // UPDATE: Edit title and description
  Future<void> updateTodo({
    required String id,
    required String title,
    required String description,
  }) async {
    if (title.trim().isEmpty) {
      emit(const TodoFailure('Title cannot be empty.'));
      return;
    }

    emit(const TodoLoading());

    try {
      final todo = TodoModel(
        id: id,
        title: title.trim(),
        description: description.trim(),
      );

      await _repository.updateTodo(todo);
      await fetchTodos();
    } catch (e) {
      emit(TodoFailure('Failed to update task: $e'));
    }
  }

  // UPDATE: Checkbox status
  Future<void> toggleTodo({required String id, required bool isDone}) async {
    try {
      await _repository.updateTodoStatus(id, isDone);
      await fetchTodos();
    } catch (e) {
      emit(TodoFailure('Failed to update task status: $e'));
    }
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    emit(const TodoLoading());

    try {
      await _repository.deleteTodo(id);
      await fetchTodos();
    } catch (e) {
      emit(TodoFailure('Failed to delete task: $e'));
    }
  }
}
