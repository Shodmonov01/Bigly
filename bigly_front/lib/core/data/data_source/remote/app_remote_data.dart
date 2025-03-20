
import 'package:dio/dio.dart';

import '../../../../di_service.dart';
import '../../models/user_model.dart';
import '../local/app_local_data.dart';

class AppRemoteData {

  static UserModel? userModel = UserModel();

  static Future<List<UserModel>> getUsers() async {
    try {
      var response = await getIt.get<Dio>().get(
        'users/',
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        List list = response.data;
        List<UserModel> listUser = [];
        for (var element in list) {
          UserModel userModel = UserModel.fromJsonContent(element);
          listUser.add(userModel);
        }
        return listUser;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<UserModel>> searchUsers(String username) async {
    try {
      var response = await getIt.get<Dio>().get(
        (username.isEmpty) ?
        'users/' :
        'users/?search=$username',
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        String myUserName = await AppLocalData.getUserName ?? '';
        List list = response.data;
        List<UserModel> listUser = [];
        for (var element in list) {
          UserModel userModel = UserModel.fromJsonContent(element);
          if (myUserName != userModel.username) listUser.add(userModel);
        }
        return listUser;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}