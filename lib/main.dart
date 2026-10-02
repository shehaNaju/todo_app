import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/Provider/TodoProvider.dart';
import 'package:todo_app/ToDoPage.dart';

void main() {
  runApp( 
      ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child:  ToDoApp(),
    ),
  );

}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, // follows the phone's dark/light setting
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      
      home: const ToDoPage(),
    );
  }
}