import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key, required this.isStudent}) : super(key: key);

  final bool isStudent;

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final url = Uri.https(
        'courseapp-9fcdf-default-rtdb.firebaseio.com', 'course_list.json');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    final List<Map<String, dynamic>> fetchedCourses = [];

    if (responseData != null) {
      responseData.forEach((key, value) {
        fetchedCourses.add({
          'id': key,
          'name': value['name'],
          'description': value['description'],
        });
      });
    }

    setState(() {
      courses = fetchedCourses;
    });
  }

  Future<void> addCourse(String name, String description, String hours) async {
    final url = Uri.https(
        'courseapp-9fcdf-default-rtdb.firebaseio.com', 'course_list.json');
    final response = await http.post(
      url,
      body: json.encode({
        'name': name,
        'description': description,
        'hours': hours,
      }),
    );

    if (response.statusCode == 200) {
      // Course added successfully
      // You can perform any additional actions here, such as updating the UI
    } else {
      // Handle error
      // You can display an error message or perform other actions based on the response status code
    }

    await fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Курсы'),
        actions: [
          ( !widget.isStudent )? IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => AddCourseDialog(onAddCourse: addCourse),
              );
            },
            icon: const Icon(Icons.add),
          ) : Spacer()
        ],
      ),
      body: (courses.isNotEmpty) ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              height: 100,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Card(
                  child: Center(
                    child: ListTile(
                      trailing: Text(
                        course['hours'] ?? '',
                      ),
                      title: Text(course['name'] ?? ''),
                      subtitle: Text(course['description'] ?? ''),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ) : Center(child: CircularProgressIndicator(),)
    );
  }
}

class AddCourseDialog extends StatefulWidget {
  final Function(String name, String description, String hours) onAddCourse;

  const AddCourseDialog({required this.onAddCourse, Key? key})
      : super(key: key);

  @override
  _AddCourseDialogState createState() => _AddCourseDialogState();
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить курс'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
          ),
          TextField(
            controller: _hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Часы'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            final name = _nameController.text;
            final description = _descriptionController.text;
            final hours = (_hoursController.text);
            if (name.isNotEmpty && description.isNotEmpty && hours.isNotEmpty) {
              await widget.onAddCourse(name, description, hours);
              setState(() {});
              Navigator.of(context).pop();

            } else {
              // Show error message
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }
}
