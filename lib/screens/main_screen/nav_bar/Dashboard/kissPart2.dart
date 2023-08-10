// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:hive/hive.dart';
// import 'package:hrms/screens/widget/CustomButton.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:http_parser/http_parser.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../../../widget/CustomText.dart';
// import '../../main_screen.dart';
// import 'dashboard.dart';

// class KISSPart2 extends StatefulWidget {
//   final Map<String, dynamic> data;

//   const KISSPart2({super.key, required this.data});

//   @override
//   State<KISSPart2> createState() => _KISSPart2State();
// }

// bool isProcessTrue = false;

// class _KISSPart2State extends State<KISSPart2> {
//   final dateController = TextEditingController();

//   final ImagePicker imagePicker = ImagePicker();
//   List<XFile>? imageFileList = [];

//   void selectImages() async {
//     final List<XFile> selectedImages =
//         await imagePicker.pickMultiImage(imageQuality: 30);
//     if (selectedImages.isNotEmpty) {
//       if (imageFileList!.length < 3) {
//         imageFileList!.addAll(selectedImages);
//         if (imageFileList!.length >= 3) {
//           Future<bool> noImage() async {
//             return (await showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     content: SizedBox(
//                       height: 200,
//                       child: Column(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/exclamation.svg',
//                             height: 80,
//                             width: 110,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const Text(
//                             'Warning!',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 13,
//                           ),
//                           const Text(
//                             'You Can Not Select More then Three Image',
//                             style: TextStyle(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               textStyle: const TextStyle(fontSize: 16),
//                               fixedSize: const Size(150, 50),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                             child: const Text(
//                               ' OK ',
//                               style: TextStyle(
//                                 fontFamily: 'Raleway',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )) ??
//                 false;
//           }

//           noImage();
//           imageFileList = imageFileList!.sublist(0, 3);
//           //logic given by aditya choudary
//         }

//         setState(() {
//           imageFileList;
//         });
//       } else {
//         Future<bool> noImage() async {
//           return (await showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   content: SizedBox(
//                     height: 200,
//                     child: Column(
//                       children: [
//                         SvgPicture.asset(
//                           'assets/exclamation.svg',
//                           height: 90,
//                           width: 110,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Text(
//                           'Warning!',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 13,
//                         ),
//                         const Text(
//                           'You Can Not Select More then Three Image',
//                           style: TextStyle(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             textStyle: const TextStyle(fontSize: 16),
//                             fixedSize: const Size(150, 50),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14)),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop(true);
//                           },
//                           child: const Text(
//                             ' OK ',
//                             style: TextStyle(
//                               fontFamily: 'Raleway',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )) ??
//               false;
//         }

//         noImage();
//       }
//     }
//     setState(() {});
//   }

//   Future getImage() async {
//     try {
//       final pickedFile =
//           await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);

//       if (pickedFile != null) {
//         if (imageFileList!.length < 3) {
//           XFile? image = XFile(pickedFile.path);
//           imageFileList!.add(image);

//           if (imageFileList!.length >= 3) {
//             imageFileList = imageFileList!.sublist(0, 2);
//           }

//           setState(() {
//             imageFileList;
//           });
//         } else {
//           Future<bool> noImage() async {
//             return (await showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     content: SizedBox(
//                       height: 190,
//                       child: Column(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/exclamation.svg',
//                             height: 90,
//                             width: 110,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const Text(
//                             'Warning!',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 13,
//                           ),
//                           const Text(
//                             'You Can Not Select More then Three Image',
//                             style: TextStyle(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               textStyle: const TextStyle(fontSize: 16),
//                               fixedSize: const Size(150, 50),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                             child: const Text(
//                               ' OK ',
//                               style: TextStyle(
//                                 fontFamily: 'Raleway',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )) ??
//                 false;
//           }

//           noImage();
//         }
//         setState(() {});
//       } else {
//         print('NO IMAGE SELECTED');
//       }
//     } on Exception catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<bool> cameraAlert() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             content: SizedBox(
//               height: 185,
//               child: Column(
//                 children: [
//                   SvgPicture.asset(
//                     'assets/exclamation.svg',
//                     height: 110,
//                     width: 110,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Text(
//                     'Select Source',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 13,
//                   ),
//                   const Text(
//                     'Please Select Image Source',
//                     style: TextStyle(),
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       textStyle: const TextStyle(fontSize: 16),
//                       fixedSize: const Size(150, 50),
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                     ),
//                     onPressed: () {
//                       getImage();
//                       Navigator.of(context).pop(true);
//                     },
//                     child: const Text(
//                       ' Camera ',
//                       style: TextStyle(
//                         fontFamily: 'Raleway',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     textStyle: const TextStyle(fontSize: 16),
//                     fixedSize: const Size(150, 50),
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14)),
//                   ),
//                   onPressed: () {
//                     selectImages();
//                     Navigator.of(context).pop(true);
//                   },
//                   child: const Text(
//                     ' Gallery ',
//                     style: TextStyle(
//                       fontFamily: 'Raleway',
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }

