import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/features/notifications/presentation/widgets/notification_item.dart';
import 'package:social_media_app/features/notifications/view_model/notification_view_model.dart';

import '../../../core/widgets/avatar_with_size.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Notifications'),
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: AvatarWithSize(
                image:
                (AppRemoteData.userModel != null) ?
                AppRemoteData.userModel!.profilePictureUrl! : '',
                height: 35,
                borderWidth: 1,
                borderColor: Colors.grey,
                width: 35,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          body:
          (viewModel.notifications.isEmpty) ?
          const Center(child: Text('No Notifications yet'),) :
          ListView.builder(
            itemCount: viewModel.notifications.length,
            itemBuilder: (context, index) {
              return NotificationItem(notificationModel: viewModel.notifications[index],);
            },
          ),
        );
      }
    );
  }
}
