import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../widget/CustomInputField.dart';
import '../../../widget/CustomText.dart';

class EditLinksPage extends StatefulWidget {
  const EditLinksPage({super.key});

  @override
  _EditLinksPageState createState() => _EditLinksPageState();
}

class _EditLinksPageState extends State<EditLinksPage> {
  var fName = TextEditingController();
  final lName = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final department = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();
  final level = TextEditingController();

  final _MyBox = Hive.box('data');
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    // mobile.text = "9091165390";
    // address.text = "Bhubaneswar, Orissa";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              )),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'PROFILE UPDATE',
            style: TextStyle(color: Colors.black, fontSize: 25),
          )),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Facebook'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: fName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Facebook Profile Link",
                icon: Icon(
                  Icons.facebook,
                  color: HexColor('#6A6A6A'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Instagram'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: fName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Instagram Profile link",
                icon: Icon(
                  Icons.phone,
                  color: HexColor('#6A6A6A'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Twitter'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: fName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Twitter Profile Link",
                icon: Icon(
                  Icons.mobile_friendly,
                  color: HexColor('#6A6A6A'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Youtube'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: fName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Youtube Profile Link",
                icon: Icon(
                  Icons.youtube_searched_for,
                  color: HexColor('#6A6A6A'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          isLoading
              ? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = false;
                      });
                      await updateProfile(
                        fName.text,
                        lName.text,
                        username.text,
                        email.text,
                        department.text,
                        mobile.text,
                        address.text,
                      );
                      setState(() {
                        isLoading = true;
                      });
                      if (_MyBox.get('profileUpdateStatus') == "false") {
                        const snackBar = SnackBar(
                            content: Text('Something Went Wrong! Try Again'));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (_MyBox.get('otpVerifyStatus') == "true") {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: ((context) => ForgetPasswordTwo())));
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

Future<String> updateProfile(
  String fname,
  String lname,
  String username,
  String email,
  String department,
  String mobile,
  String address,
) async {
  final MyBox = Hive.box('data');
  if (fname == "" &&
      lname == "" &&
      username == "" &&
      email == "" &&
      department == "" &&
      mobile == "" &&
      address == "") {
    MyBox.put("profileUpdateStatus", "false");
    return "false";
  }

  Map data = {
    "fname": "${fname == "" ? MyBox.get("firstName") : fname}",
    "lname": "${lname == "" ? MyBox.get("lastName") : lname}",
    "department": "${department == "" ? MyBox.get("department") : department}",
    "username": "${username == "" ? MyBox.get("username") : username}",
    "email": "${email == "" ? MyBox.get("email") : email}",
    "mobile": "${mobile == "" ? MyBox.get("mobile") : mobile}",
    "address": "${address == "" ? MyBox.get("address") : address}",
  };

  var body = json.encode(data);
  try {
    var response = await http.post(
        Uri.parse("http://${MyBox.get("baseUrl")}:5000/api/user/edit"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${MyBox.get('token')}'
        },
        body: body);
    print("response code is ${response.statusCode}");
    if (response.statusCode == 200) {
      MyBox.put("profileUpdateStatus", "true");
      if (response.statusCode == 200) {
        // Map data1 = {"_id": _MyBox.get("id"), "password": "$str1"};
        var body1 = json.encode(data);
        // try {
        var userResponse = await http.get(
            Uri.parse("http://${MyBox.get("baseUrl")}:5000/api/app/user/"),
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
      return "true";
    }
    if (response.statusCode == 401) {
      MyBox.put("profileUpdateStatus", "false");
    }
  } on SocketException {
    //print('No Internet connection 😑');
    MyBox.put("profileUpdateStatus", "false");
  } on HttpException {
    //print("Couldn't find the post 😱");
    MyBox.put("profileUpdateStatus", "false");
  } on FormatException {
    //print("Bad response format 👎");
    MyBox.put("profileUpdateStatus", "false");
  }

  return "false";
}
