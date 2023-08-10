import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hrms/main.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:hrms/screens/main_screen/main_screen.dart';
import 'package:http/http.dart' as http;

import '../../../../logic/auth_bloc/auth_bloc.dart';
import '../../../../logic/auth_bloc/auth_event.dart';

class ResetPasswordPage extends StatefulWidget {
  UserRepository userRepository;
  ResetPasswordPage({Key? key, required this.userRepository}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  var str1 = TextEditingController();
  var str2 = TextEditingController();
  bool passwordVisible = false;

  final _MyBox = Hive.box('data');
  bool isLoading = true;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are You Sure ?'),
            content: const Text('Go Back To Login Page ?'),
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
                      ),
                    ),
                  );
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
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xfff7f6fb),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/images/kiitLogo.png',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Password Reset',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter New Password And Confirm It",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textField(
                              first: true,
                              last: false,
                              controller: str1,
                              msg: "New Password"),
                          _textField(
                              first: true,
                              last: false,
                              controller: str2,
                              msg: "Confirm Again"),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      isLoading
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  await changePassword(
                                    _MyBox.get('username'),
                                    str1.text,
                                    str2.text,
                                  );

                                  if (_MyBox.get("passSameStatus") == "false") {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Password Mismatched! Try Again'));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }

                                  if (_MyBox.get("resetPassword") == "false") {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Something Went Wrong! Try Again'));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  print(
                                      'Hello World ${_MyBox.get('resetPassword')} ');

                                  if (_MyBox.get("resetPassword") ==
                                      "success") {
                                    Future<bool> noImage() async {
                                      return (await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              content: SizedBox(
                                                height: 250,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/success.svg',
                                                      height: 140,
                                                      width: 110,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Password Updated Successfully',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 16),
                                                        fixedSize:
                                                            const Size(150, 50),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MainScreen(
                                                              userRepository: widget
                                                                  .userRepository,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontWeight:
                                                              FontWeight.w400,
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

                                    noImage();
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Text(
                                    'Reset',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(
      {bool? first,
      bool? last,
      TextEditingController? controller,
      String? msg}) {
    return SizedBox(
      height: 60,
      width: 270,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          obscureText: passwordVisible ? false : true,
          controller: controller,
          autofocus: true,
          showCursor: true,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
            hintText: msg,
            hintStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

Future<String> changePassword(
  String username,
  String str1,
  String str2,
) async {
  final MyBox = Hive.box('data');

  if (str1 != str2) {
    MyBox.put("passSameStatus", "false");
    return "false";
  } else {
    MyBox.put("passSameStatus", "true");
    Map data = {"_id": MyBox.get("id"), "password": str1};
    var body = json.encode(data);
    try {
      var response = await http
          .post(Uri.parse("http://192.168.195.192:5000/api/user/edit"),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer ${MyBox.get('token')}'
              },
              body: body)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw const SocketException('No Internet Connection');
      });

      if (response.statusCode == 200) {
        MyBox.put("resetPassword", "success");
        MyBox.put('verifiedEmail', 'true');
        return "true";
      }

      if (response.statusCode == 404) {
        MyBox.put("resetPassword", "false");
      }

      if (response.statusCode == 200) {
        var userResponse = await http.get(
            Uri.parse("http://192.168.195.192:5000/api/app/user/"),
            headers: {'Authorization': 'Bearer ${MyBox.get('token')}'});

        if (userResponse.statusCode == 200) {
          var jsonDataUser = json.decode(userResponse.body);

          MyBox.put("firstName", jsonDataUser['fname']);
          MyBox.put("lastName", jsonDataUser['lname']);
          MyBox.put('department', jsonDataUser['department']);
          MyBox.put('username', jsonDataUser['username']);
          MyBox.put('verifiedEmail', jsonDataUser['verified']);
          MyBox.put('level', jsonDataUser['level']);
          MyBox.put('email', jsonDataUser['email']);
          MyBox.put('pass_reset', jsonDataUser['pass_reset']);
          MyBox.put('id', jsonDataUser['_id']);
        }
      }
    } on SocketException {
      print('No Internet connection 😑');
      MyBox.put("resetPassword", "false");
      print(MyBox.get("resetPassword"));
    } on HttpException {
      print("Couldn't find the post 😱");
      MyBox.put("resetPassword", "false");
    } on FormatException {
      print("Bad response format 👎");
      MyBox.put("resetPassword", "false");
    }
  }

  return "false";
}
