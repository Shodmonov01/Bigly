
class NotificationModel {
  int id = 0;
  String title = '';
  String body = '';
  String type = '';
  int created_at = 0;

  String? image;

  NotificationModel({required this.id,required this.title,required this.body,required this.type,required this.created_at});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> get toJson => {
    'id': id,
    'title': title,
    'body': body,
    'type': type,
    'created_at': created_at,
  };

}