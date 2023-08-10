import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hrms/main.dart';
import 'package:hrms/repositories/repositories.dart';
import 'package:http/http.dart' as http;

import '../../logic/auth_bloc/auth_bloc.dart';
import '../../logic/auth_bloc/auth_event.dart';
import 'nav_bar/Dashboard/resetPassword2.dart';

class Otp extends StatefulWidget {
  UserRepository userRepository;
  String username;
  Otp({
    Key? key,
    required this.userRepository,
    required this.username,
  }) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  static const int _totalDuration = 60;
  int _duration = _totalDuration;
  Timer? _timer;

  var str1 = TextEditingController();

  final _MyBox = Hive.box('data');
  bool isLoading = true;
  bool isResendLoading = true;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration > 0) {
          _duration--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void resendOtp() {
    setState(() {
      _duration = _totalDuration;
      startTimer();
    });
  }

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
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: TextStyle(fontSize: 20),
                                controller: str1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter Your OTP',
                                  labelStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
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
                                  await verifyOTP(
                                    _MyBox.get('username'),
                                    str1.text,
                                  );
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_MyBox.get('otpVerifyStatus') ==
                                      "false") {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Something Went Wrong / Incorrect Otp Try Again'));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  if (_MyBox.get('otpVerifyStatus') == "true") {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ResetPasswordPage(
                                                    userRepository: widget
                                                        .userRepository))));
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
                                    'Verify',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    _duration > 0 ? null : resendOtp();
                  },
                  child: (_duration > 0)
                      ? Text(
                          'Resend OTP ($_duration s)',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
                        )
                      : isResendLoading
                          ? GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isResendLoading = false;
                                });
                                await resendOTP(
                                  widget.username,
                                );

                                setState(() {
                                  isResendLoading = true;
                                });

                                if (_MyBox.get("otpResendStatus") == "false") {
                                  const snackBar = SnackBar(
                                      content: Text(
                                          'Something Went Wrong! Try Again'));

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                if (_MyBox.get("otpResendStatus") == "true") {
                                  resendOtp();
                                }
                              },
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> verifyOTP(
  String username,
  String otp,
) async {
  final MyBox = Hive.box('data');
  Map data = {"otp": "$otp", "username": "$username"};
  var body = json.encode(data);
  try {
    var response = await http
        .post(Uri.parse("http://192.168.195.192:5000/api/auth/verify_user"),
            headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw const SocketException('No Internet Connection');
    });
    if (response.statusCode == 200) {
      MyBox.put("otpVerifyStatus", "true");
      return "true";
    }
    if (response.statusCode == 404) {
      MyBox.put("otpVerifyStatus", "false");
    }
  } on SocketException {
    print('No Internet connection 😑');
    MyBox.put("otpVerifyStatus", "false");
  } on HttpException {
    print("Couldn't find the post 😱");
    MyBox.put("otpVerifyStatus", "false");
  } on FormatException {
    print("Bad response format 👎");
    MyBox.put("otpVerifyStatus", "false");
  }

  return "false";
}

Future<String> resendOTP(
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
      _MyBox.put("otpResendStatus", "true");
      return "true";
    } else if (response.statusCode == 401) {
      _MyBox.put("otpResendStatus", "alreadyVerified");
    }
  } on SocketException {
    print('No Internet connection 😑');
    _MyBox.put("otpResendStatus", "false");
  } on HttpException {
    print("Couldn't find the post 😱");
    _MyBox.put("otpResendStatus", "false");
  } on FormatException {
    print("Bad response format 👎");
    _MyBox.put("otpResendStatus", "false");
  }

  return "false";
}
