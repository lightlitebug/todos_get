import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  final String id;
  final String text;
  final bool completed;

  Todo({
    String id,
    this.text,
    this.completed = false,
  }) : id = id ?? uuid.v4();

  @override
  String toString() {
    return 'Todo(id: $id, text: $text, completed: $completed)';
  }
}
