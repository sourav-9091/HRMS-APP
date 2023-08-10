// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hive/hive.dart';
// import 'package:hrms/repositories/repositories.dart';
// import 'package:hrms/screens/main_screen/main_screen.dart';
// import 'package:http/http.dart' as http;

// import '../../../../logic/auth_bloc/auth_bloc.dart';
// import '../../../../logic/auth_bloc/auth_event.dart';

// class ForgetPage extends StatefulWidget {
//   const ForgetPage({Key? key}) : super(key: key);

//   @override
//   _ForgetPageState createState() => _ForgetPageState();
// }

// class _ForgetPageState extends State<ForgetPage> {
//   var str1 = TextEditingController();
//   var str2 = TextEditingController();
//   bool passwordVisible = false;

//   late UserRepository userRepository;
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
//                   'Forget Password',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   "Enter Your Username",
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
//                               msg: "Username"),
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
//                                   _MyBox.get("loginPageRoute") == "false";

//                                   await changePassword(str1.text, context);

//                                   if (_MyBox.get("loginPageRoute") == "true") {
//                                     SystemNavigator.pop();
//                                   }

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
//                                     'Submit',
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
//           controller: controller,
//           autofocus: true,
//           showCursor: true,
//           readOnly: false,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
//           decoration: InputDecoration(
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
//   BuildContext context,
// ) async {
//   final MyBox = Hive.box('data');

//   Map data = {"username": str1};
//   var body = json.encode(data);
//   var response =
//       await http.post(Uri.parse("http://10.0.39.116:5000/api/auth/generate"),
//           headers: {
//             "Content-Type": "application/json",
//           },
//           body: body);
//   if (response.statusCode == 200) {
//     MyBox.put("loginPageRoute", "true");
//     MyBox.put('verifiedEmail', 'false');
//   } else {
//     Future<bool> noImage() async {
//       return (await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               content: SizedBox(
//                 height: 185,
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/exclamation.svg',
//                       height: 110,
//                       width: 110,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       'Warning!',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 13,
//                     ),
//                     Text(
//                       'Either Internet or User Not Found',
//                       style: TextStyle(),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         textStyle: const TextStyle(fontSize: 16),
//                         fixedSize: const Size(150, 50),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: Text(
//                         ' OK ',
//                         style: const TextStyle(
//                           fontFamily: 'Raleway',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )) ??
//           false;
//     }

//     noImage();
//   }

//   if (response.statusCode == 200) {
//     MyBox.put("resetPassword", "success");
//     return "true";
//   }

//   return "false";
// }
