
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/data/models/user_model.dart';

import '../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../di_service.dart';
import '../models/notification_model.dart';

abstract class NotificationRepo {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRepoImpl implements NotificationRepo {

  NotificationRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'notifications/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List list = response.data;
        List<NotificationModel> notifications = [];

        for (var item in list) {
          NotificationModel notificationModel = NotificationModel.fromJson(item);
          String username = '';
          if (notificationModel.type == 'follow') {
            RegExp regExp = RegExp(r'@(\w+)');
            Match? match = regExp.firstMatch(notificationModel.title);
            if (match != null) {
              username = match.group(1)!;
            }
            final users = await AppRemoteData.searchUsers(username);
            UserModel userModel = users.first;
            notificationModel.image = userModel.profilePictureUrl;
          }
          notifications.add(notificationModel);
        }


        return notifications;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
