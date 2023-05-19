import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/task_provider.dart';

import './screens/login_screen.dart';
import './screens/list_screen.dart';

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
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (cntxt) => const LoginScreen(),
          ListScreen.routeName: (cntxt) => const ListScreen(),
        },
      ),
    );
  }
}
