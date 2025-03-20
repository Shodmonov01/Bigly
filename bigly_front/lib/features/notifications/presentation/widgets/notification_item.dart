import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';
import 'package:social_media_app/features/notifications/data/models/notification_model.dart';

import '../../../../constants/app_icons.dart';
import '../../../../constants/app_images.dart';
import '../../../../core/theme/my_theme.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notificationModel});
  // final bool isDiscover;
  // final int index;
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          // const Divider(thickness: .8,height: 0,),
          1 .hGap,
          const Divider(thickness: .8,height: 0,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    // isDiscover?
                    AppIcons.discoverSelect,
                    // AppIcons.growSelect,
                    height: 35,
                  ),
                  15.wGap,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(notificationModel.type,style: MyTheme.smallGreyText,),
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(Icons.more_horiz,color: Colors.grey,)
                            ),
                          ],
                        ),
                        AvatarWithSize(
                          radius: 17,
                          image: notificationModel.image,
                        ),
                        3.hGap,
                        Text(
                          notificationModel.title,
                          style: MyTheme.mediumBlackText,
                        ),
                        Text(
                          notificationModel.body,
                          style: MyTheme.bodyMediumGreyText,maxLines: 2,overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          3.hGap,
          // index!=6?const SizedBox.shrink():
          // const Divider(thickness: .8,height: 0,)
        ],
      ),
    );
  }
}
