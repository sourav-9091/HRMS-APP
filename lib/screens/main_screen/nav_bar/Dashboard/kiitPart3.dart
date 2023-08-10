import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/widget/CustomButton.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widget/CustomText.dart';
import 'dashboard.dart';

class KIITPart3 extends StatefulWidget {
  final String add_ref;
  final String name;
  final String city;
  final String state;
  final int amt;
  final int contact;
  final String email;
  final String department;
  final String relation;
  final int pin;
  const KIITPart3({
    super.key,
    required this.add_ref,
    required this.name,
    required this.city,
    required this.state,
    required this.amt,
    required this.contact,
    required this.email,
    required this.department,
    required this.relation,
    required this.pin,
  });

  @override
  State<KIITPart3> createState() => _KIITPart3State();
}

bool isProcessTrue = false;

class _KIITPart3State extends State<KIITPart3> {
  final dateController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 30);
    if (selectedImages.isNotEmpty) {
      if (imageFileList!.length < 3) {
        imageFileList!.addAll(selectedImages);
        if (imageFileList!.length >= 3) {
          Future<bool> noImage() async {
            return (await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    content: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/exclamation.svg',
                            height: 80,
                            width: 110,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Warning!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          const Text(
                            'You Can Not Select More then Three Image',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                              fixedSize: const Size(150, 50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              ' OK ',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )) ??
                false;
          }

          noImage();
          imageFileList = imageFileList!.sublist(0, 3);
          //logic given by aditya choudary
        }

        setState(() {
          imageFileList;
        });
      } else {
        Future<bool> noImage() async {
          return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/exclamation.svg',
                          height: 90,
                          width: 110,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Warning!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        const Text(
                          'You Can Not Select More then Three Image',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(fontSize: 16),
                            fixedSize: const Size(150, 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            ' OK ',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )) ??
              false;
        }

        noImage();
      }
    }
    setState(() {});
  }

  Future getImage() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);

      if (pickedFile != null) {
        if (imageFileList!.length < 3) {
          XFile? image = XFile(pickedFile.path);
          imageFileList!.add(image);

          if (imageFileList!.length >= 3) {
            imageFileList = imageFileList!.sublist(0, 2);
          }

          setState(() {
            imageFileList;
          });
        } else {
          Future<bool> noImage() async {
            return (await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    content: SizedBox(
                      height: 190,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/exclamation.svg',
                            height: 90,
                            width: 110,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Warning!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          const Text(
                            'You Can Not Select More then Three Image',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                              fixedSize: const Size(150, 50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              ' OK ',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )) ??
                false;
          }

          noImage();
        }
        setState(() {});
      } else {
        print('NO IMAGE SELECTED');
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<bool> cameraAlert() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            content: SizedBox(
              height: 185,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/exclamation.svg',
                    height: 110,
                    width: 110,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Select Source',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  const Text(
                    'Please Select Image Source',
                    style: TextStyle(),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 16),
                      fixedSize: const Size(150, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      getImage();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      ' Camera ',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(fontSize: 16),
                    fixedSize: const Size(150, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    selectImages();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    ' Gallery ',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

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
            content: const Text('Do You Want To Return To Previous Page'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
                  isProcessTrue == true
                      ? print("Not Allowed")
                      : Navigator.of(context).pop(true);
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
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 17, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CustomText(text: "Upload Image"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: HexColor("#898989")),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                height: 400,
                                width: 340,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: imageFileList!.length + 1,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == imageFileList!.length) {
                                      return GestureDetector(
                                        onTap: () {},
                                        child: GestureDetector(
                                          onTap: () {
                                            cameraAlert();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Return image file with cross button for other indexes
                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                imageFileList!.removeAt(index);
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Image.file(
                                                File(
                                                    imageFileList![index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  imageFileList!
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[200],
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomElevatedButton(
                        primaryColor: Colors.green,
                        secondaryColor: Colors.white,
                        onPress: () async {
                          cameraAlert();
                        },
                        text: " Select Image",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoading
                          ? CustomElevatedButton(
                              primaryColor: Colors.green,
                              secondaryColor: Colors.white,
                              onPress: () async {
                                setState(() {
                                  isLoading = false;
                                });
                                await addData(
                                  widget.add_ref,
                                  widget.name,
                                  widget.pin.toString(),
                                  widget.city,
                                  widget.state,
                                  widget.relation,
                                  widget.department,
                                  widget.amt,
                                  widget.contact,
                                  widget.email,
                                  context,
                                  imageFileList!,
                                );
                                setState(() {
                                  isLoading = true;
                                });
                              },
                              text: "Submit",
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> addData(
  String addRef,
  String name,
  String pin,
  String city,
  String state,
  String relation,
  String department,
  int amtPaid,
  int number,
  String email,
  BuildContext ctx,
  List imageFileList,
) async {
  if (addRef == '' ||
      name == '' ||
      pin == '' ||
      city == '' ||
      state == '' ||
      relation == '' ||
      department == '' ||
      amtPaid == '' ||
      number == '' ||
      email == '') {
    Fluttertoast.showToast(
        msg: "Please Enter All The Details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    return "false";
  }
  final _MyBox = Hive.box('data');
  var headers = {'Content-Type': 'application/json'};
  var formRequest = http.Request(
      'POST', Uri.parse("http://192.168.47.224:5000/api/kiit/adddata"));
  formRequest.body = json.encode({
    "adm_ref_no": addRef,
    "student_name": name,
    "student_dep": department,
    "student_address": "$city , $state , $pin",
    "city": city,
    "state": state,
    "pincode": pin,
    "studemt_rel": relation,
    "amount_by_candidate": amtPaid,
    "student_email": email,
    "student_ph": number,
    "date": DateTime.now().toString(),
    "users_ref": "${_MyBox.get('id')}"
  });
  formRequest.headers.addAll(headers);

  isProcessTrue = true;
  try {
    http.StreamedResponse response1 = await formRequest.send().timeout(
          const Duration(
            seconds: 10,
          ),
        );

    if (response1.statusCode == 201) {
      Fluttertoast.showToast(
          msg: "Form Uploaded Trying to Upload Image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      print(await response1.stream.bytesToString());

      if (imageFileList.isNotEmpty) {
        const String url = "http://192.168.47.224:5000/api/upload/multiple";

        try {
          final uri = Uri.parse(url);

          final request = http.MultipartRequest('POST', uri);

          request.fields['username'] = '${_MyBox.get('username')}';
          request.fields['obj'] = '${_MyBox.get('id')}';
          request.fields['type'] = 'kitt';

          for (XFile imageFile in imageFileList) {
            final file = File(imageFile.path);
            final basename = path.basename(imageFile.path);
            final contentType = MediaType('image', 'jpg');
            final fileStream = http.ByteStream(file.openRead());
            final fileLength = await file.length();

            final multipartFile = http.MultipartFile(
                'images', fileStream, fileLength,
                filename: basename, contentType: contentType);

            request.files.add(multipartFile);
          }
          Fluttertoast.showToast(
              msg: "File Is Uploading",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          print('Checkpoint 1\n');
          final response = await request.send().timeout(
                Duration(seconds: 10),
              );

          Future<bool> successMessage() async {
            return (await showDialog(
                  context: ctx,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    content: SizedBox(
                      height: 185,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/success.svg',
                            height: 110,
                            width: 110,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Success',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          const Text(
                            'Form Submission Successfully',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    actions: const <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Center(
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.green,
                      //         textStyle: const TextStyle(fontSize: 16),
                      //         fixedSize: const Size(150, 50),
                      //         elevation: 0,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(14)),
                      //       ),
                      //       onPressed: () {
                      //         Navigator.pushAndRemoveUntil(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (BuildContext context) =>
                      //                   const HomeScreen()),
                      //           (Route<dynamic> route) => false,
                      //         );
                      //       },
                      //       child: const Text(
                      //         ' Ok ',
                      //         style: TextStyle(
                      //           fontFamily: 'Raleway',
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 16,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )) ??
                false;
          }

          Future<bool> ErrorMessage() async {
            return (await showDialog(
                  context: ctx,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    content: SizedBox(
                      height: 185,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/failed.svg',
                            height: 110,
                            width: 110,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          const Text(
                            'Form Was Not Submitted',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(fontSize: 16),
                              fixedSize: const Size(150, 50),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              ' Try Again ',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )) ??
                false;
          }

          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonResponse = json.decode(responseString);

          if (response.statusCode == 200) {
            successMessage();
          } else {
            // handle error
            ErrorMessage();
          }
        } catch (error) {
          Future<bool> ErrorMessage() async {
            return (await showDialog(
                  context: ctx,
                  builder: (context) => AlertDialog(
                    title: const Text('Status'),
                    content: const Text(
                      'SUBMITTION FAILED! GO BACK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                )) ??
                false;
          }

          // handle error
          ErrorMessage();
        }
      } else {
        Future<bool> noImage() async {
          return (await showDialog(
                context: ctx,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  content: SizedBox(
                    height: 185,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/emailSend.gif',
                          height: 110,
                          width: 110,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Warning!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        const Text(
                          'Please Select Atleast One Image',
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(fontSize: 16),
                            fixedSize: const Size(150, 50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            ' OK ',
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )) ??
              false;
        }

        noImage();
      }
    }
  } on Exception catch (e) {
    print(e.toString());
    Future<bool> ErrorMessage() async {
      return (await showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              content: SizedBox(
                height: 185,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/failed.svg',
                      height: 110,
                      width: 110,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Failed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    const Text(
                      'Form Was Not Submitted',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        textStyle: const TextStyle(fontSize: 16),
                        fixedSize: const Size(150, 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        ' Try Again ',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    ErrorMessage();
  }
  isProcessTrue = false;

  return "false";
}
