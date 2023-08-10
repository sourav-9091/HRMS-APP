import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/templePart2.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../widget/CustomInputField.dart';
import '../../../widget/CustomText.dart';
import 'hospitalityPart2.dart';

class TEMPLE extends StatefulWidget {
  const TEMPLE({super.key});

  @override
  State<TEMPLE> createState() => _TEMPLEState();
}

class _TEMPLEState extends State<TEMPLE> {
  String serviceDropDown = 'FOOD';
  final List<String> items = [
    'FOOD',
    'HOTEL',
    'PARTY BOOKING',
    'BIRTHDAY CELEBRATION',
  ];

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  final unitList1 = ['Food', "Hotel", 'Party Booking', 'Birthday Celebration'];
  String service = "Food";

  Future getImage() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (pickedFile != null) {
        XFile? image = XFile(pickedFile.path);
        imageFileList!.add(image);
        setState(() {});
      } else {
        print('NO IMSGE SELECTED');
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
                      // getImage(ImageSource.gallery);
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

  final date = TextEditingController();
  final cost = TextEditingController();
  final dateController = TextEditingController();

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
            content: const Text('Do you want to return to dashboard'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text('Yes'),
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
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                )),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              'HOSPITALITY FORM',
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Select Date'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    } else {
                      print("DATE IS NOT SELECTED");
                    }
                  },
                  style: TextStyle(
                    color: HexColor('#898989'),
                    fontFamily: 'Raleway',
                  ),
                  cursorColor: HexColor('#898989'),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.calendar_today, color: HexColor('#898989')),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    hintStyle: TextStyle(color: HexColor('#898989')),
                    hintText: 'Select Service date',
                    filled: true,
                    fillColor: HexColor('#F7F7F9'),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Select Service'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: 355,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: HexColor('#898989'),
                      ),
                      fillColor: HexColor('#F7F7F9'),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    value: service,
                    items: unitList1
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
                        service = val as String;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Enter Amount'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.number,
                  textEditingController: cost,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter The Cost",
                  icon: Icon(
                    Icons.key,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                    if (cost.text == '' || date.text == '' || service == '') {
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TEMPLEPart2(
                              date: dateController.text,
                              service: service,
                              cost: int.parse(cost.text),
                            )));
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
