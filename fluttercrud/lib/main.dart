import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/task_provider.dart';

import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/home_screen.dart';
import './screens/add_task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Django-Flutter',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.white,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.white,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Colors.red,
              ),
            ),
          ),
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (cntxt) => const LoginScreen(),
          HomeScreen.routeName: (cntxt) => const HomeScreen(),
          RegistrationScreen.routeName: (cntxt) => const RegistrationScreen(),
          AddTaskScreen.routeName: (cntxt) => const AddTaskScreen(),
        },
      ),
    );
  }
}
