import 'package:equatable/equatable.dart';
import '../../models/todo_model.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {
  const TodoInitial();
}

class TodoLoading extends TodoState {
  const TodoLoading();
}

class TodoSuccess extends TodoState {
  const TodoSuccess();
}

class TodoFailure extends TodoState {
  final String message;

  const TodoFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TodosLoaded extends TodoState {
  final List<TodoModel> todos;

  const TodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}
