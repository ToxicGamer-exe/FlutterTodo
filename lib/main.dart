import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers.dart';
import 'package:todo_app/settings.dart';
import 'package:todo_app/providers.dart' as providers;
import 'package:provider/provider.dart';
import 'package:todo_app/types.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ColorProvider>(
      create: (context) {
        final colorProvider = ColorProvider();
        colorProvider.init();
        return colorProvider;
      },
    ),
    ChangeNotifierProvider<TodoProvider>(
      create: (context) {
        final todoProvider = TodoProvider();
        todoProvider.init();
        return todoProvider;
      },
    ),
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
  TodoColl? currentTodoColl;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todosString = prefs.getStringList('todoColls');
    if (todosString != null) {
      setState(() {
        TodoProvider().todoColls =
            Provider.of<TodoProvider>(context, listen: false).todoColls =
            todosString
                .map((e) => TodoColl.fromJson(jsonDecode(e)))
                .toList();
        currentTodoColl = TodoProvider().getCurrentTodoColl();
        todos = currentTodoColl?.todos ?? [];
      });
    }
  }

  void _addTodo(String collName, String title, String description) async {
    TodoColl coll =
        TodoProvider().todoColls.firstWhere((coll) => coll.name == collName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coll.todos = [
        ...?coll.todos,
        Todo(
          title: title,
          description: description,
        ),
      ];
    });

    //TODO: This needs some optimalization man... I can't save all the collections just because I added one todo xD
    prefs.setStringList(
      'todoColls',
      TodoProvider().todoColls.map((e) => jsonEncode(e)).toList(),
    );
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
                _addTodo('School', title, description);
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
            //TODO: Decide whether to show it on a separate page or just change the state
            for (int i = 0; i < TodoProvider().todoColls.length; i++)
              ListTile(
                title: Text(TodoProvider().todoColls[i].name),
                onTap: () {
                  //change the state of the app to show todos in currently selected collection
                    Provider.of<providers.TodoProvider>(context, listen: false)
                        .setCurrentTodoColl(TodoProvider().todoColls[i].name);
                  setState(() {
                    currentTodoColl = Provider.of<providers.TodoProvider>(context, listen: false).getCurrentTodoColl();
                    todos = currentTodoColl?.todos ?? [];
                  });
                  // Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TodoCollPage(
                  //       todoColl: todoColls[i],
                  //       index: i,
                  //     ),
                  //   ),
                  // );
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
          actions: currentTodoColl == null ? [] : [
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

          children: currentTodoColl == null ? [const Center(child: Text('Please select collection!'))] :
          todos.isEmpty
              ? [const Center(child: Text('No todos yet!'))]
              : <Widget>[
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Row(children: [
                          Checkbox(
                              value: todo.isDone,
                              onChanged: (checked) => setState(() {
                                    todos[index] = Todo(
                                      title: todo.title,
                                      description: todo.description,
                                      isDone: checked ?? false,
                                    );
                                  })),
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
                          Checkbox(
                              value: todo.isDone,
                              onChanged: (checked) => setState(() {
                                    todos[index] = Todo(
                                      title: todo.title,
                                      description: todo.description,
                                      isDone: checked ?? false,
                                    );
                                  })),
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
      floatingActionButton: currentTodoColl == null
          ? null
          : FloatingActionButton(
              onPressed: _showAddDialog,
              tooltip: 'Add',
              child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}