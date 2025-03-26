import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/to_do.dart';
import 'package:uuid/uuid.dart';

class ToDoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  GlobalKey<AnimatedListState> get listKey => _listKey;

  void addTodo(String title) {
    final newTodo = Todo(id: const Uuid().v4(), title: title);
    _todos.add(newTodo);
    _listKey.currentState?.insertItem(_todos.length - 1);
    notifyListeners();
  }
  
  void toggleTodo(String id){
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    _todos[todoIndex].isDone = !_todos[todoIndex].isDone;
    notifyListeners();
  }

  void deleteTodo(String id) {
  final todoIndex = _todos.indexWhere((todo) => todo.id == id);
  if (todoIndex != -1) {
    final todo = _todos[todoIndex];
    _todos.removeAt(todoIndex);
    _listKey.currentState?.removeItem(
      todoIndex,
          (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: Slidable(
          key: Key(todo.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                onPressed: (context) {
                  
                },
              ),
            ],
          ),
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isDone,
            onChanged: (value) {
              toggleTodo(todo.id);
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );
    notifyListeners();
  }
}
}
