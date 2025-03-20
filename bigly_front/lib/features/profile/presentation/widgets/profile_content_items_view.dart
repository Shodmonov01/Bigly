
import 'package:flutter/material.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';
import '../../../../constants/app_images.dart';
import '../../../../core/widgets/profile_content_item.dart';
import '../pages/profile_enum.dart';

// class ProfileContentItemsView extends StatelessWidget {
//   const ProfileContentItemsView({super.key, required this.profileEnum, this.onTap});
//
//   final void Function()? onTap;
//   final ProfileEnum profileEnum;
//
//   @override
//   Widget build(BuildContext context) {
//     return ProfileContentItem(
//       onTap: onTap,
//       // onTap: () => context.push(
//       //   RouteNames.profile,
//       //   extra: ProfileEnum.subscribe,
//       // ),
//       image: AppImages.profileAd,
//       actionButton: IconButtonWithBackground(
//         onTap: () {},
//         height: 30,
//         width: 30,
//         icon: (profileEnum.isMyProfile) ?
//         const Icon(Icons.camera_alt_outlined, size: 20,) :
//         const Icon(Icons.close, size: 20,) ,
//         color: Colors.grey.shade300,
//       ),
//     );
//   }
// }
