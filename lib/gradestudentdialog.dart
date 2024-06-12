import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class GradeDialog extends StatefulWidget {
  final Map<String, dynamic> subject;

  const GradeDialog({Key? key, required this.subject}) : super(key: key);

  @override
  _GradeDialogState createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {
  TextEditingController commentController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Оценить студента'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: gradeController,
            decoration: InputDecoration(labelText: 'Оценка'),
          ),
          TextField(
            controller: commentController,
            decoration: InputDecoration(labelText: 'Комментарий (необязательно)'),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    setState(() {
                      gradeController.text = '100';
                      commentController.text = 'Отлично!';
                    });
                  },
                  child: Center(
                    child: Text(
                      '100',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.lightGreen,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    setState(() {
                      gradeController.text = '90';
                      commentController.text = 'Превосходно!';
                    });
                  },
                  child: Center(
                    child: Text(
                      '90',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    setState(() {
                      gradeController.text = '70';
                      commentController.text = 'Хорошо';
                    });
                  },
                  child: Center(
                    child: Text(
                      '70',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    setState(() {
                      gradeController.text = '50';
                      commentController.text = 'Постарайся';
                    });
                  },
                  child: Center(
                    child: Text(
                      '50',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            _saveGrade();
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }

  void _saveGrade() async {
    final gradeData = {
      'id': widget.subject['id'],
      'subjName': widget.subject['subjName'],
      'day': widget.subject['day'],
      'period': '11${gradeController.text}',
      'teacherName': widget.subject['teacherName'],
      'grade': '11${gradeController.text}',
      'comment': commentController.text,
    };

    final url = Uri.https('courseapp-9fcdf-default-rtdb.firebaseio.com',
        'courses/${widget.subject['id']}.json');

    final response = await http.put(url, body: json.encode(gradeData));

    if (response.statusCode == 200) {
      print('пангея');
      // Успешно сохранено
      Navigator.of(context).pop();
    } else {
      // Ошибка при сохранении
      print('Ошибка при сохранении оценки: ${response.statusCode}');
      // Дополнительно можно обработать ошибку здесь
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    gradeController.dispose();
    super.dispose();
  }
}
