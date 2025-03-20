
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/features/grow_and_discover/grow/data/repo/grow_repo.dart';
import 'package:social_media_app/features/grow_and_discover/grow/view_model/grow_view_model.dart';
import 'package:social_media_app/features/notifications/view_model/notification_view_model.dart';

import '../../../../constants/app_icons.dart';
import '../../../home/view_model/home_view_model.dart';
import '../../../team/teams/view_model/teams_view_model.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key, required this.child});

  final Widget child;

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {

  bool firstTimeGrow = true;
  bool firstTimeDiscover = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Theme(
        data: context.theme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          onTap: (index) {

            setState(() {});

            context.read<GrowViewModel>().stopAllVideos();

            context.read<HomeViewModel>().onTapNavBar(index);
            if (index == 0) {
              // if (firstTimeGrow) {
              //   firstTimeGrow = false;
              //   context.read<GrowViewModel>().getPosts();
              // }
            }
            if (index == 1) {
              if (firstTimeDiscover) {
                firstTimeDiscover = false;
                // context.read<GrowViewModel>().getDiscover();
              }
            }
            if (index == 3) {
              context.read<NotificationViewModel>().getNotifications();
            }

            if (index == 4) {
              context.read<TeamsViewModel>().getChats();
            }

          },
          currentIndex: context.watch<HomeViewModel>().currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.growUnselect,
                height: 35,
              ),
              activeIcon: Image.asset(
                AppIcons.growSelect,
                height: 35,
              ),
              label: 'Grow',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.discoverUnselect,
                height: 35,
              ),
              activeIcon: Image.asset(
                AppIcons.discoverSelect,
                height: 35,
              ),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.createUnselect,
                height: 35,
              ),
              activeIcon: Image.asset(
                AppIcons.createSelect,
                width: 30,
                // height: 35,
              ),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                height: 35,
                AppIcons.notificationsUnselect,
              ),
              activeIcon: Image.asset(
                AppIcons.notificationsSelect,
                height: 35,
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AppIcons.teamUnselect,
                height: 35,
              ),
              activeIcon: Image.asset(
                AppIcons.teamSelect,
                height: 35,
              ),
              label: 'Team',
            ),
          ],
        ),
      ),
    );
  }
}
