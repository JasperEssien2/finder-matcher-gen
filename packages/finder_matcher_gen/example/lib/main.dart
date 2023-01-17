import 'package:example/models.dart';
import 'package:example/widgets.dart';
import 'package:finder_matcher_annotation/finder_matcher_annotation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        sliderTheme: const SliderThemeData(
          trackHeight: 10,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tasks = <TaskModel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Tasks')),
      body: tasks.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0).copyWith(bottom: 100),
                child: const Text(
                  "Your task list is empty. Tap on the 'Add Task' button to add a task.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : TaskListView(tasks: tasks),
      floatingActionButton: AppFloatingActionButton(
        onPress: () async {
          final newTask = await showModalBottomSheet(
            context: context,
            builder: (c) => const AddTargetBottomSheet(),
          );

          if (newTask != null) {
            tasks.add(newTask);

            setState(() {});
          }
        },
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @MatchDeclaration()
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => ItemTask(taskModel: tasks[index]),
      physics: const BouncingScrollPhysics(),
    );
  }
}
