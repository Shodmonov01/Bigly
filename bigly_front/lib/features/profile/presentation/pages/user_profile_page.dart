//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media_app/constants/app_icons.dart';
// import 'package:social_media_app/core/data/data_source/local/app_local_data.dart';
// import 'package:social_media_app/core/extensions/widget_extension.dart';
// import 'package:social_media_app/features/home/view_model/home_view_model.dart';
// import 'package:social_media_app/features/profile/presentation/pages/profile_enum.dart';
// import 'package:social_media_app/features/profile/view_model/profile_view_model.dart';
//
// import '../../../../constants/app_images.dart';
// import '../../../../core/widgets/post_caption.dart';
// import '../../../../core/widgets/icon_with_backgeound.dart';
// import '../../../../core/widgets/profile_content_item.dart';
// import '../../../../router/router.dart';
// import '../widgets/profile_content_items_view.dart';
// import '../widgets/profile_subscribe_title.dart';
// import '../widgets/profile_subscribe_view.dart';
// import '../widgets/profile_top.dart';
//
// class MyProfilePage extends StatefulWidget {
//   const MyProfilePage({super.key, required this.username});
//
//   final String username;
//
//   @override
//   State<MyProfilePage> createState() => _MyProfilePageState();
// }
//
// class _MyProfilePageState extends State<MyProfilePage> {
//   @override
//   void initState() {
//     context.read<ProfileViewModel>().getUserWithUsername(widget.username);
//     super.initState();
//   }
//
//
//   // String profileDescription = "";
// //   String profileDescription = """
// // Hi, I'm Indica, and I'm thrilled to welcome you to my page 🥰
// // As a passionate singer and vocal tutor, I'm eager to share my expertise through three carefully crafted programs, designed with all my love and SOUl💘
// // Join me for daily singing lessons and choose the option that resonates best with you.
// // Let's dive into the world of music and have tons of fun together!💘💘
// //             """;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileViewModel>(
//         builder: (context, viewModel, _) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Discover',),
//             ),
//
//             body: RefreshIndicator.adaptive(
//
//               onRefresh: () async {
//                 HapticFeedback.heavyImpact();
//                 await viewModel.getUserWithUsername(widget.username);
//               },
//               child: ListView(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 children: [
//                   const ProfileTop(profileEnum: ProfileEnum.discover),
//
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         if (profileEnum.isMyProfile || profileEnum.isMyContentPlan)
//                           IconButtonWithBackground(
//                             onTap: (){
//                               context.read<ProfileViewModel>().onTapEditButton(context, profileEnum, 'Description', viewModel.bio ?? '');
//                             },
//                             height: 30,
//                             width: 30,
//                             color: Colors.grey.shade200,
//                             icon: const Icon(
//                               Icons.mode_edit_outline_outlined,
//                               size: 18,
//                               color: Colors.black,
//                             ),
//                           ),
//                         // if (profileEnum.isMyProfile)
//                         (viewModel.bio == null) ?
//                         const Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Profile description here...',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ) :
//                         (viewModel.bio!.isEmpty) ?
//                         const Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Profile description here...',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ) :
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: PostCaption(text: viewModel.bio!),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   if (profileEnum.isDiscover || profileEnum.isMyProfile)
//                     const Padding(
//                       padding: EdgeInsets.all(10),
//                       child: ProfileSubscribeTitle(
//                         text: 'Click on a program to learn and subscribe:',
//                       ),
//                     ),
//
//                   if (profileEnum.isDiscover || profileEnum.isMyProfile)
//                     Column(
//                       children: viewModel.contentPlanList.map((contentPlan) {
//                         return
//                           ProfileContentItem(
//                             onTap: () async {
//                               viewModel.onLoading(isLoading: true);
//                               await context.read<ProfileViewModel>().getContentPlanAndUser(viewModel.userModel!.username!, contentPlan.id!);
//                               viewModel.onLoading(isLoading: false);
//                               context.push(
//                                 RouteNames.profile,
//                                 extra: ProfileEnum.myContentPlan,
//                               );
//                             },
//                             image: contentPlan.bannerUrl ?? '',
//                             actionButton: IconButtonWithBackground(
//                               onTap: () {},
//                               height: 30,
//                               width: 30,
//                               icon: (profileEnum.isMyProfile) ?
//                               const Icon(Icons.camera_alt_outlined, size: 20,) :
//                               const Icon(Icons.close, size: 20,) ,
//                               color: Colors.grey.shade300,
//                             ),
//                           );
//                       },).toList(),
//                     ),
//
//                   if (profileEnum.isSubscribe || profileEnum.isMyContentPlan)
//                     const ProfileSubscribeView(),
//
//                   if (profileEnum.isMyProfile)
//                     IconButtonWithBackground(
//                       onTap: () {
//                         context.go(
//                           RouteNames.home,
//                         );
//                         context.read<HomeViewModel>().onTapNavBar(2);
//                       },
//                       label: 'Create content',
//                       height: 80,
//                       width: 80,
//                       icon: Image.asset(AppIcons.createUnselect),
//                       color: Colors.grey[300],
//                     ),
//                   if (profileEnum.isMyContentPlan)
//                     IconButtonWithBackground(
//                       onTap: () {
//                         context.go(
//                           RouteNames.home,
//                         );
//                         context.read<HomeViewModel>().onTapNavBar(2);
//                       },
//                       label: 'Manage content plan',
//                       height: 80,
//                       width: 80,
//                       icon: const Icon(Icons.apps),
//                       color: Colors.grey[300],
//                     ),
//                 ],
//               ),
//             ),
//           ).loadingView(viewModel.isLoading);
//         }
//     );
//   }
// }
