import 'dart:convert';

import 'package:cursproject/gradestudentdialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class GradingPage extends StatefulWidget {
  const GradingPage({Key? key, required this.isStudent}) : super(key: key);
  final bool isStudent;

  @override
  State<GradingPage> createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {
  Map<int, List<Map<String, dynamic>>> subjByDay = {};
  int currentDay = 1;

  void setCurrentDay(int day) {
    setState(() {
      currentDay = day;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSubjData();
  }

  void fetchSubjData() async {
    try {
      final subjectsData = await _loadItems();
      setState(() {
        subjByDay = subjectsData;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<Map<int, List<Map<String, dynamic>>>> _loadItems() async {
    final url = Uri.https(
        'courseapp-9fcdf-default-rtdb.firebaseio.com', 'courses.json');
    final response = await http.get(url);
    final subjectsData = json.decode(response.body) as Map<String, dynamic>;
    final Map<int, List<Map<String, dynamic>>> subjectsByDay = {
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
    };

    subjectsData.forEach((key, value) {
      final subject = {
        'id': key,
        'subjName': value['subjName'],
        'day': value['day'],
        'period': value['period'],
        'teacherName': value['teacherName'],
      };
      subjectsByDay[subject['day']]!.add(subject);
    });

    return subjectsByDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setCurrentDay(currentDay > 1 ? currentDay - 1 : 1);
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setCurrentDay(currentDay < 5 ? currentDay + 1 : 5);
            },
          ),
        ],
      ),
      body: (subjByDay.isNotEmpty) ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: (subjByDay.isEmpty) ? 0 : 5,
          itemBuilder: (context, index) {
            final subject = subjByDay[currentDay]![index];
            return InkWell(
              onTap: () async {
                if (subject['period'] != 17 && !widget.isStudent) {
                  await showDialog(
                    context: context,
                    builder: (context) => GradeDialog(subject: subject),
                  );
                  fetchSubjData();
                } if (widget.isStudent){ } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 1000),
                      content: Text(
                        'Урок отменён',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: ListTile(
                trailing: Text(
                    (subject['period'].toString().length >= 3) ? subject['period'].toString().substring(2) : ''),
                key: Key(subject['id']),
                title: Text(
                  subject['subjName'] ?? '',
                  style: TextStyle(
                    color: subject['period'] == 17 ? Colors.grey : Colors.black,
                  ),
                ),
                subtitle: Text(
                  subject['period'] != 17 ? subject['teacherName'] : 'Урок отменён',
                  style: TextStyle(
                    fontFamily: '',
                    color: subject['period'] == 17 ? Colors.grey : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }
}

