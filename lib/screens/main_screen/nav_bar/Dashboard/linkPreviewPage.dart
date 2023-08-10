import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../profile_page.dart';

class LinkPreview extends StatefulWidget {
  final String apiUrl;
  const LinkPreview({required this.apiUrl});
  @override
  _LinkPreviewState createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _MyBox = Hive.box('data');
  late Future<List<String>> _urlListFuture; // Initialize the field

  @override
  void initState() {
    super.initState();
    _urlListFuture =
        _getUrlList(); // Initialize the field with the future returned by _getUrlList()
  }

  Future<List<String>> _getUrlList() async {
    final response = await http.get(Uri.parse('https://www.google.com'));
    if (response.statusCode == 200) {
      final urlList = response.body
          .split("\n"); // Assuming the API returns URLs separated by newlines
      return urlList;
    } else {
      return Future.delayed(const Duration(seconds: 2), () {
        return [
          "https://www.youtube.com/watch?v=W1pNjxmNHNQ",
          "https://www.google.com/",
          "https://www.facebook.com/",
          "https://twitter.com/"
        ];
        // Call the API and return the list of URLs
        // This is just a placeholder method
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MaterialApp(
                            home: ProfilePage(),
                            debugShowCheckedModeBanner: false,
                          )),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.green.shade50,
                backgroundImage: NetworkImage(
                    "https://aws-akanoob.s3.ap-northeast-1.amazonaws.com/profile/${_MyBox.get("username")}/${_MyBox.get("username")}-pp.jpg"),
              ),
            ),
          ),
        ],
        title: const Text(
          'HRMS',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: FutureBuilder<List<String>>(
          future: _urlListFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<String> urlList = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: urlList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          AnyLinkPreview(link: urlList[index]),
                          const SizedBox(height: 25),
                        ],
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
