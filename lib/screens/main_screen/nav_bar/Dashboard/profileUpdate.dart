import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/widget/CustomButton.dart';
import 'package:http/http.dart' as http;

import '../../../widget/CustomInputField.dart';
import '../../../widget/CustomText.dart';

class EditProfileDetailPage extends StatefulWidget {
  const EditProfileDetailPage({super.key});

  @override
  State<EditProfileDetailPage> createState() => _EditProfileDetailPageState();
}

class _EditProfileDetailPageState extends State<EditProfileDetailPage> {
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
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'First Name'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: fName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter First Name",
                icon: Icon(
                  Icons.person,
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
              // const Text(
              //   "Last Name",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   // style: TextStyle(color: Colors.green)
              //   // ,

              //   controller: lName,
              //   decoration: InputDecoration(
              //     hintText: "${_MyBox.get("lastName")}",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     errorBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //   ),
              // ),
              CustomText(text: 'Last Name'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.name,
                textEditingController: lName,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Last Name",
                icon: Icon(
                  Icons.person,
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
              CustomText(text: 'Username'),
              const SizedBox(
                height: 10,
              ),
              // CustomInputField(
              //   textInputType: TextInputType.name,
              //   textEditingController: username,
              //   primaryColor: HexColor("#F7F7F9"),
              //   secondaryColor: HexColor('#6A6A6A'),
              //   hint: "Enter Your User Name",
              //   icon: Icon(
              //     Icons.verified_user,
              //     color: HexColor('#6A6A6A'),
              //   ),
              // ),

              TextFormField(
                readOnly: true,
                controller: username,
                keyboardType: TextInputType.name,
                style: TextStyle(
                  color: HexColor('#6A6A6A'),
                  fontFamily: 'Raleway',
                ),
                cursorColor: HexColor('#6A6A6A'),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.verified_user,
                    color: HexColor('#6A6A6A'),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
                  ),
                  hintStyle: TextStyle(color: HexColor('#6A6A6A')),
                  hintText: "Enter Your User Name",
                  filled: true,
                  fillColor: HexColor("#F7F7F9"),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(14)),
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
              // const Text(
              //   "Email",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   controller: email,
              //   decoration: InputDecoration(
              //     hintText: "${_MyBox.get("email")}",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     errorBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //   ),
              // ),
              CustomText(text: 'Email'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.number,
                textEditingController: email,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Email Address",
                icon: Icon(
                  Icons.email,
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
              // const Text(
              //   "Department",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   // style: TextStyle(color: Colors.green)
              //   // ,

              //   controller: department,
              //   decoration: InputDecoration(
              //     hintText: "${_MyBox.get("department")}",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     errorBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //   ),
              // ),
              CustomText(text: 'Department'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.number,
                textEditingController: department,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Your Department",
                icon: Icon(
                  Icons.local_fire_department,
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
              //
              CustomText(text: 'Contact No'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.number,
                textEditingController: mobile,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Your Contact Number",
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
              // const Text(
              //   "Address",
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   controller: address,
              //   decoration: InputDecoration(
              //     hintText: "${_MyBox.get("address")}",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //     errorBorder: const OutlineInputBorder(
              //       borderSide: BorderSide(width: 3, color: Colors.green),
              //     ),
              //   ),
              // ),
              CustomText(text: 'Address'),
              const SizedBox(
                height: 10,
              ),
              CustomInputField(
                textInputType: TextInputType.number,
                textEditingController: address,
                primaryColor: HexColor("#F7F7F9"),
                secondaryColor: HexColor('#6A6A6A'),
                hint: "Enter Your Address",
                icon: Icon(
                  Icons.map,
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
  final _MyBox = Hive.box('data');
  if (fname == "" &&
      lname == "" &&
      username == "" &&
      email == "" &&
      department == "" &&
      mobile == "" &&
      address == "") {
    _MyBox.put("profileUpdateStatus", "false");
    return "false";
  }

  Map data = {
    "fname": "${fname == "" ? _MyBox.get("firstName") : fname}",
    "lname": "${lname == "" ? _MyBox.get("lastName") : lname}",
    "department": "${department == "" ? _MyBox.get("department") : department}",
    "username": "${username == "" ? _MyBox.get("username") : username}",
    "email": "${email == "" ? _MyBox.get("email") : email}",
    "mobile": "${mobile == "" ? _MyBox.get("mobile") : mobile}",
    "address": "${address == "" ? _MyBox.get("address") : address}",
  };

  var body = json.encode(data);
  try {
    var response = await http.post(
        Uri.parse("http://${_MyBox.get("baseUrl")}:5000/api/user/edit/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${_MyBox.get('token')}'
        },
        body: body);
    if (response.statusCode == 200) {
      _MyBox.put("profileUpdateStatus", "true");
      if (response.statusCode == 200) {
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
          _MyBox.put('id', jsonDataUser['_id']);
        }
      }
      return "true";
    }
    if (response.statusCode == 401) {
      _MyBox.put("profileUpdateStatus", "false");
    }
  } on SocketException {
    print('No Internet connection 😑');
    _MyBox.put("profileUpdateStatus", "false");
  } on HttpException {
    print("Couldn't find the post 😱");
    _MyBox.put("profileUpdateStatus", "false");
  } on FormatException {
    print("Bad response format 👎");
    _MyBox.put("profileUpdateStatus", "false");
  }

  return "false";
}
