
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/data/models/chat_settings_model.dart';
import 'package:social_media_app/core/extensions/date_time_extension.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../core/data/models/message_model.dart';
import '../../../../../core/data/models/user_model.dart';
import '../../../../../di_service.dart';

abstract class TeamRepo {
  Future<List<ChatModel>> getChats();
  Future<ChatModel?> getChat(int id);
  Future<List<MessageModel>> getMessages(int id, int page, int pageSize);
  Future<void> deleteChat(int id);
  Future<String?> sendFileToChat(MultipartFile file);
  Future<ChatSettingsModel?> getChatSettings();
  Future<ChatSettingsModel?> changeChatSettings(ChatSettingsModel chatSettingsModel);
}

class TeamRepoImpl implements TeamRepo {

  TeamRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'chats/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = response.data;
        return list.map((e) {
          ChatModel chatModel = ChatModel.fromJsonList(e);

          /// last message model
          if (chatModel.lastMessage == null) {
            chatModel.lastMessageModel == null;
          } else {
            chatModel.lastMessageModel = MessageModel.fromJson(chatModel.lastMessage!);

            if (chatModel.lastMessageModel!.media_type == null) {
              chatModel.lastMessageModel!.mediaTypeModel = null;
            } else {
              chatModel.lastMessageModel!.mediaTypeModel = chatModel.lastMessageModel!.media_type!.mediaTypeModelFromString!;
            }
          }

          /// last message text
          MessageModel? lastMessageModel;
          lastMessageModel =  chatModel.lastMessageModel;

          if (lastMessageModel!= null) {

            chatModel.lastMessageTime = lastMessageModel.created_at.toString().getTimeFromTimeStamp;

            if (lastMessageModel.content != null) {
              chatModel.lastMessageText = lastMessageModel.content!;
              final lastMessage = chatModel.lastMessageText;
              chatModel.lastMessageText = lastMessage.length > 20 ?
              '${lastMessage.substring(0, 20)}...' :
              '$lastMessage...';
            } else {
              chatModel.lastMessageText = lastMessageModel.media_type!;
              chatModel.lastMessageText = chatModel.lastMessageText[0].toUpperCase() + chatModel.lastMessageText.substring(1);
            }
          }
          // if (chatModel.new_message_count == null) {
          //   chatModel.newMessageCount = 0;
          // } else {
          //   chatModel.newMessageCount = chatModel.new_message_count!;
          // }

          if (chatModel.is_group!) {
            chatModel.chatIcon = Icons.group;
          } else {
            chatModel.chatIcon = CupertinoIcons.heart_slash;
          }

          return chatModel;
        },).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ChatModel?> getChat(int id) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'chats/$id/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ChatModel chatModel = ChatModel.fromJsonOne(response.data);
        // List? list = chatModel.messages ?? [];
        // String? userName = await AppLocalData.getUserName;
        // chatModel.messageModels = list.map((e) {
        //   return messageModel;
        // },).toList();

        chatModel.messageModels = chatModel.messageModels.reversed.toList();

        return chatModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MessageModel>> getMessages(int id, int page, int pageSize) async {
    try {
      String? userName = await AppLocalData.getUserName;
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'chats/$id/messages/?page=$page&page_size=$pageSize',
        // 'chats/$id/messages/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      print('GETMESSAGES: $id, $page, $pageSize, ${response.data}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = response.data['results'];
        List<MessageModel> messageModels =[];
        messageModels = list.map((e) {
          MessageModel messageModel = MessageModel.fromJson(e);

          if (messageModel.media_type == null) {
            messageModel.mediaTypeModel = null;
          } else {
            messageModel.mediaTypeModel =
            messageModel.media_type!.mediaTypeModelFromString!;
          }
          if (userName == e['sender_username']) {
            messageModel.isMine = true;
          } else {
            messageModel.isMine = false;
          }
          return messageModel;
        },).toList();
        return messageModels;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> deleteChat(int id) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.delete(
        'chats/$id/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
    } catch (_) {
      return;
    }
  }

  @override
  Future<String?> sendFileToChat(MultipartFile file) async {
    try {

      final token = await AppLocalData.getUserToken;
      final Response response = await dio.post(
        'media/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: FormData.fromMap({
          'media' : file
        }),
      );

      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['media'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ChatSettingsModel?> getChatSettings() async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'chat-settings/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ChatSettingsModel chatSettingsModel = ChatSettingsModel.fromJson(response.data);
        return chatSettingsModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ChatSettingsModel?> changeChatSettings(ChatSettingsModel chatSettingsModel) async {
    try {
      print('END::');
      print(chatSettingsModel.toJson());
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.put(
        'chat-settings/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: chatSettingsModel.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ChatSettingsModel chatSettingsModel = ChatSettingsModel.fromJson(response.data);
        return chatSettingsModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

}
