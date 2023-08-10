import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hrms/main.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:hrms/screens/main_screen/nav_bar/mainNav.dart';
import 'package:hrms/screens/main_screen/otp_verify_page.dart';
import 'package:http/http.dart' as http;
import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/auth_bloc/auth_event.dart';

class Register extends StatefulWidget {
  UserRepository userRepository;
  Register({Key? key, required this.userRepository}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _MyBox = Hive.box('data');
  bool isLoading = true;
  var email = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    email.text = "${_MyBox.get("email")}";
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
                  height: 30,
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
                  'Registration',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Review your email. we'll send you a verification code so we know you're real",
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
                      TextFormField(
                        showCursor: false,
                        readOnly: true,
                        controller: email,
                        // keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
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
                                  await sendOTP(
                                    _MyBox.get('username'),
                                  );

                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (_MyBox.get("otpSubmitStatus") ==
                                      "false") {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Something Went Wrong! Try Again'));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  if (_MyBox.get("otpSubmitStatus") == "true") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: ((context) => (Otp(
                                              userRepository:
                                                  widget.userRepository,
                                              username: _MyBox.get('username')
                                                  .toString(),
                                            ))),
                                      ),
                                    );
                                  }
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
                                    'Request OTP',
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
}

Future<String> sendOTP(
  String userName,
) async {
  final _MyBox = Hive.box('data');
  Map data = {
    "username": userName,
  };
  var body = json.encode(data);

  try {
    var response = await http
        .post(Uri.parse("http://192.168.195.192:5000/api/auth/generate_otp"),
            headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw const SocketException('No Internet Connection');
    });
    if (response.statusCode == 200) {
      _MyBox.put("otpSubmitStatus", "true");
      return "true";
    } else if (response.statusCode == 401) {
      _MyBox.put("otpSubmitStatus", "alreadyVerified");
    }
  } on SocketException {
    print('No Internet connection 😑');
    _MyBox.put("otpSubmitStatus", "false");
  } on HttpException {
    print("Couldn't find the post 😱");
    _MyBox.put("otpSubmitStatus", "false");
  } on FormatException {
    print("Bad response format 👎");
    _MyBox.put("otpSubmitStatus", "false");
  }

  return "false";
}
