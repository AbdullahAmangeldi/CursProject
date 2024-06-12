import 'package:flutter/material.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF007172),
      title: Text('Домашние задания'),
    ),);
  }
}
