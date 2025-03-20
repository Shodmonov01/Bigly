import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/post_item.dart';

import '../../../../../constants/app_images.dart';
import '../../../../../constants/constants.dart';
import '../../../posts/data/models/post_model.dart';
import '../../../posts/presentation/widgets/music_wave.dart';
import '../../../posts/presentation/widgets/video_image.dart';

class MessageItem extends StatelessWidget {
  final ContentModel contentModel;
  final int index;
  const MessageItem({super.key, required this.contentModel, required this.index});

  @override
  Widget build(BuildContext context) {

    final read = context.read<ChooseContentToViewModel>();
    final watch = context.watch<ChooseContentToViewModel>();

    return GestureDetector(
      onLongPress: () {
        print('asdasd');
        read.changeCheckedMessage(index);
      },
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ContentViewPage(contentModel: contentModel!,)));
        read.openContainer(
          // VideoPlayer(),
          // Image.asset(AppImages.avatar,fit: BoxFit.cover,height: double.infinity,width: double.infinity,),
          context,
          contentModel,
          index,
        );
        // read.openContainer(
        //     contentModel.media_type!.isVideo || contentModel.media_type!.isImage?
        //     Image.asset(AppImages.postImage,fit: BoxFit.cover,height: double.infinity,width: double.infinity,):
        //     contentModel.media_type!.isAudio?
        //     Stack(
        //       children: [
        //         SizedBox(
        //           height: double.infinity,
        //           width: double.infinity,
        //           child: ColoredBox(color: Colors.grey.withOpacity(.6),),
        //         ),
        //         Center(child: MusicWave(),)
        //       ],
        //     ) : Center(child: Text(contentModel.text ?? ''),),
        //     context,
        //     contentModel,
        //     index
        // );
      },
      child: SizedBox(
        child: Stack(
          children: [
            contentModel.media_type!.isAudio || contentModel.media_type!.isMessage?
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ColoredBox(color: Colors.grey.withOpacity(.6),),
            ):
            (contentModel.media_type!.isImage) ?
              Image(
                image: CachedNetworkImageProvider(contentModel.media ?? ''),
                fit: BoxFit.cover,height: double.infinity,width: double.infinity,
              ) : const SizedBox(),
            // Image.asset(AppImages.postImage,fit: BoxFit.cover,height: double.infinity,width: double.infinity,) ,

            /// Icons
            Positioned(
              top: 5,
              left: 5,
              right: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: opacitiyWhite,
                    child: contentModel.media_type!.isAudio?
                    const Icon(Iconsax.microphone_2_outline,color: Colors.black45,size: 27,):
                    contentModel.media_type!.isMessage?
                    const Icon(Icons.message_outlined,color: Colors.black45,size: 27,):
                    contentModel.media_type!.isImage?
                    const Icon(Icons.image_outlined,color: Colors.black45,size: 27,):
                    const Icon(Iconsax.instagram_outline,color: Colors.black45,size: 27,)
                  ),
                  watch.messageCheckedList[index] ?
                  DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                    child: Padding(
                        padding: const EdgeInsets.all(.8),
                        child: Icon(Icons.check_circle,color: Theme.of(context).colorScheme.primary,size: 19,)
                    ),
                  ) :
                  const SizedBox.shrink()
                ],
              ),
            ),
            contentModel.media_type!.isAudio?
            const Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: MusicWave(),
              ),
            )
            :const SizedBox.shrink(),
            contentModel.media_type!.isMessage?
            const Center(
              child: Icon(CupertinoIcons.chat_bubble_text,size: 60,color: Colors.black45,),
            )
             :
            contentModel.media_type!.isVideo?
            VideoImageItem(
                videoModel: contentModel,
              // videoModel: contentModel.media ?? '',
              // aspectRatio: contentModel.media_aspect_ratio ?? 1,
            ) :
            const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
