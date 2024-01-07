import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> persistToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    storage.delete(key: 'token');
    storage.deleteAll();
  }

  Future<String> login(String username, String password) async {
    Map data = {"username": username, "password": password};
    var body = json.encode(data);
    final _MyBox = Hive.box('data');
    var response = await http
        .post(Uri.parse("http://10.5.72.130:5000/api/app/login"),
            headers: {"Content-Type": "application/json"}, body: body)
        .timeout(const Duration(seconds: 10), onTimeout: () {
      return http.Response('Error', 408);
    });
    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      _MyBox.put("token", jsondata['token']);

      var userResponse = await http.get(
          Uri.parse("http://10.5.72.130:5000/api/app/user/"),
          headers: {'Authorization': 'Bearer ${_MyBox.get('token')}'});

      if (userResponse.statusCode == 200) {
        var jsonDataUser = json.decode(userResponse.body);
        _MyBox.put("firstName", jsonDataUser['fname']);
        _MyBox.put("lastName", jsonDataUser['lname']);
        _MyBox.put('department', jsonDataUser['department']);
        _MyBox.put('username', jsonDataUser['username']);
        _MyBox.put('verifiedEmail', jsonDataUser['verified']);
        _MyBox.put('level', jsonDataUser['level']);
        _MyBox.put('email', jsonDataUser['email']);
        _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
        _MyBox.put('mobile', jsonDataUser['mobile']);
        _MyBox.put('address', jsonDataUser['address']);
        _MyBox.put('pass_reset', jsonDataUser['pass_reset']);
        _MyBox.put('id', jsonDataUser['_id']);
        print('id = ${_MyBox.get('_id')}');
      }
    } else if (response.statusCode == 401) {
      final _MyBox = Hive.box('data');
      _MyBox.put("loginStatus", "Wrong Username/Password");
      throw HttpException('${response.statusCode}');
    } else if (response.statusCode == 404) {
      final _MyBox = Hive.box('data');
      _MyBox.put("loginStatus", "Wrong Username/Password");
      throw HttpException('${response.statusCode}');
    } else {
      throw HttpException('${response.statusCode}');
    }

    return "false";
  }

  Future<String> email(String email) async {
    final _MyBox = Hive.box('data');
    var userResponse = await http.get(
        Uri.parse("http://10.5.72.130:5000/api/app/user/"),
        headers: {'Authorization': 'Bearer ${_MyBox.get('token')}'});

    if (userResponse.statusCode == 200) {
      var jsondata = json.decode(userResponse.body);

      if (jsondata['pass_reset'] == "true") {
        return "success";
      } else {
        return "fail";
      }
    }
    return "fail";
  }
}
