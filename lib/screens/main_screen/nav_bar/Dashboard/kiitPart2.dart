import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kiitPart3.dart';
import 'package:hrms/screens/widget/CustomInputField.dart';

import '../../../widget/CustomText.dart';

class KIITPart2 extends StatefulWidget {
  final String add_ref;
  final String name;
  final String city;
  final String state;
  final int amt;

  KIITPart2({
    super.key,
    required this.add_ref,
    required this.amt,
    required this.city,
    required this.state,
    required this.name,
  });

  @override
  State<KIITPart2> createState() => _KIITPart2State();
}

class _KIITPart2State extends State<KIITPart2> {
  final contact_no = TextEditingController();
  final pin = TextEditingController();
  final email = TextEditingController();

  final unitList = ['ITI', 'Engineering', 'Polytechnic'];
  String department = 'Engineering';

  final unitList1 = ['Child Of A Friend', "Child's Relative", 'Others'];
  String relation = "Child's Relative";

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do You Want To Return To Previous Page'),
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
                CustomText(text: 'Pin Code'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.number,
                  textEditingController: pin,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's Pin Code",
                  icon: Icon(
                    Icons.money,
                    color: HexColor('#6A6A6A'),
                  ),
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
                  textEditingController: contact_no,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's Contact No",
                  icon: Icon(
                    Icons.numbers,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Email'),
                const SizedBox(
                  height: 10,
                ),
                CustomInputField(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: email,
                  primaryColor: HexColor("#F7F7F9"),
                  secondaryColor: HexColor('#6A6A6A'),
                  hint: "Enter Candidate's Email Address",
                  icon: Icon(
                    Icons.email,
                    color: HexColor('#6A6A6A'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: "Department"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.cast_for_education,
                        color: HexColor('#898989'),
                      ),
                      fillColor: HexColor('#F7F7F9'),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    value: department,
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
                        department = val as String;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: "Relation"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
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
                    if (contact_no.text.isEmpty ||
                        department.isEmpty ||
                        email.text.isEmpty ||
                        relation.isEmpty) {
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
                    Navigator.of(context).push(
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
                            KIITPart3(
                          pin: int.parse(pin.text),
                          add_ref: widget.add_ref,
                          amt: widget.amt,
                          city: widget.city,
                          contact: int.parse(contact_no.text),
                          department: department,
                          email: email.text,
                          name: widget.name,
                          relation: relation,
                          state: widget.state,
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
