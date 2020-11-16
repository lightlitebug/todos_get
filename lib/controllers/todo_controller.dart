import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo.dart';

enum Filter {
  all,
  active,
  completed,
}

class TodosFilter extends GetxController {
  Rx<Filter> todosFilter = Filter.all.obs;

  static TodosFilter get to => Get.find();
}

class TodosSearch extends GetxController {
  RxString searchTerm = ''.obs;
  TextEditingController searchController;

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  static TodosSearch get to => Get.find();
}

class Todos extends GetxController {
  RxList<Todo> todos = <Todo>[
    Todo(id: '1', text: 'Clean the room'),
    Todo(id: '2', text: 'Do homework'),
    Todo(id: '3', text: 'Wash the dish'),
  ].obs;

  static Todos get to => Get.find();

  void addTodo(String todoText) {
    todos.add(Todo(text: todoText));
  }

  void removeTodo(Todo todo) {
    todos.assignAll(todos.where((t) => t.id != todo.id).toList());
  }

  void toggleTodo(String id) {
    todos.assignAll(todos.map((todo) {
      return todo.id == id
          ? Todo(
              id: id,
              text: todo.text,
              completed: !todo.completed,
            )
          : todo;
    }).toList());
  }

  void editTodo(String id, String desc) {
    todos.assignAll(todos.map((todo) {
      return todo.id == id
          ? Todo(
              id: id,
              text: desc,
              completed: todo.completed,
            )
          : todo;
    }).toList());
  }
}

class ActiveCount extends GetxController {
  RxInt activeCount = 0.obs;

  @override
  void onInit() {
    activeCount.value =
        Todos.to.todos.where((todo) => !todo.completed).toList().length;

    ever(Todos.to.todos, (_) {
      activeCount.value =
          Todos.to.todos.where((todo) => !todo.completed).toList().length;
    });
    super.onInit();
  }

  static ActiveCount get to => Get.find();
}

class FilteredTodos extends GetxController {
  final todos = Todos.to.todos;
  final search = TodosSearch.to.searchTerm;
  final filter = TodosFilter.to.todosFilter;

  RxList<Todo> filteredTodos = <Todo>[].obs;

  static FilteredTodos get to => Get.find();

  @override
  void onInit() {
    filteredTodos.assignAll(todos);

    everAll([todos, search, filter], (_) {
      List<Todo> tempTodos;

      switch (filter.value) {
        case Filter.active:
          tempTodos = todos.where((todo) => !todo.completed).toList();
          break;
        case Filter.completed:
          tempTodos = todos.where((todo) => todo.completed).toList();
          break;
        case Filter.all:
        default:
          tempTodos = todos.toList();
          break;
      }

      if (search.value.isNotEmpty) {
        tempTodos =
            tempTodos.where((t) => t.text.contains(search.value)).toList();
      }

      filteredTodos.assignAll(tempTodos);
    });

    super.onInit();
  }
}
