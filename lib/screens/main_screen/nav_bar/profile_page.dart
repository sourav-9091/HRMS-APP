import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hrms/logic/auth_bloc/auth_bloc.dart';
import 'package:hrms/logic/auth_bloc/auth_event.dart';
import 'package:hrms/screens/main_screen/nav_bar/edit_profile_page.dart';
import 'package:hrms/screens/model/user.dart';
import 'package:hrms/screens/widget/profile_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import '../../widget/CustomDrawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // var user = UserPreferences.myUser;

  final _MyBox = Hive.box('data');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // final user = UserPreferences.myUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.green.shade50,
              backgroundImage: NetworkImage(
                  "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg"),
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
      body: RefreshIndicator(
        onRefresh: () async {
          var userResponse = await http.get(
              Uri.parse("http://${_MyBox.get("baseUrl")}:5000/api/app/user/"),
              headers: {'Authorization': 'Bearer ${_MyBox.get('token')}'});

          if (userResponse.statusCode == 200) {
            var jsonDataUser = json.decode(userResponse.body);
            _MyBox.put("firstName", jsonDataUser['fname']);
            _MyBox.put("lastName", jsonDataUser['lname']);
            _MyBox.put('department', jsonDataUser['department']);
            _MyBox.put('username', jsonDataUser['username']);
            _MyBox.put('verifiedEmail', jsonDataUser['verified']);
            _MyBox.put('level', jsonDataUser['level']);
            _MyBox.put('email', jsonDataUser['email']);
            _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
            _MyBox.put('mobile', jsonDataUser['mobile']);
            _MyBox.put('address', jsonDataUser['address']);
            _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
            _MyBox.put('id', jsonDataUser['_id']);
          }
        },
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath:
                  "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg",
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MaterialApp(
                            home: EditProfilePage(),
                            debugShowCheckedModeBanner: false,
                          )),
                );
              },
            ),
            const SizedBox(height: 24),
            buildName(),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      'Employee ID :- ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${_MyBox.get('username')}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      'Department  :- ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '    ${_MyBox.get('department')}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                      'Level              :- ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '         ${_MyBox.get('level')}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImage(
                  data:
                      "Name :- ${_MyBox.get('fname')}\nEmp_id :- ${_MyBox.get('lname')}\nLevel :- ${_MyBox.get('level')}",
                  size: 180,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(
                      100,
                      100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            // Center(
            //     child: ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: Colors.white, shape: const StadiumBorder(),
            //     backgroundColor: Colors.red,
            //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            //   ),
            //   onPressed: (() {
            //     Future<bool> _onWillPop() async {
            //       return (await showDialog(
            //             context: context,
            //             builder: (context) => AlertDialog(
            //               title: const Text('Are You Sure ?'),
            //               content: const Text('Want to logout from hrms ?'),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pop(false);
            //                   },
            //                   child: const Text('No'),
            //                 ),
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context).pop(true);
            //                     BlocProvider.of<AuthenticationBloc>(context)
            //                         .add(
            //                       LoggedOut(),
            //                     );
            //                   },
            //                   child: const Text('Yes'),
            //                 ),
            //               ],
            //             ),
            //           )) ??
            //           false;
            //     }

            //     _onWillPop();
            //   }),
            //   child: const Text("LOGOUT"),
            // )),

            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                backgroundColor: Colors.green,
              ),
              onPressed: (() async {
                var userResponse = await http.get(
                    Uri.parse(
                        "http://${_MyBox.get("baseUrl")}:5000/api/app/user/"),
                    headers: {
                      'Authorization': 'Bearer ${_MyBox.get('token')}'
                    });

                if (userResponse.statusCode == 200) {
                  var jsonDataUser = json.decode(userResponse.body);
                  _MyBox.put("firstName", jsonDataUser['fname']);
                  _MyBox.put("lastName", jsonDataUser['lname']);
                  _MyBox.put('department', jsonDataUser['department']);
                  _MyBox.put('username', jsonDataUser['username']);
                  _MyBox.put('verifiedEmail', jsonDataUser['verified']);
                  _MyBox.put('level', jsonDataUser['level']);
                  _MyBox.put('email', jsonDataUser['email']);
                  _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
                  _MyBox.put('mobile', jsonDataUser['mobile']);
                  _MyBox.put('address', jsonDataUser['address']);
                  _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
                  _MyBox.put('id', jsonDataUser['_id']);

                  setState(() {
                    _MyBox.get("firstName");
                    _MyBox.get("lastName");
                    _MyBox.get('department');
                    _MyBox.get('username');
                    _MyBox.get('verifiedEmail');
                    _MyBox.get('level');
                    _MyBox.get('email');
                    _MyBox.get('pass_reset');
                    _MyBox.get('mobile');
                    _MyBox.get('address');
                    _MyBox.get('pass_reset');
                  });
                }
              }),
              child: const Text("REFRESH"),
            )),
            const SizedBox(height: 30),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     InkWell(
            //       child: Image.asset(
            //         "assets/facebook.png",
            //         height: 35,
            //         width: 35,
            //       ),
            //       onTap: () {
            //         launch("https://www.facebook.com/KIITUniversity/",
            //             forceWebView: true);
            //       },
            //     ),
            //     InkWell(
            //       child: Image.asset(
            //         "assets/instagram.png",
            //         height: 35,
            //         width: 35,
            //       ),
            //       onTap: () {
            //         launch("https://www.instagram.com/kiituniversity/?hl=en",
            //             forceWebView: true);
            //       },
            //     ),
            //     InkWell(
            //       child: Image.asset(
            //         "assets/twitter.png",
            //         height: 35,
            //         width: 35,
            //       ),
            //       onTap: () {
            //         launch(
            //             "https://twitter.com/KIITUniversity?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor",
            //             forceWebView: true);
            //       },
            //     ),
            //     InkWell(
            //       child: Image.asset(
            //         "assets/youtube.png",
            //         height: 35,
            //         width: 35,
            //       ),
            //       onTap: () {
            //         launch(
            //             "https://www.youtube.com/channel/UC2x7DxsTyZj7XBa3hlLVPCQ",
            //             forceWebView: true);
            //       },
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

final _MyBox = Hive.box('data');
Widget buildName() => Column(
      children: [
        Text(
          "${_MyBox.get('firstName')} ${_MyBox.get('lastName')}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          "${_MyBox.get('email')}",
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );

Widget buildAbout(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.about,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
