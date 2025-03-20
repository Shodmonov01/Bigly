
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_enum.dart';

import '../../../../../core/widgets/avatar_with_size.dart';
import '../../../../../core/widgets/icon_with_backgeound.dart';
import '../../../../../router/router.dart';
import '../../../../home/view_model/home_view_model.dart';
import '../../../new_insight/presentation/pages/new_insight.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.read<HomeViewModel>().onOpenDrawer();
          },
          icon: const Icon(Icons.settings),
        ),
        title: const Text('Create'),
        actions: [
          GestureDetector(
            onTap: (){
              context.push(
                RouteNames.profile,
                extra: ProfileEnum.myProfile,
              );
            },
            child: AvatarWithSize(
              height: 35,
              width: 35,
              // image: context.watch<ProfileViewModel>().userModel?.profilePictureUrl,
              image: (AppRemoteData.userModel != null) ? AppRemoteData.userModel!.profilePictureUrl : '',
            ),
          ),
          10.wGap,
        ],
      ),

      body: GridView(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30
        ),
        children: [
          IconButtonWithBackground(
            onTap: () => context.push(
              RouteNames.newInsight,
              extra: (NewInsightEnum.selectContent, null),
            ),
            label: 'Create content',
            height: 80,
            width: 80,
            icon: Icon(Icons.play_arrow_outlined, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
          IconButtonWithBackground(
            onTap: () => context.push(RouteNames.newMessage),
            label: 'Create messages',
            height: 80,
            width: 80,
            icon: Icon(Icons.mail_outline, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
          IconButtonWithBackground(
            onTap: () {
              context.push(RouteNames.contentPlan,extra: AddToEnum.manage);
            },
            label: 'Manage content plan',
            height: 80,
            width: 80,
            icon: Icon(Icons.apps, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
          IconButtonWithBackground(
            onTap: () {},
            label: 'Manage your earnings',
            height: 80,
            width: 80,
            icon: Icon(Icons.apps_outage, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
          IconButtonWithBackground(
            onTap: () {},
            label: 'Boost subscriptions',
            height: 80,
            width: 80,
            icon: Icon(CupertinoIcons.heart, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
          IconButtonWithBackground(
            onTap: () {},
            label: 'Boost earnings',
            height: 80,
            width: 80,
            icon: Icon(Icons.upload_rounded, color: Colors.grey.shade800,),
            color: Colors.grey[300],
          ),
        ],
      ),

    );
  }
}
