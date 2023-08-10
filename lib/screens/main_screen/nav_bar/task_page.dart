import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/main_screen/nav_bar/profile_page.dart';
import 'package:hrms/screens/widget/CustomButton.dart';

import '../../widget/CustomDrawer.dart';
import 'Dashboard/linkPreviewPage.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final _MyBox = Hive.box('data');

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final unitList = ['Facebook', 'Instagram', 'Twitter', 'Youtube'];
  String? selectedVal = 'Facebook';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                  backgroundImage: NetworkImage(
                      "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg"),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 25, left: 25, right: 25, bottom: 10),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/sideNav.jpeg"),
                      fit: BoxFit.cover,
                    ),
                    // border: Border.all(),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const []),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 25, right: 20, left: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            Icons.bar_chart,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: (size.width - 40) * 0.6,
                            child: Column(
                              children: [
                                Text(
                                  "${_MyBox.get('firstName')} ${_MyBox.get('lastName')}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${_MyBox.get('department')}",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: const [
                              Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Facebook",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            width: 0.5,
                            height: 40,
                            color: Colors.white,
                          ),
                          Column(
                            children: const [
                              Text(
                                "2",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Instagram",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            width: 0.5,
                            height: 40,
                            color: Colors.white,
                          ),
                          Column(
                            children: const [
                              Text(
                                "1",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Twitter",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: const [
                            Text("Overview",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ],
                        )
                      ],
                    ),
                    const Text("Jan 16, 2023",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // SizedBox(
                      //   width: 30,
                      // ),
                      // Text(
                      //   'Youtube :- ',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 4,
                      // ),
                      // Text(
                      //   '${_MyBox.get('username')}',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black45),
                      // ),
                      // SizedBox(
                      //   width: 4,
                      // ),
                      // Text(
                      //   '  Subscribers',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // SizedBox(
                      //   width:30,
                      // ),
                      // Text(
                      //   'Instagram  :- ',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 4,
                      // ),
                      // Text(
                      //   '    ${_MyBox.get('department')}',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black45),
                      // ),
                      // Text(
                      //   '  Followers',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 4,
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 60,
                width: 337,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    fillColor: HexColor("#F7F7F9"),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  value: selectedVal,
                  items: unitList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: HexColor('#898989')),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedVal = val as String;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: CustomElevatedButton(
                  primaryColor: Colors.green,
                  secondaryColor: Colors.black,
                  onPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MaterialApp(
                                home:
                                    LinkPreview(apiUrl: selectedVal.toString()),
                                debugShowCheckedModeBanner: false,
                              )),
                    );
                  },
                  text: "Get Link",
                ),
              ),
            ],
          ),
        ));
  }
}

class FlutterLinkPreview {}
