import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:hrms/screens/main_screen/nav_bar/history.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/dashboard.dart';
import 'package:hrms/screens/main_screen/nav_bar/profile_page.dart';
import 'package:hrms/screens/main_screen/nav_bar/task_page.dart';

class MyApp extends StatefulWidget {
  UserRepository userRepository;
  MyApp({
    super.key,
    required this.userRepository,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Widget _screen2 = const DailyPage();
  final Widget _screen3 = const History();
  final Widget _screen4 = ProfilePage();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are You Sure ?'),
            content: const Text('Do you want to Exit the app ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Widget screen1 = HomeScreen(userRepository: widget.userRepository);
    final screens = [
      HomeScreen(
        userRepository: widget.userRepository,
      ),
      DailyPage(),
      History(),
      ProfilePage(),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: screens[selectedIndex],
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.green.shade100,
                labelTextStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ))),
            child: NavigationBar(
              height: 62,
              backgroundColor: Colors.white,
              elevation: 2,
              selectedIndex: selectedIndex,
              animationDuration: Duration(seconds: 1),
              onDestinationSelected: (index) {
                setState(() {
                  this.selectedIndex = index;
                });
              },
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  selectedIcon: Icon(Icons.home),
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border_outlined),
                  label: 'Benefit',
                  selectedIcon: Icon(Icons.favorite),
                ),
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'History',
                  selectedIcon: Icon(Icons.home),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                  selectedIcon: Icon(Icons.person),
                ),
              ],
            ),
          )),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return HomeScreen(userRepository: widget.userRepository);
    } else if (selectedIndex == 1) {
      return _screen2;
    } else if (selectedIndex == 2) {
      return _screen3;
    }
    return _screen4;
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
