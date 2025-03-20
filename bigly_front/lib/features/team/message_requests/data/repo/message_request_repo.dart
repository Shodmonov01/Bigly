
import 'package:dio/dio.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../core/data/models/chat_model.dart';
import '../../../../../di_service.dart';

abstract class MessageRequestRepo {
  Future<List<ChatModel>> getRequests();
  Future<bool> acceptRequest(int chatId);
}

class MessageRequestRepoImpl implements MessageRequestRepo {

  MessageRequestRepoImpl(this.dio);
  Dio dio;

  @override
  Future<List<ChatModel>> getRequests() async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'chat-requests/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        final list = response.data;
        List<ChatModel> chatModels = [];
        for (var element in list) {
          ChatModel chatModel = ChatModel.fromJsonList(element);
          chatModels.add(chatModel);
        }
        return chatModels;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future<bool> acceptRequest(int chatId) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.post(
        'chats/$chatId/accept/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}