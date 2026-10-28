import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class AddTodoRequested extends TodoEvent {
  final String title;
  final String description;

  const AddTodoRequested({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class FetchTodosRequested extends TodoEvent {
  const FetchTodosRequested();
}
