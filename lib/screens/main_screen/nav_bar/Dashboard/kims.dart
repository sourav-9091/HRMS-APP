import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../widget/CustomInputField.dart';
import '../../../widget/CustomText.dart';
import 'kimsPart2.dart';
import 'kimsPart3.dart';

class KIIMS extends StatefulWidget {
  const KIIMS({super.key});

  @override
  State<KIIMS> createState() => _KIIMSState();
}

class _KIIMSState extends State<KIIMS> {
  final dateController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  Future getImage() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (pickedFile != null) {
        XFile? image = XFile(pickedFile.path);
        imageFileList!.add(image);
        setState(() {});
      } else {
        print('NO IMAGE SELECTED');
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

  final uhidNo = TextEditingController();
  final name = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final billNo = TextEditingController();

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

  final unitList1 = ['Food', "Hotel", 'Party Booking', 'Birthday Celebration'];
  String relation = "Food";

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
              'KIMS FORM',
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
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'UHID NO'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: uhidNo,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter UHID No",
                  icon: Icon(
                    Icons.key,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'BILL NO'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.name,
                  textEditingController: billNo,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Bill No",
                  icon: Icon(
                    Icons.person,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                  hint: "Enter Patient's Name",
                  icon: Icon(
                    Icons.map,
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
                    if (dateController.text.isEmpty ||
                        uhidNo.text.isEmpty ||
                        billNo.text.isEmpty ||
                        name.text.isEmpty) {
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
                        builder: (context) => KIMSPart3(
                              date: dateController.text,
                              uhidNo: uhidNo.text,
                              name: name.text,
                              billno: billNo.text,
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

//10.5.68.62