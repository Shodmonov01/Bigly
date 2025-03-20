//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media_app/core/extensions/num_extension.dart';
// import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';
//
// import '../../../../constants/app_images.dart';
// import '../../../../core/widgets/avatar_with_size.dart';
// import '../../view_model/profile_view_model.dart';
//
// class MyContentPlanTop extends StatelessWidget {
//   const MyContentPlanTop({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         /// Banner image
//         Container(
//           height: .35.wp(context),
//           width: double.infinity,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(AppImages.profileBanner),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Align(
//               alignment: Alignment.topRight,
//               child: IconButtonWithBackground(
//                 onTap: (){},
//                 height: 40,
//                 width: 40,
//                 color: Colors.white,
//                 icon: const Icon(
//                   Icons.camera_alt_outlined,
//                   size: 20,
//                   color: Colors.grey,
//                 ),
//               )
//           ),
//         ),
//
//         /// Avatar, like, share
//         Padding(
//           padding: EdgeInsets.only(top: .25.wp(context), right: 10),
//           child: Row(
//             children: [
//
//               Padding(
//                 // padding: EdgeInsets.only(left: 10, top: .25.wp(context),),
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: .25.wp(context),
//                       width: .25.wp(context),
//                       child: AvatarWithSize(
//                         height: .25.wp(context),
//                         width: .25.wp(context),
//                         image: AppImages.avatar,
//                         borderColor: Colors.white,
//                         borderWidth: 3,
//                       ),
//                     ),
//                     10.hGap,
//                     Row(
//                       children: [
//                         const Text(
//                           'Indica Jones',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: .5
//                           ),
//                         ),
//                         5.wGap,
//                         IconButtonWithBackground(
//                           onTap: (){
//                             context.read<ProfileViewModel>().onTapEditButton(context,  'Name', '');
//                           },
//                           height: 30,
//                           width: 30,
//                           color: Colors.grey.shade200,
//                           icon: const Icon(
//                             Icons.mode_edit_outline_outlined,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Text(
//                       '@indicasings',
//                       style: TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               const Column(
//                 children: [
//                   Text('934'),
//                   Text('all subscribers'),
//                 ],
//               ),
//               const Spacer(),
//               const Column(
//                 children: [
//                   Text('14.2K'),
//                   Text('followers'),
//                 ],
//               ),
//               const Spacer(),
//
//               const IconButtonWithBackground(
//                 height: 40,
//                 width: 40,
//                 icon: Icon(CupertinoIcons.share, color: Colors.orange,),
//                 color: Colors.white,
//                 borderColor: Colors.grey,
//               ),
//             ],
//           ),
//         ),
//
//       ],
//     );
//   }
// }
