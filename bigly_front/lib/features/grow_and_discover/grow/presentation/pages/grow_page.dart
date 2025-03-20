
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/drawer_navigation_button.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/view_model/add_to_view_model.dart';
import 'package:social_media_app/features/grow_and_discover/grow/view_model/grow_view_model.dart';
import 'package:social_media_app/features/home/view_model/home_view_model.dart';
import 'package:social_media_app/router/router.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../constants/app_images.dart';
import '../../../../../core/data/models/content_model.dart';
import '../../../../../core/widgets/avatar_with_size.dart';
import '../../../../../di_service.dart';
import '../../../../create_section/add_to/data/repo/content_plan_repo.dart';
import '../../../../profile/presentation/pages/profile_enum.dart';
import '../../../../profile/view_model/profile_view_model.dart';
import '../../../widgets/post_item.dart';

class GrowPage extends StatefulWidget {
  const GrowPage({super.key});

  @override
  State<GrowPage> createState() => _GrowPageState();
}

class _GrowPageState extends State<GrowPage> {
  @override
  void initState() {
    context.read<GrowViewModel>().initGrowPagination();
    // context.read<GrowViewModel>().getPosts(1, 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // final read = context.read<GrowViewModel>();

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
                'Grow',
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
                // image: context.watch<ProfileViewModel>().userModel?.profilePictureUrl,
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
              // await viewModel.getPosts(0, 3);
              viewModel.growPagingController.refresh();
            },
            // PagedListView<int, NotificationModel>(
            //   pagingController: viewModel.pagingController,
            //   builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
            //     itemBuilder: (context, item, index) => const ItemOfNotification(),
            //   ),
            // ),
            child: PagedListView<int, ContentModel>(
              pagingController: viewModel.growPagingController,
              builderDelegate:  PagedChildBuilderDelegate<ContentModel> (
                itemBuilder: (context, item, index) {
                  ContentModel contentModel = item;
                  // viewModel.contents[index];
                  return VisibilityDetector(
                    key: Key(index.toString()),
                    onVisibilityChanged: (visibilityInfo) async {
                      if (visibilityInfo.visibleFraction > 0.7) {
                        // Play video and pause others
                        viewModel.playVideoGrow(index, contentModel.media!);
                      } else if (visibilityInfo.visibleFraction < 0.3) {
                        // Pause video
                        viewModel.stopVideoGrow(index);
                      }
                    },
                    // child: Text(item.id.toString()),
                    child: PostItem(
                      profileEnum: ProfileEnum.discover,
                      contentModel: contentModel,
                      // text: contentModel.text ?? '',
                      // video: contentModel.banner!,
                      video: viewModel.videoControllersGrow[index],
                      // video: VideoPlayerController.asset('dataSource'),
                      aspectRation: contentModel.media_aspect_ratio,
                      // banner: 'assets/images/post1.jpg',
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    );
  }
}
