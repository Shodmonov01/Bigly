
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../core/data/models/user_model.dart';
import '../../../../../di_service.dart';

abstract class NewChatRepo {
  Future<List<UserModel>> getContacts();
  Future<List<UserModel>> searchUsers(String text);
  Future<ChatModel?> createChatPerson(String userName);
}

class NewChatRepoImpl implements NewChatRepo {

  NewChatRepoImpl(this.dio);
  Dio dio;

  @override
  Future<List<UserModel>> getContacts() async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'users/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200) {
        List list = response.data;
        List<UserModel> users = [];
        for (var element in list) {
          UserModel userModel = UserModel.fromJsonContent(element);
          users.add(userModel);
        }
        return users;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future<List<UserModel>> searchUsers(String text) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'users/?search=$text',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200) {
        List list = response.data;
        list.sort((a, b) {
          return a['first_name']!.compareTo(b['first_name']!);
        });
        List<UserModel> users = [];
        for (var element in list) {
          UserModel userModel = UserModel.fromJsonContent(element);
          users.add(userModel);
        }
        return users;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future<ChatModel?> createChatPerson(String userName) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.post(
        'chats/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: {
          'username' : userName,
        }
      );

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        ChatModel chatModel = ChatModel.fromJsonOne(response.data);
        return chatModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

}
