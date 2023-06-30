import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/user.dart';
import './providers/task_provider.dart';

import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/home_screen.dart';
import './screens/add_task_screen.dart';
import './screens/loading_screen.dart';

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
          create: (cntxt) => User(),
        ),
        ChangeNotifierProxyProvider<User, TaskProvider>(
          create: (cntxt) => TaskProvider(email: null, token: null, tasks: []),
          update: (cntxt, userData, previousTaks) => TaskProvider(
            email: userData.getEmail(),
            token: userData.getToken(),
            tasks: previousTaks != null ? previousTaks.tasks : [],
          ),
        ),
      ],
      child: Consumer<User>(
        builder: (cnntxt, user, child) {
          return MaterialApp(
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
                    color: Colors.red,
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
            home: user.token != null
                ? const HomeScreen()
                : FutureBuilder(
                    future: user.tryAutoLogin(),
                    builder: (cntxt, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingScreen();
                      } else {
                        return const LoginScreen();
                      }
                    },
                  ),
            routes: {
              HomeScreen.routeName: (cntxt) => const HomeScreen(),
              LoginScreen.routeName: (cntxt) => const LoginScreen(),
              RegistrationScreen.routeName: (cntxt) =>
                  const RegistrationScreen(),
              AddTaskScreen.routeName: (cntxt) => const AddTaskScreen(),
            },
          );
        },
      ),
    );
  }
}
