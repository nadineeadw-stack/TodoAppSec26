import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo_event.dart';
import 'todo_state.dart';
import '../../models/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial()) {
    on<AddTodoRequested>(_onAddTodoRequested);
    on<FetchTodosRequested>(_onFetchTodosRequested);
  }

  Future<void> _onAddTodoRequested(
    AddTodoRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(const TodoLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const TodoFailure('Please sign in first.'));
        return;
      }

      await FirebaseFirestore.instance.collection('todos').add({
        'title': event.title.trim(),
        'description': event.description.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      emit(const TodoSuccess());
    } catch (e) {
      emit(TodoFailure('Failed to save task: $e'));
    }
  }

  Future<void> _onFetchTodosRequested(
    FetchTodosRequested event,
    Emitter<TodoState> emit,
  ) async {
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

      final documents = snapshot.docs.toList();

      documents.sort((a, b) {
        final dateA = a.data()['createdAt'] as Timestamp?;
        final dateB = b.data()['createdAt'] as Timestamp?;

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });

        final todos = documents
          .map((document) => TodoModel.fromMap(document.data(), document.id))
          .toList();

        emit(TodosLoaded(todos));
    } catch (e) {
      emit(TodoFailure('Failed to fetch tasks: $e'));
    }
  }
}
