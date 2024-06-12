import 'package:cursproject/gradingpage.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите студента'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                height: 100,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const GradingPage(isStudent: false,);
                    }));
                  },
                  child: const Card(
                    child: Center(
                      child: ListTile(
                        title: Text('Аман Избасар'),
                        subtitle: Text('Студент инженер'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
