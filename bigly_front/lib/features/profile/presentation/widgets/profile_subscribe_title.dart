
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/features/profile/view_model/profile_view_model.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/widgets/avatar_with_size.dart';

class ProfileSubscribeTitle extends StatelessWidget {
  const ProfileSubscribeTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {

    final read = context.read<ProfileViewModel>();

    return Stack(
      children: [
        Container(
          // height: 40,
          margin: const EdgeInsets.only(left: 15),
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: context.width,
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text(
              text,
            ),
          ),
        ),

        AvatarWithSize(
          height: 40,
          width: 40,
          image: read.profileImage,
          borderColor: Colors.white,
        ),
      ],
    );
  }
}
