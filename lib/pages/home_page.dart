import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos_get/controllers/todo_controller.dart';
import 'package:todos_get/controllers/toggle_textfield_controller.dart';
import 'package:todos_get/models/todo.dart';

class HomePage extends StatelessWidget {
  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  Header(),
                  TextField(
                    controller: newTodoController,
                    decoration: InputDecoration(
                      labelText: 'What to do?',
                    ),
                    onSubmitted: (value) {
                      Todos.to.addTodo(value);
                      newTodoController.clear();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  SearchAndFilter(),
                  Obx(() {
                    final currentTodos = FilteredTodos.to.filteredTodos;

                    return ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: currentTodos.length,
                      itemBuilder: (context, i) {
                        return Dismissible(
                          key: ValueKey(currentTodos[i].id),
                          onDismissed: (_) {
                            Todos.to.removeTodo(currentTodos[i]);
                          },
                          confirmDismiss: (_) {
                            return Get.defaultDialog(
                              title: 'Are you sure?',
                              middleText: 'Do you really want to delete',
                              actions: [
                                FlatButton(
                                  child: Text('YES'),
                                  onPressed: () {
                                    return Get.back(result: true);
                                  },
                                ),
                                FlatButton(
                                  child: Text('NO'),
                                  onPressed: () {
                                    return Get.back(result: false);
                                  },
                                ),
                              ],
                            );
                          },
                          child: TodoItem(currentTodos[i]),
                        );
                      },
                      separatorBuilder: (context, i) => Divider(
                        color: Colors.grey,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TODO',
          style: TextStyle(fontSize: 40),
        ),
        Obx(
          () => Text(
            '${ActiveCount.to.activeCount} items left',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}

class SearchAndFilter extends StatelessWidget {
  Color textColor(Filter value) {
    final todoListFilter = TodosFilter.to.todosFilter;

    return todoListFilter.value == value ? Colors.blue : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TodosSearch.to.searchController,
          decoration: InputDecoration(
            labelText: 'Search Todos ...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onChanged: (value) {
            TodosSearch.to.searchTerm.value = value;
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Obx(
                () => Text(
                  'ALL',
                  style: TextStyle(
                    color: textColor(Filter.all),
                    fontSize: 18.0,
                  ),
                ),
              ),
              onPressed: () {
                TodosFilter.to.todosFilter.value = Filter.all;
              },
            ),
            FlatButton(
              child: Obx(
                () => Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: textColor(Filter.active),
                    fontSize: 18.0,
                  ),
                ),
              ),
              onPressed: () {
                TodosFilter.to.todosFilter.value = Filter.active;
              },
            ),
            FlatButton(
              child: Obx(
                () => Text(
                  'COMPLETED',
                  style: TextStyle(
                    color: textColor(Filter.completed),
                    fontSize: 18.0,
                  ),
                ),
              ),
              onPressed: () {
                TodosFilter.to.todosFilter.value = Filter.completed;
              },
            ),
          ],
        ),
      ],
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  const TodoItem(this.todo);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToggleTextfieldController>(builder: (controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Focus(
          focusNode: controller.itemFocusNode,
          onFocusChange: (value) {
            if (value) {
              controller.textEditingController.text = todo.text;
            } else {
              Todos.to.editTodo(todo.id, controller.textEditingController.text);
            }
          },
          child: ListTile(
            onTap: () {
              controller.requestFocus();
            },
            leading: Checkbox(
              value: todo.completed,
              onChanged: (value) {
                Todos.to.toggleTodo(todo.id);
              },
            ),
            title: controller.itemFocusNode.hasFocus
                ? TextField(
                    controller: controller.textEditingController,
                    autofocus: true,
                    focusNode: controller.textFieldFocusNode,
                  )
                : Text(todo.text),
          ),
        ),
      );
    });
  }
}
