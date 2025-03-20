
class ChatSettingsModel {
  ChatSettingsModel();

  String? message_first_permission;
  Map<String, dynamic>? response_permissions = {
    "follower": true,
    "superhero": true,
    "subscriber": true
  };

  MessageFirstPermissionModel? messageFirstPermissionModel;
  ResponsePermissionsModel responsePermissionsModel = ResponsePermissionsModel();

  ChatSettingsModel.fromJson(Map<String, dynamic> json) {
    message_first_permission = json['message_first_permission'];
    response_permissions = json['response_permissions'];

    messageFirstPermissionModel = MessageFirstPermissionModel.fromJson(json['message_first_permission']);
    responsePermissionsModel = ResponsePermissionsModel.fromJson(json['response_permissions']);
  }

  Map<String, dynamic> toJson() => {
    'message_first_permission': messageFirstPermissionModel!.toJson,
    'response_permissions': responsePermissionsModel.toJson(),
  };
}

class ResponsePermissionsModel {
  bool follower = false;
  bool superhero = false;
  bool subscriber = false;

  ResponsePermissionsModel();

  ResponsePermissionsModel.fromJson(Map<String, dynamic> json) {
    follower = json['follower'] ?? false;
    superhero = json['superhero'] ?? false;
    subscriber = json['subscriber'] ?? false;
  }

  Map<String, dynamic> toJson() => {
    'follower': follower,
    'superhero': superhero,
    'subscriber': subscriber,
  };

}

class MessageFirstPermissionModel {
  MessageFirstPermissionEnum? messageFirstPermissionEnum;

  MessageFirstPermissionModel.fromJson(String json) {
    if (json == 'superhero') {
      messageFirstPermissionEnum = MessageFirstPermissionEnum.superHere;
    } else if (json == 'nobody') {
      messageFirstPermissionEnum = MessageFirstPermissionEnum.nobody;
    }
  }

  String get toJson => (messageFirstPermissionEnum!.isSuperHere) ? 'superhero' : 'nobody';

}
enum MessageFirstPermissionEnum {
  superHere, nobody,
}
extension MessageFirstPermissionModelExtension on MessageFirstPermissionEnum {
  bool get isSuperHere => MessageFirstPermissionEnum.superHere == this;
  bool get isNobody => MessageFirstPermissionEnum.nobody == this;
}
