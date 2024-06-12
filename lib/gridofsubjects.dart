// import 'package:cursproject/student_mainpage.dart';
// import 'package:flutter/material.dart';
//
// class CourseGrid extends StatefulWidget {
//   const CourseGrid({Key? key, }) : super(key: key);
//
//
//
//
//   @override
//   _CourseGridState createState() => _CourseGridState();
// }
//
// class _CourseGridState extends State<CourseGrid> {
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       crossAxisCount: 3, // Adjust as needed
//       childAspectRatio: 2.5, // Adjust aspect ratio for width and height
//       children: List.generate(
//         courseNames.length,
//             (index) {
//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (isSelected[index]) {
//                   isSelected[index] = false;
//                   selectedCourses.remove(courseNames[index]);
//                 } else {
//                   int selectedCount = isSelected.where((element) => element).length;
//                   if (selectedCount < 3) {
//                     isSelected[index] = true;
//                     selectedCourses.add(courseNames[index]);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('You can select up to 3 subjects at a time.'),
//                       ),
//                     );
//                   }
//                 }
//
//               });
//             },
//
//             child: Card(
//               elevation: isSelected[index] ? 6 : 2,
//               color: isSelected[index] ? Colors.blue[200] : Colors.white,
//               child: Center(
//                 child: Text(
//                   courseNames[index],
//                   style: TextStyle(
//                     fontWeight: isSelected[index] ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
