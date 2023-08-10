import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/profileUpdate.dart';
import 'package:hrms/screens/widget/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'Dashboard/dashboard.dart';
import 'Dashboard/linkUpdate.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final facebook = TextEditingController();
  final twitter = TextEditingController();
  final instagram = TextEditingController();
  final youtube = TextEditingController();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final _MyBox = Hive.box('data');

  // File? image;
  final picker = ImagePicker();
  bool showSpinner = false;

  bool isLoading = true;

  Future<String> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.5.72.44:5000/api/upload/'));

    // Add the image file to the request
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();
    var imageMultipartFile = http.MultipartFile(
      'image',
      imageStream,
      imageLength,
      filename: imageFile.path,
    );
    request.fields['username'] = '${_MyBox.get('username')}';
    request.files.add(imageMultipartFile);

    // print('I am uploading');

    // Send the request and wait for the response
    var response = await request.send();

    Future<bool> successMessage() async {
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
                      onPressed: () {},
                      // onPressed: () {
                      //   Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             HomeScreen()),
                      //     (Route<dynamic> route) => false,
                      //   );
                      // },
                      child: const Text(
                        ' Ok ',
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

    Future<bool> ErrorMessage() async {
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

    try {
      if (response.statusCode == 200) {
        successMessage();
      } else {
        // handle error
        ErrorMessage();
      }
    } catch (error) {
      Future<bool> ErrorMessage() async {
        return (await showDialog(
              context: context,
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

      ErrorMessage();
    }
    var responseBody = await response.stream.bytesToString();
    return responseBody;
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            // leading: IconButton(
            //     onPressed: () {
            //       int count = 0;
            //       Navigator.of(context).popUntil((_) => count++ >= 2);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back_ios_rounded,
            //       color: Colors.black,
            //     )),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const Text(
              'PROFILE UPDATE',
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 30,
              ),
              ProfileWidget(
                imagePath:
                    "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg",
                onClicked: (() async {
                  final imageFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  uploadImage(imageFile as File);
                }),
              ),
              const SizedBox(
                height: 120,
              ),
              SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const EditLinksPage())));
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Update Links',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 165,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => const EditProfileDetailPage())));
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
            ]),
      );
}
