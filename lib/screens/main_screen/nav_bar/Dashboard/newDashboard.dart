// import 'package:hive/hive.dart';
// import 'package:hrms/logic/auth_bloc/auth.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hrms/screens/main_screen/nav_bar/mainNav.dart';
// import 'package:hrms/screens/main_screen/verifyPage.dart';

// class MainScreenTwo extends StatefulWidget {
//   const MainScreenTwo({super.key});

//   @override
//   _MainScreenTwoState createState() => _MainScreenTwoState();
// }

// class _MainScreenTwoState extends State<MainScreenTwo> {
//   final _MyBox = Hive.box('data');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: CircleAvatar(
//             backgroundImage: NetworkImage(
//                 "http://192.168.37.145:5000/images?username=${_MyBox.get('username')}&filename=pp"),
//           ),
//         ),
//         title: const Text(
//           "HRMS",
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//               icon: const Icon(
//                 EvaIcons.logOutOutline,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 Future<bool> _onWillPop() async {
//                   return (await showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Are You Sure ?'),
//                           content: const Text('Want to logout from hrms ?'),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop(false);
//                               },
//                               child: const Text('No'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop(true);
//                                 BlocProvider.of<AuthenticationBloc>(context)
//                                     .add(
//                                   LoggedOut(),
//                                 );
//                               },
//                               child: const Text('Yes'),
//                             ),
//                           ],
//                         ),
//                       )) ??
//                       false;
//                 }

//                 _onWillPop();
//               })
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height - 90,
//           width: MediaQuery.of(context).size.width,
//           child: Center(
//             child: getWidget(),
//           ),
//         ),
//       ),
//     );
//   }

//   getWidget() {
//     if (_MyBox.get("verifiedEmail").toString() == "false") {
//       return const Register();
//     } else {
//       return MyApp();
//     }
//   }
// }

// class Dashboard extends StatelessWidget {
//   final _mybox = Hive.box('data');
//   Dashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(children: [
//         Text("Email :- ${_mybox.get("email")}"),
//         const SizedBox(height: 20),
//         Text("Token :- ${_mybox.get("token")}"),
//         const SizedBox(height: 20),
//         Text("isVerified :- ${_mybox.get("isVerified")}"),
//       ]),
//     );
//   }
// }
