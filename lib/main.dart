import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers.dart';
import 'package:todo_app/settings.dart';
import 'package:todo_app/providers.dart' as providers;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ColorProvider colorProvider = ColorProvider();
  await colorProvider.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: colorProvider),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Color? currentColor =
          Provider.of<providers.ColorProvider>(context).currentColor;
      return MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: currentColor),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Todo App'),
      );
    });
  }
}

class TodoColl {
  TodoColl({
    required this.id,
    required this.title,
    this.color,
    this.todos = const [],
  });

  final String id;
  final String title;
  final Color? color;
  List<Todo>? todos; //TODO: make this default to []

  static TodoColl fromJson(String e) {
    final json = jsonDecode(e);
    return TodoColl(
      id: json['id'],
      title: json['title'],
      color: json['color'] != null ? Color(json['color']) : Colors.green,
      todos: (json['todos'] as List).map((e) => Todo.fromJson(e)).toList(),
    );
  }
}

class Todo {
  const Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  final String title;
  final String description;
  final bool isDone;

  static Todo fromJson(String e) {
    final json = jsonDecode(e);
    return Todo(
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'] ?? false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  List<TodoColl> todoColls = [
    // const Todo(
    //   title: 'Buy milk',
    //   description: 'Go to the store and buy milk',
    // ),
    // const Todo(
    //   title: 'Buy eggs',
    //   description: 'Go to the store and buy eggs',
    // ),
    // const Todo(
    //   title: 'Buy bread',
    //   description: 'Go to the store and buy bread',
    // ),
  ];

  @override
  void initState() async {
    super.initState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todosString = prefs.getStringList('todoColls');
    if (todosString != null) {
      setState(() {
        todoColls = todosString.map((e) => TodoColl.fromJson(e)).toList();
      });
    }
  }


  //TODO: Save it with shared preferences
  void _addTodo(int collId, String title, String description) {
    setState(() {
      todoColls[collId].todos = [
        ...?todoColls[collId].todos,
        Todo(
          title: title,
          description: description,
        ),
      ];
    });
  }

  void _showAddDialog() {
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addTodo(title, description);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:
                    Provider.of<providers.ColorProvider>(context).currentColor,
              ),
              child: const Text('Todos'),
            ),
            ListTile(
              title: const Text('School'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Work'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          backgroundColor:
              Provider.of<providers.ColorProvider>(context).currentColor,
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Setting()),
                );
              },
            ),
          ]),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Row(children: [
                    Checkbox(value: todo.isDone, onChanged: (checked) => setState(() {
                      todos[index] = Todo(
                        title: todo.title,
                        description: todo.description,
                        isDone: checked ?? false,
                      );
                    })
                    ),
                    Text(todo.title)
                  ]),
                  subtitle: Text(todo.description),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
            const SizedBox(height: 40),
            Expanded(
                child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Row(children: [
                    Checkbox(value: todo.isDone, onChanged: (checked) => setState(() {
                      todos[index] = Todo(
                        title: todo.title,
                        description: todo.description,
                        isDone: checked ?? false,
                      );
                    })
                    ),
                    Text(todo.title)
                  ]),
                  subtitle: Text(todo.description),
                );
              },
            ))
            // const Text(
            //   'You have clicked the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class TodoList extends StatelessWidget {
//   const TodoList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         const TodoItem(
//           title: 'Buy milk',
//           description: 'Go to the store and buy milk',
//         ),
//         const TodoItem(
//           title: 'Buy eggs',
//           description: 'Go to the store and buy eggs',
//         ),
//         const TodoItem(
//           title: 'Buy bread',
//           description: 'Go to the store and buy bread',
//         ),
//       ],
//     );
//   }
// }
