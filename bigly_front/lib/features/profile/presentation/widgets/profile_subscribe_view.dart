
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/profile/presentation/widgets/profile_subscribe_title.dart';

import '../../../../core/widgets/text_with_icon.dart';
import '../../view_model/profile_view_model.dart';

class ProfileSubscribeView extends StatelessWidget {
  const ProfileSubscribeView({super.key});

  @override
  Widget build(BuildContext context) {

    final read = context.read<ProfileViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUBSCRIPTION',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const ProfileSubscribeTitle(
                text: "Only 4 spots left! You'll get a small surprise in DM's when you subscribe!",
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    const TextWithIcon(
                      text: "Full access to this user's selected program",
                      icon: Icon(Icons.done, color: Colors.orange,),
                      iconAlignment: TextsIconAlignment.left,
                      space: 10,
                      isExpandText: true,
                    ),
                    5.hGap,
                    const TextWithIcon(
                      text: "Direct messages and coaching tips from this user",
                      icon: Icon(Icons.done, color: Colors.orange,),
                      iconAlignment: TextsIconAlignment.left,
                      space: 10,
                      isExpandText: true,
                    ),
                    5.hGap,
                    const TextWithIcon(
                      text: "Cancel your subscription at any time",
                      icon: Icon(Icons.done, color: Colors.orange,),
                      iconAlignment: TextsIconAlignment.left,
                      space: 10,
                      isExpandText: true,
                    ),
                  ],
                ),
              ),

              MaterialButton(
                onPressed: (){},
                height: 50,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Row(
                  children: [
                    20.wGap,
                    const Text('SUBSCRIBE'),
                    const Spacer(),
                    (read.contentPlanModel!.price_type == 'free') ?
                    const Text('FREE') :
                    (read.contentPlanModel?.price != null) ?
                    Text('\$${read.contentPlanModel?.price} per ${read.contentPlanModel?.price_type}') :
                    const Text('FREE'),
                    20.wGap,
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'This subscribtion renews at 19.99.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: const Text('Renewal info'),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
