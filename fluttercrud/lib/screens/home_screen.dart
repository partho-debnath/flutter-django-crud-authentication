import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../providers/user.dart';

import './list_screen.dart';
import './favorite_screen.dart';
import './complete_screen.dart';
import './add_task_screen.dart';

enum SelectedOptions { logout }

class HomeScreen extends StatelessWidget {
  static const String routeName = '/list-screen';
  const HomeScreen({super.key});

  Future<bool?> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          icon: const Icon(Icons.logout),
          title: const Text('Are you sure?'),
          content: const Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(true);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void startAddTaskScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AddTaskScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final TaskProvider userTaskProvider = Provider.of<TaskProvider>(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Tasks'),
          actions: [
            IconButton(
              onPressed: () {
                startAddTaskScreen(context);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<SelectedOptions>(
              onSelected: (SelectedOptions selectedOptions) {
                switch (selectedOptions) {
                  case SelectedOptions.logout:
                    showLogoutDialog(context).then(
                      (value) {
                        if (value == true) {
                          userTaskProvider.clear();
                          Provider.of<User>(context, listen: false).logout();
                        }
                      },
                    );
                }
              },
              itemBuilder: (cntxt) {
                return [
                  const PopupMenuItem<SelectedOptions>(
                    value: SelectedOptions.logout,
                    child: Text('Logout'),
                  ),
                ];
              },
              child: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            splashBorderRadius: BorderRadius.circular(50),
            indicatorColor: Colors.amber,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(
                text: 'Task List',
                icon: Icon(Icons.list),
              ),
              Tab(
                text: 'Favorite Task',
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              Tab(
                text: 'Completed Task',
                icon: Icon(Icons.done),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: userTaskProvider.fetchTask(),
          builder: (cntxt, spanshot) {
            if (spanshot.connectionState == ConnectionState.waiting) {
              return const TabBarView(
                children: [
                  Center(child: CircularProgressIndicator()),
                  Center(child: CircularProgressIndicator()),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (spanshot.hasData) {
              return const TabBarView(
                children: [
                  ListScreen(),
                  FavoriteScreen(),
                  CompleteScreen(),
                ],
              );
            }
            return const TabBarView(
              children: [
                Center(child: Text('There is something wrong!')),
                Center(child: Text('There is something wrong!')),
                Center(child: Text('There is something wrong!')),
              ],
            );
          },
        ),
      ),
    );
  }
}
