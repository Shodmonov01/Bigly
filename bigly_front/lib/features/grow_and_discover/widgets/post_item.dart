
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/grow_and_discover/grow/view_model/grow_view_model.dart';
import 'package:video_player/video_player.dart';
import '../../../core/widgets/post_caption.dart';
import '../../../core/widgets/report.dart';
import '../../../core/widgets/tag.dart';
import '../../../core/widgets/text_with_icon.dart';
import '../../../router/router.dart';
import '../../profile/presentation/pages/profile_enum.dart';
import '../../../core/widgets/profile_content_item.dart';
import '../../profile/view_model/profile_view_model.dart';
import 'post_profile.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, required this.profileEnum, this.video, required this.contentModel, required this.aspectRation,});

  final ProfileEnum profileEnum;
  final VideoPlayerController? video;
  final ContentModel contentModel;
  final double? aspectRation;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

  // Color _backgroundColor = Colors.white;

  // void _startColorExtractionTimer() {
  //   Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     _extractDominantColor();
  //   });
  // }

  // Future<void> _extractDominantColor() async {
  //   if (widget.video!.value.isInitialized) {
  //     final videoFrame = await widget.video!.getFrameAt(
  //         widget.video!.value.position.inMilliseconds);
  //     if (videoFrame != null) {
  //       final paletteGenerator = await PaletteGenerator.fromImageProvider(
  //         MemoryImage(videoFrame.image),
  //       );
  //       setState(() {
  //         _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final read = context.read<GrowViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// image
        if (widget.video != null)
        AspectRatio(
          aspectRatio:
          widget.aspectRation ??
              widget.video!.value.aspectRatio,
          // height: .7.hp(context),
          // height: context.width * widget.video!.value.aspectRatio,
          // color: Colors.grey.shade200,
          child: Stack(
            children: [
              if (widget.video != null)
              Center(
                // height: .7.hp(context),
                // child: Container(color: Colors.blue,),
                child: AspectRatio(
                  aspectRatio: widget.video!.value.aspectRatio,
                  child: VideoPlayer(widget.video!),
                ),
              )
              else
                // const Center(child: Text('loading...'),),
                CachedNetworkImage(
                  imageUrl: widget.contentModel.thumbnail!,
                  fit: BoxFit.cover,
                ),
              //   const LoadingView(),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: PostProfile(
                      contentModel: widget.contentModel,
                    ),
                  ),
                  const Spacer(),
                  if (widget.contentModel.contentPlanModel != null)
                  ProfileContentItem(
                    onTap: () async {
                      print(widget.contentModel.user!.username!);
                      print(widget.contentModel.id!);
                      await context.read<ProfileViewModel>().getContentPlanAndUser(
                        widget.contentModel.user!.username!,
                        widget.contentModel.id!,
                      );
                      context.push(
                        RouteNames.profile,
                        extra: ProfileEnum.subscribe,
                        // extra: (widget.profileEnum.isDiscover) ?
                        // ProfileEnum.discover :
                        // ProfileEnum.subscribe,
                      );
                    },
                    image: widget.contentModel.contentPlanModel!.bannerUrl ?? '',
                  ),
                  10.hGap,
                ],
              ),
            ],
          ),
        ),

        /// Tags and moreButton
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.contentModel.tags!.map((e) {
                    return Tag(
                      onTap: (){},
                      text: e.name,
                    );
                  },).toList(),
                ),
                // child: Row(
                //   children: [
                //     Tag(
                //       onTap: (){},
                //       text: 'Self love',
                //     ),
                //     Tag(
                //       onTap: (){},
                //       text: 'Self love',
                //     ),
                //     Tag(
                //       onTap: (){},
                //       text: 'Self love',
                //     ),
                //     Tag(
                //       onTap: (){},
                //       text: 'Self love',
                //     ),
                //   ],
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: moreButton,
                child: const Icon(Icons.more_horiz),
              ),
            ),
          ],
        ),

        /// caption
        Padding(
          padding: const EdgeInsets.all(10),
          child: PostCaption(
            text: widget.contentModel.text ?? '',
            // text: '''You can meditate like a PRO, if you put in time and practice daily. If you exercise your energy regularly your inner peace improve dramatically.Today's lesson is for for all "A Star is Born" or Gaga fans. @sahararose is covering the iconic "Always''',
          ),
        ),
      ],
    );
  }

  bool isOpenPostMenu = false;
  void moreButton() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: shareButton,
                  child: Container(
                    height: 70,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextWithIcon(
                      text: 'Share',
                      icon: Icon(CupertinoIcons.share),
                      iconAlignment: TextsIconAlignment.top,
                    ),
                  ),
                ),
              ),
              10.wGap,
              Expanded(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 70,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextWithIcon(
                      text: 'Share',
                      icon: Icon(CupertinoIcons.bookmark),
                      iconAlignment: TextsIconAlignment.top,
                    ),
                  ),
                ),
              ),
              10.wGap,
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      barrierColor: Colors.transparent,
                      showDragHandle: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      builder: (context) => const Report(),
                    );
                  },
                  child: Container(
                    height: 70,
                    // width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextWithIcon(
                      text: 'Report',
                      textStyle: TextStyle(color: Colors.red),
                      icon: Icon(CupertinoIcons.exclamationmark_bubble, color: Colors.red,),
                      iconAlignment: TextsIconAlignment.top,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void shareButton() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              10.wGap,
              itemOfSocial(const Icon(CupertinoIcons.share), 'Share to...'),const Spacer(),
              itemOfSocial(const Icon(CupertinoIcons.link), 'Copy link'),const Spacer(),
              itemOfSocial(const Icon(Icons.camera_alt_outlined), 'Instagram'),const Spacer(),
              itemOfSocial(const Icon(CupertinoIcons.xmark), 'X'),const Spacer(),
              itemOfSocial(const Icon(Icons.tiktok), 'TikTok'),const Spacer(),
              itemOfSocial(const Icon(Icons.snapchat), 'Snapchat'),
              10.wGap,
            ],
          ),
        );
      },
    );
  }

  Widget itemOfSocial(Widget icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // height: 50,
          // width: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300
          ),
          child: icon,
        ),
        Text(text, style: const TextStyle(fontSize: 10),),
      ],
    );
  }
  
}
