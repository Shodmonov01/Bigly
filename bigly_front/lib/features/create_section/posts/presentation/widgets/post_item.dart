import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_icons.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/time_box.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/video_image.dart';
import 'package:social_media_app/features/create_section/posts/view_model/posts_view_model.dart';
import '../../../../../constants/constants.dart';

class PostItem extends StatefulWidget {
  final ContentModel contentModel;
  final int index;
  const PostItem({super.key, required this.contentModel, required this.index});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {

    final read = context.read<PostsViewModel>();

    return GestureDetector(
      onTap: () {
        // read.onTapVideoContent(widget.contentModel.media!);
        context.read<ChooseContentToViewModel>().openContainer(
          // VideoPlayer(),
          // Image.asset(AppImages.avatar,fit: BoxFit.cover,height: double.infinity,width: double.infinity,),
          context,
          widget.contentModel,
          widget.index,
        );
        setState(() {});
        // context.read<PostsViewModel>().changeChecked(widget.index);
      },
      child: Container(
        color: Colors.grey.shade400,
        child: Stack(
          children: [
            // !contentModel.media_type!.isAudio?
            // true?
            if (widget.contentModel.media_type == null)
              const SizedBox() else
            if (widget.contentModel.media_type!.isVideo)
            VideoImageItem(
              videoModel: widget.contentModel,
              // videoModel: widget.contentModel.media ?? '',
              // aspectRatio: widget.contentModel.media_aspect_ratio ?? 1,
            ),


            if (widget.contentModel.media_type!.isImage)
            Image(
              image: CachedNetworkImageProvider(widget.contentModel.media ?? ''),
              fit: BoxFit.cover,height: double.infinity,width: double.infinity,
            ),

            // SizedBox(
            //   height: double.infinity,
            //   width: double.infinity,
            //   child: ColoredBox(color: Colors.grey.withOpacity(.6),),
            // ),

            /// top icon
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
                    child: widget.contentModel.media_type!.isAudio ?
                    Image.asset(AppIcons.contentPlanVoiceMessageIcon) :
                    widget.contentModel.media_type!.isVideo ?
                    Image.asset(AppIcons.contentPlanVideoMessageIcon) :
                    widget.contentModel.media_type!.isMessage ?
                    Image.asset(AppIcons.contentPlanTextMessageIcon) :
                    Image.asset(AppIcons.contentPlanPhotoMessageIcon),
                  ),
                  widget.contentModel.isCheck?
                  DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(.8),
                      child: Icon(Icons.check_circle,color: Theme.of(context).colorScheme.primary,size: 19,)
                    ),
                  )
                  :const SizedBox.shrink()
                ],
              ),
            ),

            widget.contentModel.media_type!.isAudio?
            Center(
              // bottom: 10,
              // right: 5,
              // left: 5,
              child: Image.asset(AppIcons.contentPlanVoiceMessage),
            ) :

            widget.contentModel.media_type!.isMessage?
            Center(
              // bottom: 10,
              // right: 5,
              // left: 5,
              child: Image.asset(AppIcons.contentPlanTextMessage,),
            ) :
            const SizedBox.shrink(),

            /// date, time
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeBox(
                    title: 'Day',
                    radiusTop: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(CupertinoIcons.left_chevron,size: 15,)
                            ),
                          )
                        ),
                        const Text('1',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: Colors.black),),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {

                              },
                              child: const Icon(CupertinoIcons.right_chevron,size: 15,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  5.hGap,
                  TimeBox(
                    title: 'Time',
                    radiusTop: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('21:02',style: MyTheme.largeBlackText,),
                        Text(widget.contentModel.media_type!.isAudio?'PM':'AM',style: MyTheme.smallBlackText,),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}