//   void myAlert() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             title: const Text('SELECT IMAGE SOURCE'),
//             content: SizedBox(
//               height: MediaQuery.of(context).size.height / 6,
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       selectImages();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: const [
//                           Icon(Icons.image),
//                           SizedBox(
//                             width: 6,
//                           ),
//                           Text('From Gallery'),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       getImage();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: const [
//                           Icon(Icons.camera),
//                           SizedBox(
//                             width: 6,
//                           ),
//                           Text('From Camera'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   String relationDropDown = 'CHILD OF A FRIEND';
//   final List<String> items = [
//     'CHILD OF A FRIEND',
//     'CHILD\'S RELATIVE',
//     'OTHERS',
//   ];
//   String? selectedValue;

//   String departmentDropDown = 'ITI';
//   final List<String> items1 = [
//     'ITI',
//     'ENGINEERING',
//     'POLYTECHNIC',
//   ];
//   String? selectedValue1;

//   final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//     foregroundColor: Colors.black87,
//     backgroundColor: Colors.grey[300],
//     minimumSize: const Size(88, 36),
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.all(Radius.circular(2)),
//     ),
//   );

//   File? image;
//   final _picker = ImagePicker();
//   bool showSpinner = false;

//   bool isLoading = true;

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Are you sure?'),
//             content: const Text('Do you want to return to dashboard'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () =>
//                     Navigator.of(context).pop(false), //<-- SEE HERE
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MainScreen(),
//                   ),
//                 ), // <-- SEE HERE
//                 child: const Text('Yes'),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 icon: const Icon(
//                   Icons.arrow_back_ios_rounded,
//                   color: Colors.black,
//                 )),
//             elevation: 0,
//             centerTitle: true,
//             backgroundColor: Colors.white,
//             title: const Text(
//               'KISS FORM',
//               style: TextStyle(color: Colors.black, fontSize: 25),
//             )),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               const SizedBox(
//                 height: 5,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 17, 8),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     CustomText(text: "Upload Image"),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       children: [
//                         InkWell(
//                           child: Center(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: HexColor("#898989")),
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(5)),
//                               ),
//                               height: 400,
//                               width: 340,
//                               child: GridView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: imageFileList!.length + 1,
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                 ),
//                                 itemBuilder: (BuildContext context, int index) {
//                                   if (index == imageFileList!.length) {
//                                     return GestureDetector(
//                                       onTap: () {},
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           cameraAlert();
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(25.0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.grey[200],
//                                               borderRadius:
//                                                   BorderRadius.circular(100),
//                                             ),
//                                             child: const Icon(
//                                               Icons.add,
//                                               color: Colors.grey,
//                                               size: 30,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     // Return image file with cross button for other indexes
//                                     return Stack(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               imageFileList!.removeAt(index);
//                                             });
//                                           },
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(10.0),
//                                             child: Image.file(
//                                               File(imageFileList![index].path),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           top: 5,
//                                           right: 5,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 imageFileList!.removeAt(index);
//                                               });
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 color: Colors.grey[200],
//                                               ),
//                                               child: const Icon(
//                                                 Icons.close,
//                                                 color: Colors.grey,
//                                                 size: 20,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     CustomElevatedButton(
//                       primaryColor: Colors.green,
//                       secondaryColor: Colors.white,
//                       onPress: () async {
//                         myAlert();
//                       },
//                       text: " Select Image",
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     isLoading
//                         ? CustomElevatedButton(
//                             primaryColor: Colors.green,
//                             secondaryColor: Colors.white,
//                             onPress: () async {
//                               setState(() {
//                                 isLoading = false;
//                               });
//                               await addData(
//                                 widget.data,
//                                 context,
//                                 imageFileList!,
//                               );
//                               setState(() {
//                                 isLoading = true;
//                               });
//                             },
//                             text: "Submit",
//                           )
//                         : const Center(child: CircularProgressIndicator()),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // Future<String> addData(
// //   final Map<String, dynamic> data,
// //   BuildContext ctx,
// //   List imageFileList,
// // ) async {
// //   // print(data);
// //   // print(
// //   //     "$addRef i am addRef \n $amtPaid  i am amt paid \n $number i am number \n $relation i am relation\n");
// //   Fluttertoast.showToast(
// //       msg: "This is Center Short Toast",
// //       toastLength: Toast.LENGTH_SHORT,
// //       gravity: ToastGravity.BOTTOM,
// //       timeInSecForIosWeb: 1,
// //       backgroundColor: Colors.red,
// //       textColor: Colors.white,
// //       fontSize: 16.0);

// //   Map data1 = data;
// //   var body = json.encode(data1);
// //   try {
// //     var response =
// //         await http.post(Uri.parse('http://10.5.66.19:5000/api/kiss/add'),
// //             headers: {
// //               "Content-Type": "application/json",
// //               'Authorization':
// //                   'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MWU3ZmRlOTg1YWQzMTk3NmQzYWE4YyIsImxldmVsIjowLCJ1c2VybmFtZSI6ImFkaXR5YTY5NjkiLCJpYXQiOjE2ODA4NjcyNTIsImV4cCI6MTY4MDg2OTM1Mn0.gh5e9qrS2CTpvb7EtUYwR7lOLpLXu3JZQJFcsqfg-VI',
// //             },
// //             body: body);
// //     if (response.statusCode == 200) {
// //       // MyBox.put("kissSubmitStatus", "true");
// //       print("${response.reasonPhrase}");
// //       return "true";
// //     } else {
// //       throw HttpException('${response.statusCode}');
// //     }
// //   } on SocketException {
// //     print('No Internet connection 😑');
// //     // MyBox.put("kissSubmitStatus", "false");
// //   } on HttpException {
// //     print("Couldn't find the post 😱");
// //     // MyBox.put("kissSubmitStatus", "false");
// //   } on FormatException {
// //     print("Bad response format 👎");
// //     // MyBox.put("kissSubmitStatus", "false");
// //   }

// //   //I AM END

// //   if (imageFileList.isNotEmpty) {
// //     const String url = "http://3.232.33.84:5000/api/upload/multiple";

// //     try {
// //       final uri = Uri.parse(url);

// //       final request = http.MultipartRequest('POST', uri);

// //       // add username, objectID, and type fields
// //       request.fields['username'] = '2129011';
// //       request.fields['obj'] = '45544056456';
// //       request.fields['type'] = 'kiss';

// //       // add image files
// //       for (XFile imageFile in imageFileList) {
// //         final file = File(imageFile.path);
// //         final basename = path.basename(imageFile.path);
// //         final contentType = MediaType('image', 'jpg');
// //         final fileStream = http.ByteStream(file.openRead());
// //         final fileLength = await file.length();

// //         final multipartFile = http.MultipartFile(
// //             'images', fileStream, fileLength,
// //             filename: basename, contentType: contentType);

// //         request.files.add(multipartFile);
// //       }
// //       Fluttertoast.showToast(
// //           msg: "File Is Uploading",
// //           toastLength: Toast.LENGTH_SHORT,
// //           gravity: ToastGravity.BOTTOM,
// //           timeInSecForIosWeb: 1,
// //           backgroundColor: Colors.green,
// //           textColor: Colors.white,
// //           fontSize: 16.0);
// //       print('Checkpoint 1\n');
// //       final response = await request.send();

// //       Future<bool> successMessage() async {
// //         return (await showDialog(
// //               context: ctx,
// //               builder: (context) => AlertDialog(
// //                 title: const Text('Status'),
// //                 content: const Text(
// //                   'FORM WAS SUBMITTED SUCCESSFULLY! GO BACK',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 25,
// //                   ),
// //                 ),
// //                 actions: <Widget>[
// //                   TextButton(
// //                     onPressed: () =>
// //                         Navigator.of(context).pop(false), //<-- SEE HERE
// //                     child: const Text('No'),
// //                   ),
// //                   TextButton(
// //                     onPressed: () =>
// //                         Navigator.of(context).pop(true), // <-- SEE HERE
// //                     child: const Text('Yes'),
// //                   ),
// //                 ],
// //               ),
// //             )) ??
// //             false;
// //       }

// //       Future<bool> ErrorMessage() async {
// //         return (await showDialog(
// //               context: ctx,
// //               builder: (context) => AlertDialog(
// //                 title: const Text('Status'),
// //                 content: const Text(
// //                   'SUBMITTION FAILED! GO BACK',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 25,
// //                   ),
// //                 ),
// //                 actions: <Widget>[
// //                   TextButton(
// //                     onPressed: () =>
// //                         Navigator.of(context).pop(false), //<-- SEE HERE
// //                     child: const Text('No'),
// //                   ),
// //                   TextButton(
// //                     onPressed: () =>
// //                         Navigator.of(context).pop(true), // <-- SEE HERE
// //                     child: const Text('Yes'),
// //                   ),
// //                 ],
// //               ),
// //             )) ??
// //             false;
// //       }

// //       //print('Checkpoint 2\n');
// //       final responseData = await response.stream.toBytes();
// //       //print('Checkpoint 3\n');
// //       final responseString = String.fromCharCodes(responseData);
// //       //print('Checkpoint 4\n');
// //       final jsonResponse = json.decode(responseString);

// //       if (response.statusCode == 200) {
// //         //print("i am successfull");
// //         successMessage();
// //       } else {
// //         // handle error
// //         ErrorMessage();
// //         //print("my status code is ${response.statusCode.toString()}");
// //       }
// //     } catch (error) {
// //       Future<bool> ErrorMessage() async {
// //         return (await showDialog(
// //               context: ctx,
// //               builder: (context) => AlertDialog(
// //                 title: const Text('Status'),
// //                 content: const Text(
// //                   'SUBMITTION FAILED! GO BACK',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 25,
// //                   ),
// //                 ),
// //                 actions: <Widget>[
// //                   TextButton(
// //                     onPressed: () => Navigator.of(context).pop(false),
// //                     child: const Text('No'),
// //                   ),
// //                   TextButton(
// //                     onPressed: () => Navigator.of(context).pop(true),
// //                     child: const Text('Yes'),
// //                   ),
// //                 ],
// //               ),
// //             )) ??
// //             false;
// //       }

// //       // handle error
// //       ErrorMessage();
// //       //print("I am error $error");
// //     }
// //   } else {
// //     Future<bool> noImage() async {
// //       return (await showDialog(
// //             context: ctx,
// //             builder: (context) => AlertDialog(
// //               title: const Text('Status'),
// //               content: const Text(
// //                 'PLEASE SELECT ATLEAST ONE IMAGE! GO BACK',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 25,
// //                 ),
// //               ),
// //               actions: <Widget>[
// //                 TextButton(
// //                   onPressed: () => Navigator.of(context).pop(false),
// //                   child: const Text('No'),
// //                 ),
// //                 TextButton(
// //                   onPressed: () => Navigator.of(context).pop(true),
// //                   child: const Text('Yes'),
// //                 ),
// //               ],
// //             ),
// //           )) ??
// //           false;
// //     }

// //     noImage();
// //   }

// //   return "false";
// // }
// Future<String> addData(
//   Map<String, dynamic> data,
//   BuildContext ctx,
//   List imageFileList,
// ) async {
//   final _MyBox = Hive.box('data');
//   var headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer ${_MyBox.get('token')}',
//   };
//   Map data1 = data;
//   var body = json.encode(data1);

//   isProcessTrue = true;
//   try {
//     var response1 =
//         await http.post(Uri.parse('http://10.5.72.44:5000/api/kiss/add'),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer ${_MyBox.get('token')}',
//             },
//             body: body);

//     if (response1.statusCode == 200) {
//       Fluttertoast.showToast(
//           msg: "Form Uploaded Trying to Upload Image",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);

//       if (imageFileList.isNotEmpty) {
//         const String url = "http://10.5.72.44:5000/api/upload/multiple";

//         try {
//           final uri = Uri.parse(url);

//           final request = http.MultipartRequest('POST', uri);

//           request.fields['username'] = '${_MyBox.get('username')}';
//           request.fields['obj'] = '${_MyBox.get('id')}';
//           request.fields['type'] = 'kiss';

//           for (XFile imageFile in imageFileList) {
//             final file = File(imageFile.path);
//             final basename = path.basename(imageFile.path);
//             final contentType = MediaType('image', 'jpg');
//             final fileStream = http.ByteStream(file.openRead());
//             final fileLength = await file.length();

//             final multipartFile = http.MultipartFile(
//                 'images', fileStream, fileLength,
//                 filename: basename, contentType: contentType);

//             request.files.add(multipartFile);
//           }
//           Fluttertoast.showToast(
//               msg: "File Is Uploading",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.green,
//               textColor: Colors.white,
//               fontSize: 16.0);
//           print('Checkpoint 1\n');
//           final response = await request.send().timeout(
//                 const Duration(seconds: 10),
//               );

//           Future<bool> successMessage() async {
//             return (await showDialog(
//                   context: ctx,
//                   builder: (context) => AlertDialog(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     content: SizedBox(
//                       height: 185,
//                       child: Column(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/success.svg',
//                             height: 110,
//                             width: 110,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const Text(
//                             'Success',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 13,
//                           ),
//                           const Text(
//                             'Form Submission Successfully',
//                             style: TextStyle(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               textStyle: const TextStyle(fontSize: 16),
//                               fixedSize: const Size(150, 50),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                             ),
//                             onPressed: () {
//                               Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         const HomeScreen()),
//                                 (Route<dynamic> route) => false,
//                               );
//                             },
//                             child: const Text(
//                               ' Ok ',
//                               style: TextStyle(
//                                 fontFamily: 'Raleway',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )) ??
//                 false;
//           }

//           Future<bool> ErrorMessage() async {
//             return (await showDialog(
//                   context: ctx,
//                   builder: (context) => AlertDialog(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     content: SizedBox(
//                       height: 185,
//                       child: Column(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/failed.svg',
//                             height: 110,
//                             width: 110,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           const Text(
//                             'Failed',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 13,
//                           ),
//                           const Text(
//                             'Form Was Not Submitted',
//                             style: TextStyle(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               textStyle: const TextStyle(fontSize: 16),
//                               fixedSize: const Size(150, 50),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                             child: const Text(
//                               ' Try Again ',
//                               style: TextStyle(
//                                 fontFamily: 'Raleway',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )) ??
//                 false;
//           }

//           final responseData = await response.stream.toBytes();
//           final responseString = String.fromCharCodes(responseData);
//           final jsonResponse = json.decode(responseString);

//           if (response.statusCode == 200) {
//             successMessage();
//           } else {
//             // handle error
//             ErrorMessage();
//           }
//         } catch (error) {
//           Future<bool> ErrorMessage() async {
//             return (await showDialog(
//                   context: ctx,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Status'),
//                     content: const Text(
//                       'SUBMITTION FAILED! GO BACK',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(false),
//                         child: const Text('No'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(true),
//                         child: const Text('Yes'),
//                       ),
//                     ],
//                   ),
//                 )) ??
//                 false;
//           }

//           // handle error
//           ErrorMessage();
//         }
//       } else {
//         Future<bool> noImage() async {
//           return (await showDialog(
//                 context: ctx,
//                 builder: (context) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   content: SizedBox(
//                     height: 185,
//                     child: Column(
//                       children: [
//                         Image.asset(
//                           'assets/emailSend.gif',
//                           height: 110,
//                           width: 110,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Text(
//                           'Warning!',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 13,
//                         ),
//                         const Text(
//                           'Please Select Atleast One Image',
//                           style: TextStyle(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             textStyle: const TextStyle(fontSize: 16),
//                             fixedSize: const Size(150, 50),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14)),
//                           ),
//                           onPressed: () {
//                             Navigator.of(context).pop(true);
//                           },
//                           child: const Text(
//                             ' OK ',
//                             style: TextStyle(
//                               fontFamily: 'Raleway',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )) ??
//               false;
//         }

//         noImage();
//       }
//     }
//   } on Exception catch (e) {
//     print(e.toString());
//     Future<bool> ErrorMessage() async {
//       return (await showDialog(
//             context: ctx,
//             builder: (context) => AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               content: SizedBox(
//                 height: 185,
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/failed.svg',
//                       height: 110,
//                       width: 110,
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text(
//                       'Failed',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 13,
//                     ),
//                     const Text(
//                       'Form Was Not Submitted',
//                       style: TextStyle(),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         textStyle: const TextStyle(fontSize: 16),
//                         fixedSize: const Size(150, 50),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop(true);
//                       },
//                       child: const Text(
//                         ' Try Again ',
//                         style: TextStyle(
//                           fontFamily: 'Raleway',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )) ??
//           false;
//     }

//     ErrorMessage();
//   }
//   isProcessTrue = false;

//   return "false";
// }
