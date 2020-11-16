# Todo App with GetX

### Actions
- Add TODO, Edit TODO, Remove TODO, Toggle TODO
- Search TODOs
- Filter TODOs
  - All, Active, Completed

### States
- TODOs
- State of each item (completed or not)
- Computed states
  - The number of uncompleted items
  - Filtered TODOS (filtered by search term and filter)

### Approach
- Granular control
  - One controller for one state

- Heavy use of to static method
  - static MyController get to => Get.find();
  - This allows you to easily access other controllers.

- Automatic update of computed states (states cascading...)
  - For this, we’ll use workers – ever and everAll

### Uses
- Bindings class
- Get.create
  - permanent: true, isSingleton: false
- Get.put (Get.putAsync)
  - permanent: false, isSingleton: true