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

class KIMSPart3 extends StatefulWidget {
  final String date;
  final String uhidNo;
  final String billno;
  final String name;
  const KIMSPart3(
      {super.key,
      required this.date,
      required this.uhidNo,
      required this.billno,
      required this.name});

  @override
  State<KIMSPart3> createState() => _KIMSPart3State();
}

class _KIMSPart3State extends State<KIMSPart3> {
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
        //print('NO IMAGE SELECTED');
      }
    } on Exception catch (e) {
      //print(e.toString());
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

  final cost = TextEditingController();
  final number = TextEditingController();

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

  final unitList1 = [
    'Self',
    'Friend',
    'Relative',
    'Other',
  ];
  String relation = "Self";

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
              'KIMS FORM',
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                CustomText(text: 'Billing Type'),
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
                    value: relation,
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
                        relation = val as String;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Cost'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.number,
                  textEditingController: cost,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter The Total Cost",
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
                CustomText(text: 'Contact No'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.number,
                  textEditingController: number,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter The Contact No",
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
                    if (relation.isEmpty ||
                        cost.text.isEmpty ||
                        number.text.isEmpty) {
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
                        builder: (context) => KIMSPart2(
                              cost: int.parse(cost.text),
                              number: number.text,
                              date: widget.date,
                              uhidNo: widget.uhidNo,
                              billNo: widget.billno,
                              name: widget.name,
                              relation: relation,
                            )));
                  },
                  /*  final String date;
  final String uhidNo;
  final String billNo;
  final String name;
  final String realtion;
  final String number;
  final int cost; */
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
