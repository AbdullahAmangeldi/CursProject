import 'package:cursproject/student_mainpage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(

                'Добро \nпожаловать:)',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),

                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: loginController,
                decoration: const InputDecoration(
                  labelText: 'Логин',
                  focusedBorder: OutlineInputBorder(
                  ),
                  enabledBorder: OutlineInputBorder(
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(

                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0),),

                  labelText: 'Пароль',
                  focusedBorder: const OutlineInputBorder(
                  ),
                  enabledBorder: const OutlineInputBorder(
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 20),
              ElevatedButton(

                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),


                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  if (loginController.text.trim() == 'teacher' &&
                      passwordController.text.trim() == 'teacher') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const StudentMainPage(
                                isStudent: false,
                              )),
                    );
                  } else if (loginController.text.trim() == 'student' &&
                      passwordController.text.trim() == 'student') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const StudentMainPage(
                                isStudent: true,
                              )),
                    );
                  }
                },
                child: const Text(
                  'Войти',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
