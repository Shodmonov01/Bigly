

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_model.dart';

class ChatModel {
  int? id;
  bool? is_group;
  String? type;
  ChatTypeModel? typeModel;
  String? name;
  String? image;
  Map? lastMessage;
  List? participants;
  int? created_at;
  int? new_message_count;
  bool is_request = false;
  List? messages;

  List<MessageModel> messageModels = [];
  MessageModel? lastMessageModel;
  String lastMessageText = 'No messages yet';
  String lastMessageTime = '';
  // int newMessageCount = 0;
  IconData? chatIcon;

  ChatModel({
    this.id,
    this.is_group,
    this.type,
    this.name,
    this.image,
    this.participants,
    this.created_at
  });

  ChatModel.fromJsonList(Map<String, dynamic> json) {
    id = json['id'];
    is_group = json['is_group'];
    type = json['type'];
    typeModel = json['type'] == null ? null : ChatTypeModel.fromJson(json['type']);
    name = json['name'];
    image = json['image'];
    lastMessage = json['last_message'];
    new_message_count = json['new_message_count'];
    is_request = json['is_request'];
    // participants = json['participants'];
    created_at = json['created_at'];
  }

  ChatModel.fromJsonOne(Map<String, dynamic> json) {
    id = json['id'];
    is_group = json['is_group'];
    type = json['type'];
    typeModel = typeModel == null ? null : ChatTypeModel.fromJson(json['type']);
    name = json['name'];
    image = json['image'];
    lastMessage = json['last_message'];
    participants = json['participants'];
    created_at = json['created_at'];
    messages = json['messages'];
  }

  Map<String, dynamic> get toJson => {
    'id': id,
    'is_group' : is_group,
    'type' : type,
    'name' : name,
    'image' : image,
    'participants' : participants,
    'created_at' : created_at,
  };

}

class ChatTypeModel {
  ChatTypeEnum? type;

  ChatTypeModel.fromJson(String json) {
    switch (json) {
      case 'superhero':
        type = ChatTypeEnum.superhero;
        break;
      case 'subscriber':
        type = ChatTypeEnum.subscriber;
        break;
      case 'follower':
        type = ChatTypeEnum.follower;
        break;
      case 'group':
        type = ChatTypeEnum.group;
        break;
    }
  }

  String get toJson => type.toString().split('.').last;
}

enum ChatTypeEnum {
  superhero,
  subscriber,
  follower,
  group,
}

extension ChatTypeEnumExtension on ChatTypeEnum {
  bool get isSuperhero => ChatTypeEnum.superhero == this;
  bool get isSubscriber => ChatTypeEnum.subscriber == this;
  bool get isFollower => ChatTypeEnum.follower == this;
  bool get isGroup => ChatTypeEnum.group == this;
}

