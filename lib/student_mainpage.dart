import 'package:cursproject/assignments_page.dart';
import 'package:cursproject/courses.dart';
import 'package:cursproject/gradingpage.dart';
import 'package:cursproject/homework_dialog.dart';
import 'package:cursproject/subject_edit_dialog.dart';
import 'package:cursproject/weekrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'gradespage.dart';
import 'dart:math';

List<String> selectedCourses = [];
List<bool> isSelected = List.generate(5, (index) => false);

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({Key? key, required this.isStudent}) : super(key: key);

  final bool isStudent;

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  Map<int, List<Map<String, dynamic>>> subjByDay = {};
  int currentDay = 1;
   List<String> timeList = ['8:00-9:20'
  ,'9:30-10:50',
  '11:00-12:20',
      '13:00-14:20', '14:30-15:50', '15:00-16:20'];
  final Map<int, String> russianMonthNumbers = {
    1: 'Январь',
    2: 'Февраль',
    3: 'Март',
    4: 'Апрель',
    5: 'Май',
    6: 'Июня',
    7: 'Июля',
    8: 'Августа',
    9: 'Сентябрь',
    10: 'Октябрь',
    11: 'Ноябрь',
    12: 'Декабрь',
  };
  final List<String> groupNames = ['РПОД21-К',
    'РПО21-К', 'ТИС-20К', 'П3К', 'СВТ24', 'ТИБД'];

  List<String> courseNames = [
    'Математика',
    'Физика',
    'Химия',
    'Литература',
    'История',
  ];

  void updateSelectedCourses(String courseName) {
    setState(() {
      if (selectedCourses.contains(courseName)) {
        selectedCourses.remove(courseName);
      } else {
        selectedCourses.add(courseName);
      }
    });
  }

  String _generateTeacherName() {
    // List of Kazakh names
    List<String> names = [
      'Айдос',
      'Айнұр',
      'Данияр',
      'Нұрлан',
      'Маржан',
      'Назерке',
      'Сабит',
      'Айжан',
      'Марат',
      'Арман',
      // Add more names as needed
    ];

    // List of Kazakh surnames
    List<String> surnames = [
      'Сайлаубаев',
      'Ерсайынов',
      'Жұмабаев',
      'Қажимұратов',
      'Төлеубаев',
      'Сұлтанов',
      'Қанатұлы',
      'Жігербаев',
      'Мағжанұлы',
      'Әділбеков',
      // Add more surnames as needed
    ];

    // Randomly select a name and surname from the lists
    String name = names[Random().nextInt(names.length)];
    String surname = surnames[Random().nextInt(surnames.length)];

    // Concatenate the name and the first letter of the surname
    return '$name ${surname[0]}.';
  }



  final Map<int, String> russianWeekdayNames = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье',
  };

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

  int getWeekOfMonth(DateTime date) {
    int weekNumber = date.weekday;
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int firstWeekNumber = firstDayOfMonth.weekday;
    int weekOfMonth = ((weekNumber + 6 - firstWeekNumber) / 7).floor() + 1;
    return weekOfMonth;
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
    final bool isStudent = widget.isStudent;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF007172),
        title: Text((widget.isStudent) ? 'Студент' : 'Учитель'),
      ),
      body: (subjByDay.isNotEmpty)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(),
                    SizedBox(
                      width: 10,
                    ),
                    Text((widget.isStudent)
                        ? 'Привет, Нурай!'
                        : 'Привет, Акбота!')
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
               (isStudent)? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.pinkAccent),
                          height: 80,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '126',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  'баллов',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueAccent),
                          height: 80,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '96%',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  'Успеваемость',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green),
                          height: 80,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '44',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  'награды',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ) :Spacer(),
                WeekdayRow(
                  currentDay: currentDay,
                  onTap: (day) {
                    setState(() {
                      currentDay = day;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ( isStudent) ?Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 1,
                    child: Container(
                      height: 75,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFEBF2F8)
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text('Будь разумен, укрепляй свой дух в борьбе, лишь бездарный покоряется судьбе'),
                            Text('Абай Кунанбаев')
                          ],
                        ),
                      ),
                    ),
                  ),
                ) : SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Расписание',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Сегодня, ${(DateTime.now().day)} ${(russianMonthNumbers[DateTime.now().month])}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,

                  child: (!widget.isStudent)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.separated(
                            // physics: const FixedExtentScrollPhysics() ,z
                            itemCount: 5 ?? 0,
                            itemBuilder: (context, index) {
                              final subject = subjByDay[currentDay]![index];

                              return (selectedCourses
                                          .contains(subject['subjName']) ||
                                      selectedCourses.isEmpty)
                                  ? InkWell(
                                      onLongPress: () async {
                                        if (subject['period'] != 17 &&
                                            !widget.isStudent) {
                                          await showDialog(
                                            context: context,
                                            builder: (context) =>
                                                EditSubjectDialog(
                                                    subject: subject),
                                          );
                                          fetchSubjData();
                                        } else if (!widget.isStudent) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 1000),
                                              content: Text('Урок отменён',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 90,
                                              width: 15,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFC9BEBEFF),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      (index + 1).toString())),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,

                                              children: [
                                                Text(timeList[index], textAlign: TextAlign.left,),
                                                Text(
                                                   groupNames[index],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text('Группа', textAlign: TextAlign.left,)
                                              ],
                                            ),
                                            Spacer(),
                                            Container(
                                              height: 90,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.greenAccent,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                      '605', style: TextStyle(color: Colors.white),)),
                                            ),
                                            SizedBox(width: 5,)
                                          ],
                                        ),
                                      ),
                                      // ListTile(
                                      //   key: Key(subject['id']),
                                      //   title: Text(
                                      //     subject['subjName'] ?? '',
                                      //     style: TextStyle(
                                      //       color: subject['period'] == 17
                                      //           ? Colors.grey
                                      //           : Colors.black,
                                      //     ),
                                      //   ),
                                      //   subtitle: Text(
                                      //     subject['period'] != 17
                                      //         ? subject['teacherName']
                                      //         : 'Урок отменён',
                                      //     style: TextStyle(
                                      //         color: subject['period'] == 17
                                      //             ? Colors.grey
                                      //             : Colors.black,
                                      //         fontSize: 12,
                                      //         fontFamily: ''),
                                      //   ),
                                      // ),
                                    )
                                  : const Spacer();
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.separated(
                            itemCount: (subjByDay.isEmpty) ? 0 : 5,
                            itemBuilder: (context, index) {
                              final subject = subjByDay[currentDay]![index];
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 90,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFC9BEBEFF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child:
                                                Text((index + 1).toString())),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Text(timeList[index], textAlign: TextAlign.left,),
                                          Text(
                                            subject['subjName'] ?? '',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text('Группа', textAlign: TextAlign.left,)
                                        ],
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 90,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                              '605', style: TextStyle(color: Colors.white),)),
                                      ),
                                      SizedBox(width: 5,)
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                          ),
                        ),
                ),
                Spacer(),
              (!isStudent) ?Material(
                  elevation: 5,
                  child: Container(

                    width: double.infinity,
                    height: 70,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: InkWell(

                              child: Column(
                                children: [Icon(Icons.book_outlined, size: 30, color: Colors.purple,), Text('Расписание', style: TextStyle(color: Colors.purple),)],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Center(
                            child: InkWell(

                              child: Column(
                                children: [Icon(Icons.star_border_outlined, size: 30,), Text('Оценки', )],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return GradesPage();}));
                              },
                            ),
                          ),
                          Center(
                            child: InkWell(

                              child: Column(
                                children: [Icon(Icons.menu_book_sharp, size: 30,), Text('Дом. задания', )],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {return HomeworkDialog();}));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                // (!widget.isStudent)
                //     ? InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //               builder: (context) => const GradesPage()));
                //         },
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(2),
                //             color: Color(0xFF55c7c7),
                //           ),
                //           width: double.infinity,
                //           height: 50,
                //           child: const Center(
                //             child: Text('Оценки',
                //                 style: TextStyle(color: Colors.white70)),
                //           ),
                //         ),
                //       )
                //     : const SizedBox(),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => CoursesPage(
                //               isStudent: widget.isStudent,
                //             )));
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(2),
                //         color: Color(0xFF00b0ae)),
                //     width: double.infinity,
                //     height: 50,
                //     child: const Center(
                //       child: Text('Курсы',
                //           style: TextStyle(color: Colors.white70)),
                //     ),
                //   ),
                // ),
              : Material(
                elevation: 5,
                child: Container(

                  width: double.infinity,
                  height: 70,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: InkWell(

                            child: Column(
                              children: [Icon(Icons.book_outlined, size: 30, color: Colors.purple,), Text('Расписание', style: TextStyle(color: Colors.purple),)],
                            ),
                            onTap: () {},
                          ),
                        ),
                        Center(
                          child: InkWell(

                            child: Column(
                              children: [Icon(Icons.star_border_outlined, size: 30,), Text('Оценки', )],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return GradingPage(isStudent: true,);}));
                            },
                          ),
                        ),
                        Center(
                          child: InkWell(

                            child: Column(
                              children: [Icon(Icons.menu_book_sharp, size: 30,), Text('Дом. задания', )],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {return AssignmentsPage();}));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
