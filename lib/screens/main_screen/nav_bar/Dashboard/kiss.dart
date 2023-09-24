import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/kissPart2.dart';
import 'package:hrms/screens/main_screen/nav_bar/Dashboard/product.dart';
import 'package:hrms/screens/widget/CustomButton.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../widget/CustomInputField.dart';
import '../../../widget/CustomText.dart';

class Data {
  final String product_name;
  final String pid;
  final double price;
  final String id;

  Data(
      {required this.product_name,
      required this.pid,
      required this.price,
      required this.id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      product_name: json['product_name'],
      pid: json['pid'],
      price: json['price'],
      id: json['_id'],
    );
  }
}

class KIIS extends StatefulWidget {
  const KIIS({super.key});

  @override
  State<KIIS> createState() => _KIISState();
}

List<Data> _items = [];
List<Data> _filteredItems = [];

class _KIISState extends State<KIIS> {
  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<List<Data>> _fetchItems() async {
    var url = Uri.parse('http://10.5.72.44:5000/api/kiss/products/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Data> items = data.map((item) => Data.fromJson(item)).toList();
      setState(() {
        _items = items;
        _filteredItems = items;
      });
      return items;
    } else {
      return _items;
    }
  }

  final TextEditingController city = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController quan = TextEditingController(text: '0');
  TextEditingController amt = TextEditingController(text: '0');

  late List<String> nameProduct = [];
  late List<String> idP = [];
  late List<String> quantityP = [];
  late List<String> PriceP = [];
  late double priceOnly = 0.0;

  final _MyBox = Hive.box('data');

  final dateController = TextEditingController();

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

  void _filterItems(String query) {
    List<Data> filteredItems = [];
    if (query.isNotEmpty) {
      _items.forEach((item) {
        if (item.product_name.toLowerCase().contains(query.toLowerCase())) {
          filteredItems.add(item);
        }
      });
    } else {
      filteredItems = _items;
    }
    setState(() {
      _filteredItems = filteredItems;
    });
  }

  List<Map<String, dynamic>> _dataList = [];

  final Map<String, dynamic> Senddata = {
    "product_name": [],
    "pid": ["hjk", "ergdfv", "vdfdfv"],
    "pquantity": [1, 2, 3],
    "pprice": [1, 2, 3],
    "tpprice": 350,
  };

