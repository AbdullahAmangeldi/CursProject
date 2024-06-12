import 'package:flutter/material.dart';

class WeekdayRow extends StatelessWidget {
  final Map<int, String> russianWeekdayNames = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье',
  };

  final int currentDay;
  final Function(int) onTap;

  WeekdayRow({super.key, required this.currentDay, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5, // Adjust as needed
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(5, (index) {
        final day = (index % 5) + 1;
        return GestureDetector(
          onTap: () => onTap(day),
          child: Card(
            elevation: currentDay == day ? 6 : 2,
            color: currentDay == day ? Color(0xFF5ac8c9) : Colors.white,
            child: Center(
              child: Text(
                russianWeekdayNames[day]!,
                style: TextStyle(
                    fontWeight: currentDay == day
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 10),
              ),
            ),
          ),
        );
      }),
    );
  }
}
