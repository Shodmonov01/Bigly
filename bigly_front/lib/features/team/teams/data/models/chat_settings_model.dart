
class ChatSettingsModel {
  String? message_first_permission;
  Map? response_permissions;
  bool? follower;
  bool? superhero;
  bool? subscriber;

  ResponsePermissionModel? responsePermissionModel;
  MessageFirstPermission? messageFirstPermission;

}

class ResponsePermissionModel {
  bool? follower;
  bool? superhero;
  bool? subscriber;

  ResponsePermissionModel.fromJson(Map<String, dynamic> map) {
    follower = map['follower'] ?? false;
    superhero = map['superhero'] ?? false;
    subscriber = map['subscriber'] ?? false;
  }

  Map<String, dynamic> get toJson => {
    'follower' : follower,
    'superhero' : superhero,
    'subscriber' : subscriber
  };
}

enum MessageFirstPermission {
  nobody,
  superhero
}

extension MessageFirstPermissionExtension on String {
  bool get nobody => this == 'nobody';
  bool get superhero => this == 'superhero';
}

// extension MessageFirstPermissionExtension on MessageFirstPermission {
//   bool get nobody => this == 'nobody';
//   bool get superhero => this == 'superhero';
// }
