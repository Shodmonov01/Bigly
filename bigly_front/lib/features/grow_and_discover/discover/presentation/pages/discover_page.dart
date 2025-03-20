
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../constants/app_images.dart';
import '../../../../../core/data/data_source/remote/app_remote_data.dart';
import '../../../../../core/data/models/content_model.dart';
import '../../../../../core/theme/my_theme.dart';
import '../../../../../core/widgets/avatar_with_size.dart';
import '../../../../../core/widgets/drawer_navigation_button.dart';
import '../../../../../router/router.dart';
import '../../../../home/view_model/home_view_model.dart';
import '../../../../profile/presentation/pages/profile_enum.dart';
import '../../../../profile/view_model/profile_view_model.dart';
import '../../../grow/view_model/grow_view_model.dart';
import '../../../widgets/post_item.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

  @override
  void initState() {
    context.read<GrowViewModel>().initDiscoverPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GrowViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  context.read<HomeViewModel>().onOpenDrawer();
                },
                icon: const Icon(Icons.settings),
              ),

              title: GestureDetector(
                onTap: () {
                  viewModel.stopAllVideos();
                },
                child: const Text(
                  'Discover',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              centerTitle: true,

              actions: [
                AvatarWithSize(
                  onTap: (){
                    context.push(
                      RouteNames.profile,
                      extra: ProfileEnum.myProfile,
                    );
                  },
                  image:
                  (AppRemoteData.userModel != null) ?
                  AppRemoteData.userModel!.profilePictureUrl : '',
                  height: 35,
                  width: 35,
                ),
                10.wGap,
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                viewModel.stopAllVideos();
                viewModel.discoverPagingController.refresh();
              },
              child: PagedListView(
                pagingController: viewModel.discoverPagingController,
                builderDelegate:  PagedChildBuilderDelegate<ContentModel> (
                  itemBuilder: (context, item, index) {
                    ContentModel contentModel = item;
                    // viewModel.contents[index];
                    return VisibilityDetector(
                      key: Key(index.toString()),
                      onVisibilityChanged: (visibilityInfo) async {
                        if (visibilityInfo.visibleFraction > 0.7) {
                          // Play video and pause others
                          viewModel.playVideoDiscover(index, contentModel.media!);
                        } else if (visibilityInfo.visibleFraction < 0.3) {
                          // Pause video
                          viewModel.stopVideoDiscover(index);
                        }
                      },
                      // child: Text(item.id.toString()),
                      child: PostItem(
                        profileEnum: ProfileEnum.discover,
                        contentModel: contentModel,
                        // text: contentModel.text ?? '',
                        // video: contentModel.banner!,
                        video: viewModel.videoControllersDiscover[index],
                        // video: VideoPlayerController.asset('dataSource'),
                        aspectRation: contentModel.media_aspect_ratio,
                        // banner: 'assets/images/post1.jpg',
                      ),
                    );
                  },
                ),
                // builderDelegate: PagedChildBuilderDelegate<ContentModel> (
                //   itemBuilder: (BuildContext context, ContentModel item, int index) {
                //     ContentModel contentModel = item;
                //     return VisibilityDetector(
                //       key: Key(index.toString()),
                //       onVisibilityChanged: (visibilityInfo) async {
                //         if (visibilityInfo.visibleFraction > 0.7) {
                //           viewModel.playVideoDiscover(index, contentModel.media!);
                //         } else if (visibilityInfo.visibleFraction < 0.3) {
                //           viewModel.stopVideoDiscover(index);
                //         }
                //       },
                //       child: PostItem(
                //         profileEnum: ProfileEnum.discover,
                //         contentModel: contentModel,
                //         // text: contentModel.text ?? '',
                //         // video: contentModel.banner!,
                //         video: viewModel.videoControllersDiscover[index],
                //         // banner: 'assets/images/post1.jpg',
                //         aspectRation: contentModel.media_aspect_ratio,
                //       ),
                //     );
                //   },
                // ),

                // itemBuilder: (context, index) {
                //   ContentModel contentModel = viewModel.contentsDiscover[index];
                //   return
                //     // ((contentModel.contentPlanModel == null) ||
                //     //   (contentModel.media == null)) ? const SizedBox.shrink() :
                //
                // },
              ),
            ),
          );
        }
    );
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: (){},
//           icon: const Icon(Icons.settings),
//         ),
//
//         title: const Text(
//           'Discovery',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//
//         actions: [
//           AvatarWithSize(
//             onTap: (){
//               context.push(
//                 RouteNames.profile,
//                 extra: ProfileEnum.myProfile,
//               );
//             },
//             image: context.read<ProfileViewModel>().userModel?.profilePictureUrl,
//             height: 35,
//             width: 35,
//           ),
//           10.wGap,
//         ],
//       ),
//
//       body: ListView(
//         children: const [
// //           PostItem(
// //             profileEnum: ProfileEnum.discover,
// //             text: '''
// // Finding solace in the stillness of the water. 🌊✨ #peaceandquiet #naturetherapy
// //             ''',
// //             image: 'assets/images/post2.jpg',
// //             banner: 'assets/images/post3.jpg',
// //           ),
//           // PostItem(profileEnum: ProfileEnum.subscribe,),
//           // PostItem(profileEnum: ProfileEnum.subscribe,),
//         ],
//       ),
//     );
  }
}
