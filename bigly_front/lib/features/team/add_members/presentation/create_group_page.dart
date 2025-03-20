
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/tools/app_image_picker.dart';
import 'package:social_media_app/features/team/add_members/view_model/add_member_view_model.dart';

import '../../../../core/widgets/avatar_with_size.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/button_circular.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {

  @override
  void initState() {
    context.read<AddMemberViewModel>().initCreateGroupPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<AddMemberViewModel>();
    final watch = context.watch<AddMemberViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text('Name Group'),
        actions: [
          ButtonCircular(
            onPressed: (){
              read.createGroup(context);
            },
            text: 'Next',
          ),
          10.wGap,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  10.wGap,
                  GestureDetector(
                    onTap: () async {
                      read.chooseGroupImage(context);
                    },
                    child: AvatarWithSize(
                      height: 60,
                      width: 60,
                      // image: '',
                      fileImage: read.groupImage,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.photo_camera_outlined, color: Colors.orange,),
                    ),
                  ),
                  10.wGap,
                  Expanded(
                    child: TextField(
                      controller: read.groupNameController,
                      decoration: const InputDecoration(
                        hintText: 'Group name',
                        fillColor: Colors.transparent
                      ),
                    ),
                  ),
                ],
              ),
            ),

            10.hGap,
            Text('Number of members: ${read.selectedUsers.length}'),
            10.hGap,
            if (read.selectedContentPlans.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image(
                          height: context.width / 2 - 20,
                          width: context.width / 2 - 20,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(read.selectedContentPlans.first.bannerUrl!),
                        ),

                        Container(
                          height: 30,
                          width: context.width / 4,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(45)
                          ),
                          child: Center(
                            child:
                            (read.selectedContentPlans.first.price_type == 'free') ?
                            Text('FREE') :
                            Text('\$${read.selectedContentPlans.first.price}/${read.selectedContentPlans.first.price_type!}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(read.selectedContentPlans.first.name!),
                ],
              ),
          ],
        ),
      )
    ).loadingView(read.isLoading);
  }
}
