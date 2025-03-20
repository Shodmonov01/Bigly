
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/features/login/data/models/check_password_model.dart';
import 'package:social_media_app/features/login/data/models/check_password_model.dart';

import '../../../../core/data/data_source/local/app_local_data.dart';
import '../models/check_user_name_model.dart';


abstract class LoginRepo {
  Future<void> register(UserModel userModel);
  Future<bool> login(String userName, String password);
  Future<CheckUserNameModel?> checkUserName(String userName);
  Future<CheckPasswordModel?> checkPassword(String password);
}

class LoginRepoImpl extends LoginRepo {

  LoginRepoImpl(this.dio);

  Dio dio;

  @override
  Future<bool> register(UserModel userModel) async {
    try {
      final Response response = await dio.post(
        'register/',
        data: userModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        UserModel userModelIn = UserModel.fromJsonRegister(response.data);
        await AppLocalData.saveUserToken(userModelIn.access);
        await AppLocalData.saveUserRefreshToken(userModelIn.refresh);
      }
      return true;
    } catch (e) {
      return false;
    }

  }

  @override
  Future<bool> login(String userName, String password) async {
    try {
      final Response response = await dio.post(
        'login/',
        data: {
          'username' : userName,
          'password' : password,
        }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        UserModel userModelIn = UserModel.fromJsonRegister(response.data);
        await AppLocalData.saveUserToken(userModelIn.access);
        await AppLocalData.saveUserRefreshToken(userModelIn.refresh);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }

  }

  @override
  Future<CheckUserNameModel?> checkUserName(String userName) async {
    try {
      final Response response = await dio.post(
        'check-username/',
        data: {
          "username": userName,
        },
      );

      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckUserNameModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CheckPasswordModel?> checkPassword(String password) async {
    try {
      final Response response = await dio.post(
        'check-password/',
        data: {
          "password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckPasswordModel.fromJson(response.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

}