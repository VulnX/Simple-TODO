import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/edit_task.dart';
import './todo_item.dart';
import './add_task.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('database');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Basic flutter app',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> todosList = [];
  final _box = Hive.box('database');
  final todoController = TextEditingController();
  String title = 'All TODOs';
  List<dynamic> foundToDo = [];

  @override
  void initState() {
    super.initState();
    if (_box.get('todos') != null) {
      todosList = _box.get('todos');
    }
    foundToDo = todosList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddTaskPage(
                      onUpdateTask: handleAddToDoItem,
                    )),
          );
        },
        child: const Icon(
          Icons.add_rounded,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Container buildBody() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          searchBox(),
          toDoSection(),
        ],
      ),
    );
  }

  Expanded toDoSection() {
    return Expanded(
      child: ListView(
        children: [
          titleBuilder(),
          for (dynamic todo in foundToDo.reversed)
            ToDoItem(
              todo: todo,
              toggleToDoState: handleToDoToggle,
              onToDoDelete: handleToDoDelete,
              onToDoUpdate: handleToDoUpdate,
            ),
        ],
      ),
    );
  }

  Container titleBuilder() {
    return Container(
      margin: const EdgeInsets.only(
        top: 50,
        bottom: 20,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
      ),
    );
  }

  void handleToDoToggle(dynamic todo) {
    setState(() {
      todo['done'] = !todo['done'];
    });
    updateDBWithToDos();
  }

  void handleToDoDelete(String id) {
    setState(() {
      todosList.removeWhere((item) => item['id'] == id);
    });
    updateDBWithToDos();
  }

  void runFilter(String keyword) {
    keyword = keyword.trim();
    List<dynamic> result = [];
    if (keyword.isEmpty) {
      result = todosList;
    } else {
      result = todosList
          .where((item) =>
              item['task'].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      foundToDo = result;
    });
  }

  void handleAddToDoItem(dynamic task) {
    setState(() {
      todosList.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'task': task['task'],
        'done': false,
        'tag': task['tag'],
      });
    });
    updateDBWithToDos();
  }

  void handleToDoUpdate(dynamic todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) =>
              EditTaskPage(onUpdateTask: anotherHandle, todo: todo)),
    );
  }

  void anotherHandle() {
    // I have no idea what magic is going on here but when the todo is udpated in `Edit` page it is somehow reflected in the `todoList`
    // My assumpting for this is pass by reference but no idea really.
    setState(() {});
    updateDBWithToDos();
  }

  void updateDBWithToDos() {
    var box = Hive.box('database');
    box.put('todos', todosList);
  }

  Container searchBox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0x33, 0x33, 0x33, 1),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: (query) => runFilter(query),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search_rounded),
          prefixIconConstraints: BoxConstraints(minWidth: 40),
          border: InputBorder.none,
          hintText: 'Search',
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu_rounded),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('images/pfp.png'),
            ),
          ),
        ],
      ),
    );
  }
}
