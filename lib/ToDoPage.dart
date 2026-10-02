import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Model/todoModel.dart';
import 'package:todo_app/Provider/TodoProvider.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
//  final  List<Todomodel> _todo = [];
 final TextEditingController _textEditingController = TextEditingController();

  // Add a task. setState() tells Flutter to r
  //ebuild the UI.

//  void _addTodo() {
//     final text = _textEditingController.text.trim();
//     if (text.isEmpty) return;
//     setState(() => _todo.insert(0, Todomodel(title: text)));
//     _textEditingController.clear();
//   }

//    void _toggle(Todomodel todo, bool? value) {
//     setState(() => todo.isDone = value ?? false);
//   }

//    void _remove(Todomodel todo) {
//     setState(() => _todo.remove(todo));
//   }

//provider implementation
 void _submit() {
    // read() = call a method, don't rebuild on change.
    context.read<TodoProvider>().add(_textEditingController.text);
    _textEditingController.clear();
  }

  @override
   void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  
  @override

  Widget build(BuildContext context) {
    // final remainingTasks = _todo.where((todo) => !todo.isDone).length;
     final provider = context.watch<TodoProvider>();
    final todos = provider.todos;


    return  Scaffold(
      appBar: AppBar(
        title: Text('My Tasks (${provider.remaining} left)'),
      actions: [
          IconButton(
            tooltip: 'Clear completed',
            icon: const Icon(Icons.delete_sweep),
            onPressed: provider.hasCompleted ? provider.clearCompleted : null,
          ),
        ],
        
      ),
      body: Column(
        children: [
         Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
      
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _submit, child: const Text('Add')),
              ],
            ),
          ),

            Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                    ? const Center(child: Text('No tasks yet. Add one!'))
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, i) {
                          final todo = todos[i];
                          return Dismissible(
                            key: ValueKey(todo.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16),
                              child: const Icon(Icons.delete,
                                  color: Colors.white),
                            ),
                            onDismissed: (_) => provider.remove(todo.id),
                            child: CheckboxListTile(
                              value: todo.isDone,
                              onChanged: (_) => provider.toggle(todo.id),
                              title: Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }
                    )
            )
            

        ]
          

      )
    
    );
  }
}