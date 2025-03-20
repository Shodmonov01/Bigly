//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:social_media_app/features/profile/presentation/widgets/my_content_plan_top.dart';
// import 'package:social_media_app/features/profile/presentation/widgets/profile_subscribe_view.dart';
//
// import '../../../../core/widgets/post_caption.dart';
// import '../../../../core/widgets/icon_with_backgeound.dart';
// import '../../../../router/router.dart';
// import '../../view_model/profile_view_model.dart';
//
// class MyContentPlanPage extends StatefulWidget {
//   const MyContentPlanPage({super.key});
//
//   @override
//   State<MyContentPlanPage> createState() => _MyContentPlanPageState();
// }
//
// class _MyContentPlanPageState extends State<MyContentPlanPage> {
//
//   String profileDescription =
// """
// Hi and welcome to my page
// I'll be sharing with you my siging lessons every day, so you can lear how to sing your fav songs the easy way. All you need is enjoy and practice with me regularly.
// Let's have some fun!
// """;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'My content plan page',
//         ),
//       ),
//
//       body: ListView(
//         children: [
//           const MyContentPlanTop(),
//
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 IconButtonWithBackground(
//                   onTap: (){
//                     context.read<ProfileViewModel>().onTapEditButton(context, 'Description', '');
//                   },
//                   height: 30,
//                   width: 30,
//                   color: Colors.grey.shade200,
//                   icon: const Icon(
//                     Icons.mode_edit_outline_outlined,
//                     size: 18,
//                     color: Colors.black,
//                   ),
//                 ),
//                 if (profileDescription.isEmpty)
//                   const Text(
//                     'Profile description here...',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 PostCaption(text: profileDescription),
//               ],
//             ),
//           ),
//
//           const ProfileSubscribeView(),
//
//           IconButtonWithBackground(
//             onTap: () {
//               context.push(RouteNames.posts);
//             },
//             label: 'Manage content plan',
//             height: 80,
//             width: 80,
//             icon: const Icon(Icons.apps),
//             color: Colors.grey[300],
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
//
