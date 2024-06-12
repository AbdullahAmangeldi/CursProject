import 'package:flutter/material.dart';

class HomeworkDialog extends StatefulWidget {
  @override
  _HomeworkDialogState createState() => _HomeworkDialogState();
}

class _HomeworkDialogState extends State<HomeworkDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Создание домашнего задания'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Описание'),
          ),
          TextField(
            controller: _dueDateController,
            decoration: InputDecoration(labelText: 'Срок выполнения'),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                setState(() {
                  _dueDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            // Implement the logic to save the homework assignment
            String title = _titleController.text;
            String description = _descriptionController.text;
            String dueDate = _dueDateController.text;

            // For demonstration purposes, print the values to the console
            print("Название: $title");
            print("Описание: $description");
            print("Срок выполнения: $dueDate");

            Navigator.of(context).pop();
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}