
// 3. Data model: one task.// 
class Todomodel {
  final String id;
  final String title;
  bool isDone;
  Todomodel({required this.title, this.isDone = false, required this.id});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': isDone};

    factory Todomodel.fromJson(Map<String, dynamic> json) => Todomodel(
        id: json['id'] as String,
        title: json['title'] as String,
      isDone: json['done'] as bool? ?? false,
      );
}


