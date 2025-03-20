
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/features/notifications/data/repo/notification_repo.dart';

import '../data/models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {

  NotificationViewModel(this.notificationRepo);
  final NotificationRepo notificationRepo;

  List<NotificationModel> notifications = [];
  Future<void> getNotifications() async {
    notifications = await notificationRepo.getNotifications();

    notifyListeners();
  }

}