import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditSubjectDialog extends StatefulWidget {
  final Map<String, dynamic> subject;

  const EditSubjectDialog({Key? key, required this.subject}) : super(key: key);

  @override
  _EditSubjectDialogState createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends State<EditSubjectDialog> {
  late TextEditingController subjNameController;
  late TextEditingController dayController;
  late TextEditingController periodController;
  late TextEditingController teacherNameController;

  @override
  void initState() {
    super.initState();
    subjNameController = TextEditingController(text: widget.subject['subjName']);
    dayController = TextEditingController(text: widget.subject['day'].toString());
    periodController = TextEditingController(text: widget.subject['period'].toString());
    teacherNameController = TextEditingController(text: widget.subject['teacherName']);
  }

  @override
  void dispose() {
    subjNameController.dispose();
    dayController.dispose();
    periodController.dispose();
    teacherNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(insetPadding: EdgeInsets.zero,

      title: const Text('Изменить Предмет'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            TextField(
              controller: subjNameController,
              decoration: const InputDecoration(labelText: 'Название Предмета'),
            ),
            TextField(
              style: const TextStyle(fontFamily: ''),
              controller: teacherNameController,
              decoration: const InputDecoration(labelText: 'Имя Учителя'),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                SizedBox(width: 20,),

                TextButton(
                  onPressed: () {
                    _saveSubject();
                  },
                  child: const Text('Сохранить'),
                ),

                TextButton(
                  onPressed: () {
                    _cancelSubject();
                  },
                  child: const Text('Отменить Предмет'),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveSubject() async {
    final updatedSubject = {
      'id': widget.subject['id'],
      'subjName': subjNameController.text,
      'day': int.parse(dayController.text),
      'period': int.parse(periodController.text),
      'teacherName': teacherNameController.text,
    };

    final url = Uri.https('courseapp-9fcdf-default-rtdb.firebaseio.com', 'subjects/${widget.subject['id']}.json');
    final response = await http.put(url, body: json.encode(updatedSubject));

    if (response.statusCode == 200) {
      // Успешно обновлен предмет
      Navigator.of(context).pop(updatedSubject);
    } else {
      // Не удалось обновить предмет
      print('Не удалось обновить предмет: ${response.statusCode}');
      // Можно обработать ошибку здесь
    }
  }

  void _cancelSubject() async {
    final cancelledSubject = {
      'id': '0',
      'subjName': subjNameController.text,
      'day': int.parse(dayController.text),
      'period': 17,
      'teacherName': teacherNameController.text,
      'cancelled': true,
    };

    final url = Uri.https('courseapp-9fcdf-default-rtdb.firebaseio.com', 'subjects/${widget.subject['id']}.json');
    final response = await http.put(url, body: json.encode(cancelledSubject));

    if (response.statusCode == 200) {
      // Успешно отменен предмет
      Navigator.of(context).pop(cancelledSubject);
    } else {
      // Не удалось отменить предмет
      print('Не удалось отменить предмет: ${response.statusCode}');
      // Можно обработать ошибку здесь
    }
  }
}
