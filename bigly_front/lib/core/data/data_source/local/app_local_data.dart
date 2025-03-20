
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AppLocalData {
  static Box<dynamic> box = Hive.box('appBox');

  static Future<void> saveUserName(String? userName) async {
    await box.put('userName', userName);
  }

  static Future<String?> get getUserName async {
    return await box.get('userName');
  }

  static Future<void> saveUserToken(String? token) async {
    await box.put('token', token);
  }

  static Future<String?> get getUserToken async {
    return await box.get('token');
  }

  static Future<void> saveUserRefreshToken(String? refreshToken) async {
    await box.put('refreshToken', refreshToken);
  }

  static Future<String?> get getUserRefreshToken async {
    return await box.get('refreshToken');
  }

  static Future<void> removeAll() async {
    await box.deleteAll([
      'token',
      'refreshToken',
      'userModel',
    ]);
  }



  static Future<void> updateToken() async {
    String? refreshToken = await getUserRefreshToken;
    if (refreshToken == null) return;
    Dio dio = Dio();
    Response response = await dio.post(
      'http://3.142.45.117:8445/api/auth/refresh',
      data: {
        'token' : refreshToken,
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        }
      ),
    );

    if (response.statusCode == 200) {
      print('TOKEN: ${response.data['token']}');
      print('REFRESHTOKEN: ${response.data['refreshToken']}');
      await saveUserToken(response.data['token']);
      await saveUserRefreshToken(response.data['refreshToken']);
    }

  }

}