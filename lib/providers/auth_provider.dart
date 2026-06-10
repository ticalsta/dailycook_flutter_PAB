import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = false;

  Future<bool> login(String email, String password) async {
    var url = Uri.parse("${ApiService.baseUrl}/login.php");
    var response = await http.post(
      url,
      body: {"email": email, "password": password},
    );

    var data = json.decode(response.body);

    if (data['status']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("login", true);

      isLogin = true;

      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    isLogin = false;

    notifyListeners();
  }
}
