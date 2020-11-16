import 'package:get/get.dart';
import 'package:todos_get/controllers/todo_controller.dart';
import 'package:todos_get/controllers/toggle_textfield_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TodosFilter>(TodosFilter());
    Get.put<TodosSearch>(TodosSearch());
    Get.put<Todos>(Todos());
    Get.put<ActiveCount>(ActiveCount());
    Get.put<FilteredTodos>(FilteredTodos());
    Get.create<ToggleTextfieldController>(() => ToggleTextfieldController());
  }
}
