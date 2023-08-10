import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/hospitality.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kiit.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kims.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kiss.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/temple.dart';
import 'package:hrms/screens/widget/CustomDrawer.dart';

import '../profile_page.dart';

class HomeScreen extends StatefulWidget {
  UserRepository userRepository;
  HomeScreen({super.key, required this.userRepository});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedValue;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _MyBox = Hive.box('data');

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are You Sure ?'),
            content: const Text('Do you Want To Exit The App ?'),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MaterialApp(
                              home: ProfilePage(),
                              debugShowCheckedModeBanner: false,
                            )),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade50,
                  backgroundImage: (() {
                    try {
                      return NetworkImage(
                          "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg");
                    } catch (e) {
                      print("Error loading image: $e");
                      return null;
                    }
                  }()),
                ),
              ),
            ),
          ],
          title: Text(
            'HRMS',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              )),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        crossAxisCount: 2,
                        children: <Widget>[
                          GestureDetector(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: const DecorationImage(
                                        image:
                                            AssetImage("assets/dashboard/4.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const KIIT())));
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/dashboard/3.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const KIIT())));
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/dashboard/5.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const HOSPITALITY())));
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/dashboard/1.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const KIIMS())));
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/dashboard/2.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const TEMPLE())));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
