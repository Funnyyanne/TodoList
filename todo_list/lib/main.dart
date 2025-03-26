import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/to_do_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'to_do.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ToDoProvider(), child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List ',
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home:  TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatelessWidget {
   TodoListScreen({Key? key}) : super(key: key);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Consumer<ToDoProvider>(
      builder: (context, todoProvider, child) {
        return AnimatedList(
            key: _listKey,
          initialItemCount: todoProvider.todos.length,
          itemBuilder: (context, index, animation) {
            final todo = todoProvider.todos[index];
            return SizeTransition(
      sizeFactor: animation,
      child:  
             Slidable(key: Key(todo.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                 backgroundColor: Colors.red,
                 foregroundColor: Colors.white,
                 icon:Icons.delete,
                 label:'Delete',
                 onPressed:(context){
                 todoProvider.deleteTodo(todo.id); 
                },
               ),]
    ),child: CheckboxListTile(
      title: Text(todo.title),
      value: todo.isDone,
      onChanged: (value) {
        todoProvider.toggleTodo(todo.id);
      },
    ),
    ),
    );
          },
        );
    },
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTodoTitle = '';
              return AlertDialog(
                title: const Text('Add New Todo'),
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Todo Title'),
                  onChanged: (value) {
                    newTodoTitle = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (newTodoTitle.isNotEmpty) {
                    
                        Provider.of<ToDoProvider>(context, listen: false).addTodo(newTodoTitle);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );

}
}