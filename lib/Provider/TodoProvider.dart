import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/todoModel.dart';

// Holds ALL app state and logic. The UI only displays it and calls methods.
// ChangeNotifier + notifyListeners() replaces setState() from v1.
class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    _load();
  }

  static const _storageKey = 'todos';

  final List<Todomodel> _todos = [];
  bool _loading = true;

  List<Todomodel> get todos => List.unmodifiable(_todos);
  bool get isLoading => _loading;
  int get remaining => _todos.where((t) => !t.isDone).length;
  bool get hasCompleted => _todos.any((t) => t.isDone);

  // Read saved tasks once at startup.
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _todos
        ..clear()
        ..addAll(list.map((e) => Todomodel.fromJson(e as Map<String, dynamic>)));
    }
    _loading = false;
    notifyListeners();
  }

  // Write the whole list after every change.
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_todos.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, json);
  }

  void _changed() {
    notifyListeners(); // rebuild widgets that are watching
    _save(); // persist to the device
  }

  void add(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    _todos.insert(
      0,
      Todomodel(id: DateTime.now().microsecondsSinceEpoch.toString(), title: text),
    );
    _changed();
  }

  void toggle(String id) {
    final todo = _todos.firstWhere((t) => t.id == id);
    todo.isDone = !todo.isDone;
    _changed();
  }

  void remove(String id) {
    _todos.removeWhere((t) => t.id == id);
    _changed();
  }

  void clearCompleted() {
    _todos.removeWhere((t) => t.isDone);
    _changed();
  }
}
