
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/grow_and_discover/grow/view_model/grow_view_model.dart';

import '../../../constants/app_images.dart';
import '../../../core/data/models/content_model.dart';
import '../../../core/widgets/avatar_with_size.dart';
import '../../../core/widgets/text_with_icon.dart';
import '../../../router/router.dart';
import '../../create_section/add_to/data/models/content_plan_model.dart';
import '../../profile/presentation/pages/profile_enum.dart';
import '../../profile/view_model/profile_view_model.dart';

class PostProfile extends StatefulWidget {
  const PostProfile({super.key, required this.contentModel});

  final ContentModel contentModel;

  @override
  State<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  @override
  Widget build(BuildContext context) {

    final read = context.read<GrowViewModel>();

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await context.read<ProfileViewModel>().getUserWithUsername(widget.contentModel.user!.username!);
            context.push(
              RouteNames.profile,
              extra: ProfileEnum.discover,
            );
          },
          child: Row(
            children: [
              AvatarWithSize(
                height: 45,
                width: 45,
                image: widget.contentModel.user!.profilePictureUrl ?? '',
              ),
              10.wGap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.contentModel.contentPlanModel != null) ?
                    widget.contentModel.contentPlanModel!.name ?? '' :
                    widget.contentModel.user!.firstName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.contentModel.contentPlanModel != null)
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'by ',
                        ),
                        TextSpan(
                          text: '@${widget.contentModel.user!.username}',
                          style: const TextStyle(color: Colors.grey)
                        ),
                      ]
                    )
                  )
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(15)
          ),
          child: GestureDetector(
            onTap: () {
              read.subscribe(widget.contentModel.contentPlanModel!.id!);
              widget.contentModel.has_subscribed = true;
              setState(() {});
            },
            child: TextWithIcon(
              text: (widget.contentModel.has_subscribed!) ?
              'Subscribed' : ' Subscribe',
              icon: (widget.contentModel.has_subscribed!) ?
              const Icon(Icons.done, size: 20,) : const SizedBox.shrink(),
              iconAlignment: TextsIconAlignment.left,
            ),
          )
        ),
        5.wGap,
        GestureDetector(
          onTap: () {
            widget.contentModel.is_following = true;
            read.follow(widget.contentModel.user!.username!);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
            child: (widget.contentModel.is_following!) ?
            const Icon(Icons.star, color: Colors.orange,):
            const Icon(Icons.star_border),
          ),
        ),
        10.wGap,
      ],
    );
  }
}