  @override
  Widget build(BuildContext context) {
    double price = 0;
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
              'KISS FORM',
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
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
                CustomText(text: 'Quantity'),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onTap: () {
                          _fetchItems();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Scaffold(
                                  body: GestureDetector(
                                    onTap: () {},
                                    child: FutureBuilder<List<Data>>(
                                      future: _fetchItems(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    price = snapshot
                                                        .data![index].price;
                                                    print(
                                                        '$price is the price of the product');
                                                    item.text = snapshot
                                                        .data![index]
                                                        .product_name;
                                                    _MyBox.put(
                                                        'currentKissProduct',
                                                        snapshot.data![index]
                                                            .product_name);
                                                    _MyBox.put(
                                                        'currentKissProductPrice',
                                                        snapshot.data![index]
                                                            .price);
                                                    _MyBox.put(
                                                        'currentKissProductPid',
                                                        snapshot
                                                            .data![index].pid);
                                                    _MyBox.put(
                                                        'currentKissProductEid',
                                                        snapshot
                                                            .data![index].id);
                                                    setState(() {
                                                      amt;
                                                      price;
                                                      _MyBox.put(
                                                          'currentKissProduct',
                                                          snapshot.data![index]
                                                              .product_name);
                                                      _MyBox.put(
                                                          'currentKissProductPrice',
                                                          snapshot.data![index]
                                                              .price);
                                                    });

                                                    Navigator.of(context).pop();

                                                    // int count = 0;
                                                    // Navigator.of(context)
                                                    //     .popUntil((_) =>
                                                    //         count++ >= 2);
                                                  },
                                                  child: Container(
                                                    height: 75,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Text(snapshot
                                                          .data![index]
                                                          .product_name),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString());
                                        }
                                        return const Center(
                                            child:
                                                CircularProgressIndicator());
                                      },
                                    ),
                                  ),
                                );
                              });
                        },
                        readOnly: true,
                        controller: item,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: HexColor('#6A6A6A'),
                          fontFamily: 'Raleway',
                        ),
                        cursorColor: HexColor('#6A6A6A'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.shopping_cart,
                            color: HexColor('#6A6A6A'),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          hintStyle: TextStyle(color: HexColor('#6A6A6A')),
                          hintText: "Select Item",
                          filled: true,
                          fillColor: HexColor("#F7F7F9"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          double res = _MyBox.get('currentKissProductPrice');

                          _MyBox.put('currentKissProductTotalPrice',
                              res * int.parse(value));

                          print("${res * int.parse(value)} i am value\n");

                          amt.text = (res * int.parse(value)).toString();
                          setState(() {
                            amt;
                          });
                        },
                        controller: quan,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: HexColor('#6A6A6A'),
                          fontFamily: 'Raleway',
                        ),
                        cursorColor: HexColor('#6A6A6A'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: HexColor('#6A6A6A'),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          hintStyle: TextStyle(color: HexColor('#6A6A6A')),
                          hintText: "Quantity",
                          filled: true,
                          fillColor: HexColor("#F7F7F9"),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Amount Paid'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: amt,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: HexColor('#6A6A6A'),
                    fontFamily: 'Raleway',
                  ),
                  cursorColor: HexColor('#6A6A6A'),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.money,
                      color: HexColor('#6A6A6A'),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    hintStyle: TextStyle(color: HexColor('#6A6A6A')),
                    hintText: "Total Amount",
                    filled: true,
                    fillColor: HexColor("#F7F7F9"),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomElevatedButton(
                    primaryColor: Colors.green,
                    secondaryColor: Colors.white,
                    onPress: () {
                      if (item.text == '' ||
                          quan.text == '0' ||
                          dateController == '') {
                        Fluttertoast.showToast(
                            msg: "Please Fill All The Field",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        //print("$nameProduct kdfjadklhaljkhgkjshgs");
                        nameProduct.add(item.text);
                        idP.add(_MyBox.get('currentKissProductPid'));
                        PriceP.add(amt.text);
                        quantityP.add(quan.text);
                        priceOnly = priceOnly + int.parse(amt.text);
                      } else {
                        final newData = {
                          'Sno': _dataList.length,
                          'name': item.text,
                          'quantity': quan.text,
                          'total': amt.text,
                        };
                        setState(() {
                          _dataList.add(newData);
                        });
                        nameProduct.add(item.text);
                        idP.add(_MyBox.get('currentKissProductPid'));
                        PriceP.add(amt.text);
                        quantityP.add(quan.text);
                        priceOnly = priceOnly + double.parse(amt.text);
                        Fluttertoast.showToast(
                            msg: "Item Added Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    text: 'Add Item'),
                const SizedBox(
                  height: 10,
                ),
                CustomText(text: 'Receipt'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: DataTable(
                        //    {'Sno': 1, 'name': 'adi', 'quantity': 3, 'total': 88},
                        columns: [
                          const DataColumn(label: Text('Sno')),
                          const DataColumn(label: Text('name')),
                          const DataColumn(label: Text('quantity')),
                          const DataColumn(label: Text('total')),
                        ],
                        rows: _dataList
                            .map(
                              (data) => DataRow(cells: [
                                DataCell(
                                  GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        _dataList.remove(data);
                                      });
                                    },
                                    child: Text('${data['Sno']}'),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        _dataList.remove(data);
                                      });
                                    },
                                    child: Text('${data['name']}'),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        _dataList.remove(data);
                                      });
                                    },
                                    child: Text('${data['quantity']}'),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        _dataList.remove(data);
                                      });
                                    },
                                    child: Text('${data['total']}'),
                                  ),
                                ),
                              ]),
                            )
                            .toList(),
                      ),
                      // child: DataTable(columns: const [
                      //   DataColumn(
                      //     label: Text(
                      //       'SNo',
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ),
                      //   DataColumn(
                      //     label: Text(
                      //       'Name',
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ),
                      //   DataColumn(
                      //     label: Text(
                      //       'Quantity',
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ),
                      //   DataColumn(
                      //     label: Text(
                      //       'Amount',
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ),
                      // ], rows: const [
                      //   DataRow(cells: [
                      //     DataCell(Text('1')),
                      //     DataCell(Text('Arshik')),
                      //     DataCell(Text('3')),
                      //     DataCell(Text('265\$')),
                      //   ]),
                      //   DataRow(cells: [
                      //     DataCell(Text('1')),
                      //     DataCell(Text('Arshik')),
                      //     DataCell(Text('3')),
                      //     DataCell(Text('265\$')),
                      //   ]),
                      //   DataRow(cells: [
                      //     DataCell(Text('1')),
                      //     DataCell(Text('Arshik')),
                      //     DataCell(Text('3')),
                      //     DataCell(Text('265\$')),
                      //   ]),
                      //   DataRow(cells: [
                      //     DataCell(Text('1')),
                      //     DataCell(Text('Arshik')),
                      //     DataCell(Text('3')),
                      //     DataCell(Text('265\$')),
                      //   ]),
                      // ]),
                    )),
                const SizedBox(
                  height: 25,
                ),
                CustomElevatedButton(
                    primaryColor: Colors.green,
                    secondaryColor: Colors.white,
                    onPress: () {
                      print(nameProduct);
                      if (nameProduct.isEmpty ||
                          idP.isEmpty ||
                          quantityP.isEmpty ||
                          PriceP.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please Add Atleast One Item",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KISSPart2(
                                data: {
                                  "product_name": nameProduct,
                                  "pid": idP,
                                  "pquantity": quantityP,
                                  "pprice": PriceP,
                                  "tpprice": priceOnly,
                                },
                              )));
                    },
                    text: 'Next'),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
