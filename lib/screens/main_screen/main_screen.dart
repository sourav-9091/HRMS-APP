import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hrms/logic/auth_bloc/auth_bloc.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:hrms/screens/main_screen/nav_bar/mainNav.dart';
import 'package:hrms/screens/main_screen/verifyPage.dart';

import '../../logic/auth_bloc/auth_event.dart';
import '../../main.dart';

class MainScreen extends StatefulWidget {
  UserRepository userRepository;
  MainScreen({super.key, required this.userRepository});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are You Sure ?'),
            content: const Text('Do you want to logout of this app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoggedOut(),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPageRoute(
                                userRepository: widget.userRepository,
                              )));
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

  // ignore: non_constant_identifier_names
  final _MyBox = Hive.box('data');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: _onWillPop,
    //   child: Scaffold(
    //     key: _scaffoldKey,
    //     body: SingleChildScrollView(
    //       child: SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: Center(
    //           child: getWidget(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return getWidget();
  }

  getWidget() {
    if (_MyBox.get("verifiedEmail").toString() == "false") {
      return Register(
        userRepository: widget.userRepository,
      );
    } else {
      return MyApp(
        userRepository: widget.userRepository,
      );
      // return const Register();
    }
  }
}
