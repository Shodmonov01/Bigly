import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/chat_settings_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/team/teams/view_model/teams_view_model.dart';

import '../../../../core/theme/my_theme.dart';
import '../../../../core/widgets/base_button.dart';

class TeamPageSettings extends StatelessWidget {
  const TeamPageSettings({super.key});

  @override
  Widget build(BuildContext context) {

    final read = context.read<TeamsViewModel>();
    final watch = context.watch<TeamsViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2,color: Colors.black),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //who respond message me
                    Text(
                      'Who can respond to my message',
                      style: MyTheme.smallGreyText,
                    ),
                    4.hGap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BaseButton(
                            onPressed: () {
                              bool superhero = read.chatSettingsModel!.responsePermissionsModel.superhero;
                              superhero = !superhero;
                              read.chatSettingsModel!.responsePermissionsModel.superhero = superhero;
                              read.changeChatSettings(read.chatSettingsModel!);
                            },
                            height: 35,
                            border: false,
                            width: 120,
                            color: watch.chatSettingsModel!.responsePermissionsModel.superhero ? Colors.black : Colors.grey.shade100,
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                            child: Text(
                              'Superheroes',
                              maxLines: 1,
                              style: watch.chatSettingsModel!.responsePermissionsModel.superhero ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                          ),
                        ),
                        5.wGap,
                        Expanded(
                          child: BaseButton(
                            border: false,
                            onPressed: () {
                              bool subscribers = read.chatSettingsModel!.responsePermissionsModel.subscriber;
                              subscribers = !subscribers;
                              read.chatSettingsModel!.responsePermissionsModel.subscriber = subscribers;
                              read.changeChatSettings(read.chatSettingsModel!);
                            },
                            height: 35,
                            width: 130,
                            color: watch.chatSettingsModel!.responsePermissionsModel.subscriber ? Colors.black : Colors.grey.shade100,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text('Subscribers',style: watch.chatSettingsModel!.responsePermissionsModel.subscriber ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                          ),
                        ),
                        5.wGap,
                        Expanded(
                          child: BaseButton(
                            border: false,
                            onPressed: () {
                              bool followers = read.chatSettingsModel!.responsePermissionsModel.follower;
                              followers = !followers;
                              read.chatSettingsModel!.responsePermissionsModel.follower = followers;
                              read.changeChatSettings(read.chatSettingsModel!);
                            },
                            height: 35,
                            color: watch.chatSettingsModel!.responsePermissionsModel.follower ? Colors.black : Colors.grey.shade100,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text('Followers',style: watch.chatSettingsModel!.responsePermissionsModel.follower ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    //who  message me first
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Who can message me first',style: MyTheme.smallGreyText,),
                        const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                      ],
                    ),
                    4.hGap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BaseButton(
                          onPressed: () {
                            read.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum = MessageFirstPermissionEnum.superHere;
                            read.changeChatSettings(read.chatSettingsModel!);
                          },
                          height: 35,
                          border: false,
                          width: 120,
                          color: watch.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum!.isSuperHere ? Colors.black : Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: Text('Superheroes',style: watch.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum!.isSuperHere ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                        ),
                        15.wGap,
                        BaseButton(
                          border: false,
                          onPressed: () {
                            read.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum = MessageFirstPermissionEnum.nobody;
                            read.changeChatSettings(read.chatSettingsModel!);
                          },
                          height: 35,
                          width: 130,
                          color: watch.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum!.isNobody ? Colors.black : Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Text('Nobody',style: watch.chatSettingsModel!.messageFirstPermissionModel!.messageFirstPermissionEnum!.isNobody ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Message notification',style: MyTheme.smallGreyText,),
                        const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                      ],
                    ),
                    4.hGap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BaseButton(
                          onPressed: () {
                            // read.changeNotificationMessage(MessageNotificationEnum.on);
                          },
                          height: 35,
                          border: false,
                          color: watch.notificationEnum!.on?Colors.black:Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                          child: Text('On',style:  watch.notificationEnum!.on ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,),
                        ),
                        BaseButton(
                          border: false,
                          onPressed: () {
                            // read.changeNotificationMessage(MessageNotificationEnum.pause);
                          },
                          height: 35,
                          color: watch.notificationEnum!.pause?Colors.black:Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Text('Pause',style:  watch.notificationEnum!.pause?MyTheme.mediumWhiteText:MyTheme.mediumBlackText,),
                        ),
                        BaseButton(
                          border: false,
                          onPressed: () {
                            // read.changeNotificationMessage(MessageNotificationEnum.of);
                          },
                          height: 35,
                          color: watch.notificationEnum!.of?Colors.black:Colors.grey.shade100,
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Text('Of',style:  watch.notificationEnum!.of?MyTheme.mediumWhiteText:MyTheme.mediumBlackText,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () => context.pop(context),
                  child: const Icon(Icons.close,color: Colors.black,)
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum PersonTypesEnum{superheroes, subscribers,followers,nobody,pinned}
enum MessageNotificationEnum{on,pause,of}

extension PersonTypesEnumEnumExtension on PersonTypesEnum {
  bool get superheroes => PersonTypesEnum.superheroes==this;
  bool get subscribers => PersonTypesEnum.subscribers==this;
  bool get followers => PersonTypesEnum.followers==this;
  bool get nobody => PersonTypesEnum.nobody==this;
  bool get pinned => PersonTypesEnum.pinned==this;
}

extension MessageNotificationEnumExtension on MessageNotificationEnum {
  bool get of => MessageNotificationEnum.of==this;
  bool get pause => MessageNotificationEnum.pause==this;
  bool get on => MessageNotificationEnum.on==this;
}
