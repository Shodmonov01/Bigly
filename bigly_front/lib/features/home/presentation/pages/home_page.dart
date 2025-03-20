
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/features/notifications/presentation/notifications_page.dart';
import 'package:social_media_app/features/profile/view_model/profile_view_model.dart';
import 'package:social_media_app/features/team/teams/presentation/teams_page.dart';
import '../../../../constants/app_images.dart';
import '../../../../core/theme/my_theme.dart';
import '../../../../core/widgets/avatar_with_size.dart';
import '../../../../core/widgets/drawer_navigation_button.dart';
import '../../../../router/router.dart';
import '../../../create_section/create/presentation/pages/create_page.dart';
import '/features/home/view_model/home_view_model.dart';
import 'package:provider/provider.dart';

import '../../../grow_and_discover/discover/presentation/pages/discover_page.dart';
import '../../../grow_and_discover/grow/presentation/pages/grow_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    context.read<ProfileViewModel>().getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<HomeViewModel>().scaffoldKey,
      body: IndexedStack(
        index: context.watch<HomeViewModel>().currentIndex,
        children: const [
          GrowPage(),
          DiscoverPage(),
          CreatePage(),
          NotificationsPage(),
          TeamsPage()
        ],
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.hGap,
                  AvatarWithSize(
                    image:
                    (AppRemoteData.userModel != null) ?
                    AppRemoteData.userModel!.profilePictureUrl :
                    null,
                    height: 35,
                    borderWidth: 1.4,
                    borderColor: Colors.grey,
                    width: 35,
                  ),
                  3.hGap,
                  Text(
                    (AppRemoteData.userModel != null) ?
                    AppRemoteData.userModel!.firstName ?? '' : '',
                    style: MyTheme.mediumBlackText,
                  ),
                  Text(
                    (AppRemoteData.userModel != null) ?
                    '@${AppRemoteData.userModel!.username ?? ''}' : '',
                    style: MyTheme.bodyMediumGreyText,
                  ),
                  7.hGap,
                  Text('Your Team currently',style: MyTheme.mediumBlackText,),
                  3.hGap,
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                (AppRemoteData.userModel != null) ?
                                '${AppRemoteData.userModel!.follower_count}' :
                                '',
                                style: MyTheme.mediumBlackText,
                              ),
                              TextSpan(text: ' Superheroes',style: MyTheme.bodyMediumGreyText),
                            ]
                        ),
                      ),
                      10.wGap,
                      RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: '-',style: MyTheme.mediumBlackText),
                              TextSpan(text: ' Subscribers',style: MyTheme.bodyMediumGreyText),
                            ]
                        ),
                      )
                    ],
                  ),
                  3.hGap,
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(text: '0',style: MyTheme.mediumBlackText),
                          TextSpan(text: ' Soulmates',style: MyTheme.bodyMediumGreyText),
                        ]
                    ),
                  ),
                  20.hGap,
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // DrawerNavigationButton(
                    //     titleIsGrey: false,
                    //     onTap: () {
                    //
                    //     },
                    //     icon: const Icon(CupertinoIcons.person),
                    //     title: 'My Profile'
                    // ),
                    // DrawerNavigationButton(
                    //     titleIsGrey: false,
                    //     onTap: () {},
                    //     icon: const Icon(CupertinoIcons.heart),
                    //     title: 'Creator Profile'
                    // ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {},
                        icon: const Icon(Iconsax.diamonds_outline),
                        title: 'My Interests'
                    ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {
                          context.push(RouteNames.myPayouts);
                        },
                        icon: const Icon(Icons.money),
                        title: 'My Payouts & Payments'
                    ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {
                          context.push(RouteNames.myPayouts);
                        },
                        icon: const Icon(Icons.restore_sharp),
                        title: 'Archive'
                    ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {},
                        icon: const Icon(Iconsax.bookmark_outline),
                        title: 'Saved'
                    ),
                    // DrawerNavigationButton(
                    //     titleIsGrey: false,
                    //     onTap: () {},
                    //     icon: const Icon(Icons.money),
                    //     title: 'Monetization'
                    // ),
                    DrawerNavigationButton(
                      onTap: () {},
                      icon: const Icon(CupertinoIcons.star),
                      title: 'My Soulmates',
                      titleIsGrey: true,
                      trailing: DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).colorScheme.primary
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6,vertical: 1),
                          child: Text('Soon',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 40,
                    ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {},
                        icon: const Icon(Iconsax.setting_2_outline),
                        title: 'All Settings'
                    ),
                    const Divider(
                      indent: 30,
                      endIndent: 40,
                    ),
                    DrawerNavigationButton(
                        titleIsGrey: false,
                        onTap: () {},
                        icon: const Icon(Icons.help_outline),
                        title: 'Help & Support'
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
