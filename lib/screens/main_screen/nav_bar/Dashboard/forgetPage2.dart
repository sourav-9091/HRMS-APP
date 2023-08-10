// import 'dart:convert';

// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';
// import 'package:hrms/screens/main_screen/main_screen.dart';
// import 'package:http/http.dart' as http;

// import '../../../../logic/auth_bloc/auth_bloc.dart';
// import '../../../../logic/auth_bloc/auth_event.dart';

// class ForgetPage2 extends StatefulWidget {
//   final String username;
//   const ForgetPage2({Key? key, required this.username}) : super(key: key);

//   @override
//   _ForgetPage2State createState() => _ForgetPage2State();
// }

// class _ForgetPage2State extends State<ForgetPage2> {
//   var str1 = TextEditingController();
//   var str2 = TextEditingController();
//   bool passwordVisible = false;

//   final _MyBox = Hive.box('data');
//   bool isLoading = true;

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Are You Sure ?'),
//             content: const Text('Want to logout from hrms ?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                   BlocProvider.of<AuthenticationBloc>(context).add(
//                     LoggedOut(),
//                   );
//                 },
//                 child: const Text('Yes'),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         // appBar: AppBar(
//         //   centerTitle: true,
//         //   backgroundColor: Colors.white,
//         //   elevation: 0,
//         //   leading: Padding(
//         //     padding: const EdgeInsets.all(10.0),
//         //     child: CircleAvatar(
//         //       backgroundColor: Colors.green.shade50,
//         //       backgroundImage: NetworkImage(
//         //           "http://192.168.37.145:5000/images?username=${_MyBox.get('username')}&filename=pp"),
//         //     ),
//         //   ),
//         //   title: const Text(
//         //     "HRMS",
//         //     style: TextStyle(color: Colors.black),
//         //   ),
//         //   actions: [
//         //     IconButton(
//         //         icon: const Icon(
//         //           EvaIcons.logOutOutline,
//         //           color: Colors.black,
//         //         ),
//         //         onPressed: () {
//         //           Future<bool> _onWillPop() async {
//         //             return (await showDialog(
//         //                   context: context,
//         //                   builder: (context) => AlertDialog(
//         //                     title: const Text('Are You Sure ?'),
//         //                     content: const Text('Want to logout from hrms ?'),
//         //                     actions: <Widget>[
//         //                       TextButton(
//         //                         onPressed: () {
//         //                           Navigator.of(context).pop(false);
//         //                         },
//         //                         child: const Text('No'),
//         //                       ),
//         //                       TextButton(
//         //                         onPressed: () {
//         //                           Navigator.of(context).pop(true);
//         //                           BlocProvider.of<AuthenticationBloc>(context)
//         //                               .add(
//         //                             LoggedOut(),
//         //                           );
//         //                         },
//         //                         child: const Text('Yes'),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 )) ??
//         //                 false;
//         //           }

//         //           _onWillPop();
//         //         })
//         //   ],
//         // ),
//         resizeToAvoidBottomInset: false,
//         backgroundColor: const Color(0xfff7f6fb),
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 60,
//                 ),
//                 Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.green.shade50,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Image.asset(
//                     'assets/images/kiitLogo.png',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 24,
//                 ),
//                 const Text(
//                   'Verification',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   "Please Enter the password Received in Your Mail",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black38,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 28,
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(28),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _textField(
//                               first: true,
//                               last: false,
//                               controller: str1,
//                               msg: "Password"),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 22,
//                       ),
//                       isLoading
//                           ? SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: () async {
//                                   setState(() {
//                                     isLoading = false;
//                                   });
//                                   await changePassword(
//                                     str1.text,
//                                   );

//                                   if (_MyBox.get("passSameStatus") == "false") {
//                                     const snackBar = SnackBar(
//                                         content: Text(
//                                             'Password Mismatched! Try Again'));

//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(snackBar);
//                                   }

//                                   if (_MyBox.get("passSameStatus") == "true") {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => MainScreen(),
//                                       ),
//                                     );
//                                   }
//                                   setState(() {
//                                     isLoading = true;
//                                   });
//                                 },
//                                 style: ButtonStyle(
//                                   foregroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.white),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.green),
//                                   shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(24.0),
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(14.0),
//                                   child: Text(
//                                     'Reset',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : const Center(child: CircularProgressIndicator()),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _textField(
//       {bool? first,
//       bool? last,
//       TextEditingController? controller,
//       String? msg}) {
//     return SizedBox(
//       height: 60,
//       width: 270,
//       child: AspectRatio(
//         aspectRatio: 1.0,
//         child: TextField(
//           obscureText: passwordVisible ? false : true,
//           controller: controller,
//           autofocus: true,
//           showCursor: true,
//           readOnly: false,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
//           decoration: InputDecoration(
//             suffixIcon: IconButton(
//               icon: Icon(
//                   passwordVisible ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(
//                   () {
//                     passwordVisible = !passwordVisible;
//                   },
//                 );
//               },
//             ),
//             hintText: msg,
//             hintStyle:
//                 const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
//             counter: const Offstage(),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(width: 2, color: Colors.black12),
//                 borderRadius: BorderRadius.circular(12)),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(width: 2, color: Colors.green),
//                 borderRadius: BorderRadius.circular(12)),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<String> changePassword(
//   String str1,
// ) async {
//   final MyBox = Hive.box('data');

//   Map data = {"_id": MyBox.get("id"), "password": str1};
//   var body = json.encode(data);
//   var response = await http.post(
//       Uri.parse("http://${MyBox.get("baseUrl")}:5000/api/user/edit"),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer ${MyBox.get('token')}'
//       },
//       body: body);
//   if (response.statusCode == 200) {
//     var userResponse = await http.get(
//         Uri.parse("http://${MyBox.get("baseUrl")}:5000/api/app/user/"),
//         headers: {'Authorization': 'Bearer ${MyBox.get('token')}'});

//     if (userResponse.statusCode == 200) {
//       var jsonDataUser = json.decode(userResponse.body);

//       MyBox.put("firstName", jsonDataUser['fname']);
//       MyBox.put("lastName", jsonDataUser['lname']);
//       MyBox.put('department', jsonDataUser['department']);
//       MyBox.put('username', jsonDataUser['username']);
//       MyBox.put('verifiedEmail', jsonDataUser['verified']);
//       MyBox.put('level', jsonDataUser['level']);
//       MyBox.put('email', jsonDataUser['email']);
//       MyBox.put('pass_reset', jsonDataUser['pass_reset']);
//       MyBox.put('id', jsonDataUser['_id']);
//     }
//   }

//   if (response.statusCode == 200) {
//     MyBox.put("resetPassword", "success");
//     return "true";
//   }

//   return "false";
// }
