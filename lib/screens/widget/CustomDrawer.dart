import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kims.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kiss.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/temple.dart';

import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/auth_bloc/auth_event.dart';
import '../main_screen/nav_bar/Dashboard/hospitality.dart';
import '../main_screen/nav_bar/Dashboard/kiit.dart';
import '../main_screen/nav_bar/profile_page.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _MyBox = Hive.box('data');
  final _mybox = Hive.box('data');
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/kiit_sideNav2.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
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
                      maxRadius: 40,
                      backgroundImage: NetworkImage(
                          "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_MyBox.get("username")}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '${_MyBox.get("department")}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('KIIT'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const KIIT())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('KISS'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const KIIT())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.luggage),
              title: const Text('HOSPITALITY'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const HOSPITALITY())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('KIMS'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const KIIMS())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.temple_hindu),
              title: const Text('TEMPLE'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const TEMPLE())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to the settings screen.
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Feedback'),
              onTap: () {
                // Navigate to the help & feedback screen.
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Future<bool> logout() async {
                  return (await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          content: SizedBox(
                            height: 185,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/exclamation.svg',
                                  height: 110,
                                  width: 110,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Warning!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                const SizedBox(
                                  height: 13,
                                ),
                                const Text(
                                  'Do You Want To Logout',
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    textStyle: const TextStyle(fontSize: 16),
                                    fixedSize: const Size(150, 50),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(
                                      LoggedOut(),
                                    );
                                  },
                                  child: const Text(
                                    ' Logout ',
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )) ??
                      false;
                }

                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
