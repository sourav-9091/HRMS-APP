import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kiitPart2.dart';
import 'package:hrms/screens/widget/CustomInputField.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widget/CustomText.dart';

class KIIT extends StatefulWidget {
  const KIIT({super.key});

  @override
  State<KIIT> createState() => _KIITState();
}

class _KIITState extends State<KIIT> {
  final dateController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 40);
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  Future getImage() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);

      if (pickedFile != null) {
        XFile? image = XFile(pickedFile.path);
        imageFileList!.add(image);
        setState(() {});
      } else {
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('SELECT IMAGE SOURCE'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: const [
                          Icon(Icons.image),
                          SizedBox(
                            width: 6,
                          ),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: const [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 6,
                          ),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final name = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final amt_paid = TextEditingController();
  final ref_no = TextEditingController();

  String relationDropDown = 'CHILD OF A FRIEND';
  final List<String> items = [
    'CHILD OF A FRIEND',
    'CHILD\'S RELATIVE',
    'OTHERS',
  ];
  String? selectedValue;

  String departmentDropDown = 'ITI';
  final List<String> items1 = [
    'ITI',
    'ENGINEERING',
    'POLYTECHNIC',
  ];
  String? selectedValue1;

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  bool isLoading = true;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you Want To Return To Dashboard'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                ),
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
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                )),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const Text(
              'KIIT FORM',
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                CustomText(text: 'Admission Reference No'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: ref_no,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Admission Reference No",
                  icon: Icon(
                    Icons.key,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Name'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: name,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's Name",
                  icon: Icon(
                    Icons.person,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'City'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: city,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's City",
                  icon: Icon(
                    Icons.location_city,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'State'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: state,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's State",
                  icon: Icon(
                    Icons.map,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Amount paid'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.number,
                  textEditingController: amt_paid,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's Amount Paid",
                  icon: Icon(
                    Icons.money,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 16),
                    fixedSize: const Size(500, 55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (ref_no.text.isEmpty ||
                        name.text.isEmpty ||
                        city.text.isEmpty ||
                        state.text.isEmpty ||
                        amt_paid.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please Enter All The Fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return;
                    }
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            KIITPart2(
                          add_ref: ref_no.text,
                          name: name.text,
                          city: city.text,
                          state: state.text,
                          amt: int.parse(amt_paid.text),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    ' Next ',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
