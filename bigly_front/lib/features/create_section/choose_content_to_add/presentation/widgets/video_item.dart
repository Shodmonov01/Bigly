import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/pages/new_insight.dart';
import 'package:social_media_app/router/router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../constants/app_images.dart';
import '../../../../../core/data/models/content_model.dart';
import '../../../posts/presentation/widgets/video_image.dart';
import '../content_view_page.dart';

class VideoItem extends StatelessWidget {

  const VideoItem({super.key, this.isFirst=false, required this.index, this.contentModel});
  final bool isFirst;
  final int index;
  final ContentModel? contentModel;


  @override
  Widget build(BuildContext context) {

    final read = context.read<ChooseContentToViewModel>();
    final watch = context.watch<ChooseContentToViewModel>();

    return isFirst?
    GestureDetector(
      onTap: () {
        context.go(RouteNames.home);
        context.push(RouteNames.newInsight, extra: (NewInsightEnum.selectContent, null));
        context.push(RouteNames.videoRecord);

      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.6),
        ),
        child: const Center(
          child: Icon(CupertinoIcons.camera,size: 35,),
        ),
      ),
    ) :
    GestureDetector(
      onLongPress: () {
        read.changeCheckedVideo(index);
      },
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ContentViewPage(contentModel: contentModel!,)));
        read.openContainer(
          // VideoPlayer(),
          // Image.asset(AppImages.avatar,fit: BoxFit.cover,height: double.infinity,width: double.infinity,),
          context,
          contentModel!,
          index,
        );
      },
      child: Stack(
        children: [
          VideoImageItem(
            videoModel: contentModel!,
            // videoModel: contentModel?.media ?? '',
            // aspectRatio: contentModel?.media_aspect_ratio ?? 1,
          ),
          watch.contentCheckedList[index] ?
          Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.white,shape: BoxShape.circle),
              child: Padding(
                  padding: const EdgeInsets.all(.8),
                  child: Icon(Icons.check_circle,color: Theme.of(context).colorScheme.primary,size: 19,)
              ),
            ),
          ) :
          const SizedBox.shrink()
        ],
      ),
    );
  }
}
