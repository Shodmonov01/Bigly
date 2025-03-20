
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/widgets/avatar_with_size.dart';
import '../../view_model/profile_view_model.dart';
import '../pages/profile_enum.dart';

class ProfileTop extends StatelessWidget {
  const ProfileTop({super.key, required this.profileEnum});

  final ProfileEnum profileEnum;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            /// Banner image
            Container(
              height: .35.wp(context),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                image: (viewModel.coverImage == null) ?
                null :
                DecorationImage(
                  // image: AssetImage(AppImages.profileBanner),
                  image: CachedNetworkImageProvider(viewModel.coverImage!),
                  fit: BoxFit.cover,
                ),
              ),
              child: (profileEnum.isMyProfile) ?
              Align(
                alignment: Alignment.topRight,
                child: IconButtonWithBackground(
                  onTap: (){
                    viewModel.editCoverImage();
                  },
                  height: 40,
                  width: 40,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                )
              ) : const SizedBox.shrink(),
            ),

            /// Avatar, like, share
            Padding(
              padding: EdgeInsets.only(top: .25.wp(context), right: 10),
              // padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// avatar
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: .25.wp(context),
                              width: .25.wp(context),
                              child: Stack(
                                children: [
                                  AvatarWithSize(
                                    height: .25.wp(context),
                                    width: .25.wp(context),
                                    image: viewModel.profileImage ?? '',
                                    borderColor: Colors.white,
                                    borderWidth: 3,
                                  ),
                                  if (profileEnum.isMyProfile)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButtonWithBackground(
                                        onTap: (){
                                          viewModel.editProfileImage();
                                        },
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                        icon: const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            10.hGap,

                          ],
                        ),
                      ),

                      /// profile, subscribers, followers
                      const Spacer(),
                      if (profileEnum.isMyProfile)
                        Column(
                          children: [
                            15.hGap,
                            Text('${viewModel.followings}'),
                            const Text('all subscribers'),
                          ],
                        ),
                      const Spacer(),
                      if (profileEnum.isMyProfile)
                        Column(
                          children: [
                            15.hGap,
                            Text('${viewModel.followers}'),
                            const Text('followers'),
                          ],
                        ),
                      const Spacer(),

                      /// subscribers, plan length
                      const Spacer(),
                      if (profileEnum.isMyContentPlan)
                        Column(
                          children: [
                            15.hGap,
                            Text('${viewModel.planSubscribers}'),
                            const Text('plan subscribers'),
                          ],
                        ),
                      const Spacer(),
                      if (profileEnum.isMyContentPlan)
                        Column(
                          children: [
                            15.hGap,
                            Text('${viewModel.planLength}'),
                            const Text('plan length'),
                          ],
                        ),
                      const Spacer(),



                      if (profileEnum.isDiscover || profileEnum.isSubscribe)
                        const IconButtonWithBackground(
                          height: 40,
                          width: 40,
                          icon: Icon(Icons.star_border, color: Colors.orange,),
                          color: Colors.white,
                          borderColor: Colors.grey,
                        ).padding(const EdgeInsets.only(top: 15)),
                      10.wGap,
                      const IconButtonWithBackground(
                        height: 40,
                        width: 40,
                        icon: Icon(CupertinoIcons.share, color: Colors.orange,),
                        color: Colors.white,
                        borderColor: Colors.grey,
                      ).padding(const EdgeInsets.only(top: 15)),
                    ],
                  ),
                  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            (profileEnum.isMyProfile || profileEnum.isDiscover) ?
                            viewModel.name ?? '' :
                            viewModel.contentPlanModel!.name ?? '',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5
                            ),
                          ),
                          5.wGap,
                          if (profileEnum.isMyProfile || profileEnum.isMyContentPlan)
                            IconButtonWithBackground(
                              onTap: (){
                                context.read<ProfileViewModel>().onTapEditButton(context, profileEnum, 'Name', viewModel.name ?? '');
                              },
                              height: 30,
                              width: 30,
                              color: Colors.grey.shade200,
                              icon: const Icon(
                                Icons.mode_edit_outline_outlined,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          if (profileEnum.isMyContentPlan)
                          const Text('by '),
                          Text(
                            viewModel.username ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).padding(const EdgeInsets.all(10)),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
