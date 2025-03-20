
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/data/models/group_model.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../core/data/models/user_model.dart';
import '../../../../../di_service.dart';

abstract class AddMemberRepo {
  Future<List<UserModel>> getUsers();
  Future<ChatModel?> createGroup(GroupModel groupModel);
  Future<List<UserModel>> getSubscribers(int id);
}

class AddMemberRepoImpl implements AddMemberRepo {

  AddMemberRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<List<UserModel>> getUsers() async {
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
  Future<ChatModel?> createGroup(GroupModel groupModel) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.post(
        'chats/create-group/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: groupModel.toJson,
      );

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        ChatModel chatModel = ChatModel.fromJsonOne(response.data);
        return chatModel;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<List<UserModel>> getSubscribers(int id) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'users/?content_plan_id=$id',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<UserModel> list = (response.data as List).map((e) => UserModel.fromJsonContent(e)).toList();
        return list;
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
