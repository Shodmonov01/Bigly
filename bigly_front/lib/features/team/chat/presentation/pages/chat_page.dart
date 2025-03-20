
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/message_model.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';
import 'package:social_media_app/core/widgets/confirm_dialog.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';
import 'package:social_media_app/core/widgets/loading.dart';
import 'package:social_media_app/features/team/chat/presentation/widgets/chat_bubble.dart';
import 'package:social_media_app/features/team/chat/presentation/widgets/video_image_item.dart';
import 'package:social_media_app/features/team/chat/view_model/chat_view_model.dart';
import 'package:widget_zoom/widget_zoom.dart';


class ChatPage extends StatefulWidget {
  final  int id;
  const ChatPage({super.key, required this.id});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late ChatViewModel chatViewModel;
  // late AudioPlayer player;

  @override
  void initState() {
    context.read<ChatViewModel>().initRecorder();
    chatViewModel = context.read<ChatViewModel>();
    chatViewModel.getChat(context, widget.id);
    chatViewModel.initMessagePagination();
    super.initState();
  }

  @override
  void dispose() {
    chatViewModel.disposePage(context);
    super.dispose();
  }

  Duration maxDuration = Duration.zero;

  @override
  Widget build(BuildContext context) {

    final read = context.read<ChatViewModel>();
    final watch = context.watch<ChatViewModel>();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // read.getChat(context, widget.id);
        read.disposePage(context);
      },
      child: (watch.isLoading) ?
      const LoadingView():
      Scaffold(
        extendBody: true,
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.grey.shade100,
          leading: const SizedBox(),
          flexibleSpace: SafeArea(
            child: Row(
              children: [
                5.wGap,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7,),
                  child: Stack(
                    children: [
                      AvatarWithSize(
                        image: read.chatModel!.image ?? '',
                        radius: 25,
                      ),
                      Positioned(
                        left: -3,
                        top: -4,
                        child: Container(
                          height: 19,
                          width: 19,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border:Border.all(
                              color: Colors.grey,
                              width:.4,
                            ) ,
                          ),
                          child: const Icon(
                            CupertinoIcons.heart_slash_fill,
                            color: Colors.yellow,size: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(read.chatModel?.name ?? '', style: MyTheme.mediumBlackText,),
                    // Text('Your GYM Coach',style: MyTheme.smallGreyText,)
                  ],
                ),
              ],
            ),
          ),
          actions: [
            CircleAvatar(
              radius: 17,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(CupertinoIcons.pin_fill,size: 15,),
            ),
            IconButton(
              onPressed: () {
                // read.scrollController.jumpTo(read.scrollController.position.maxScrollExtent);
                // read.chatModel!.messageModels.add(
                //   read.messageModels!.first,
                // );

                // read.messageModels!.insert(0, read.messageModels!.last);
                // read.messageModels!.add(read.messageModels!.last);

                // setState(() {});
                context.pop(context);
              },
              icon: const Icon(Icons.close,),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: 1.hp(context),
              width: 1.wp(context),
              child: Image.asset(
                'assets/images/chat_backgound.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 1.hp(context),
              child: Column(
                children: [
                  Expanded(
                    child: PagedListView<int, MessageModel>(
                      reverse: true,
                      pagingController: chatViewModel.messagesPagingController,
                      builderDelegate: PagedChildBuilderDelegate<MessageModel>(
                        noItemsFoundIndicatorBuilder: (context) {
                          return const SizedBox.shrink();
                        },
                        itemBuilder: (context, item, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ChatBubble(
                              // isSender: read.chatModel!.messageModels[index].isMine,
                              isSender: item.isMine,
                              color: Colors.white,
                              padding: false,
                              child:
                              // (read.messageModels![index].mediaTypeModel == null) ?
                              (item.mediaTypeModel == null) ?
                              Padding(
                                padding: const EdgeInsets.all(5),
                                // child: Text(read.messageModels![index].content ?? ''),
                                child: Text(item.content ?? ''),
                              ) :

                              // (read.messageModels![index].mediaTypeModel!.isImage) ?
                              (item.mediaTypeModel!.isImage) ?
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: WidgetZoom(
                                    heroAnimationTag: '',
                                    zoomWidget: CachedNetworkImage(
                                      imageUrl: item.media ?? '',
                                      imageBuilder: (context, imageProvider) => Image(image: imageProvider),
                                      placeholder: (context, url) => AspectRatio(
                                        aspectRatio: item.media_aspect_ratio ?? 1,
                                        child: const Center(child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      cacheKey: item.media, // Optional
                                      maxHeightDiskCache: 1000, // Optional: Maximum size of disk cache in MB
                                      maxWidthDiskCache: 1000, // Optional: Maximum width of disk cache in pixels
                                    ),
                                  ),
                                ),
                              ) :
                              (item.mediaTypeModel!.isVideo) ?
                              // (read.messageModels![index].media_aspect_ratio != null) ?
                              VideoImageItem(messageModel: item, aspectRatio: item.media_aspect_ratio ?? 1) :
                              // VideoImageItem(videoModel: read.messageModels![index].media!,) :
                              // VideoImageItem(videoModel: read.messageModels![index].media!,):

                              (watch.audioPlayerControllers.length - 1 >= index) ?
                              // (true) ?
                              Container(
                                height: 70,
                                width: .7.wp(context),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    IconButtonWithBackground(
                                      onTap: () async {
                                        read.playAudio(index);
                                      },
                                      height: 40,
                                      width: 40,
                                      color: Colors.grey.shade200,
                                      icon: (watch.isAudioPlayersPlay[index]) ?
                                      const Icon(Icons.pause):
                                      const Icon(Icons.play_arrow),
                                    ),
                                    10.wGap,
                                    Expanded(
                                    child: (watch.audioPlayerControllers.length - 1 >= index) ?
                                    StreamBuilder(
                                      stream: watch.audioPlayerControllers[index].positionStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        } else {
                                          return ProgressBar(
                                            progress: watch.audioPlayerControllers[index].position,
                                            buffered: watch.audioPlayerControllers[index].bufferedPosition,
                                            total: watch.audioPlayerDurations[index],
                                            timeLabelLocation: TimeLabelLocation.none,
                                            thumbGlowRadius: 15,
                                            thumbRadius: 8,
                                            onSeek: (duration) {
                                              read.seekAudio(index, duration);
                                            },
                                          );
                                        }
                                      },
                                    ) :
                                    const Text('Initializing...'),
                                    ),
                                    10.wGap,
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: AvatarWithSize(
                                              height: 45,
                                              width: 45,
                                              image: read.chatModel!.image,
                                            ),
                                          ),
                                          const Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Icon(Icons.mic, color: Colors.orange,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ) : SizedBox(
                                height: 70,
                                width: .7.wp(context),
                                child: const Center(
                                  child: Text('Loading audio...'),
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                      // controller: read.scrollController,
                      // itemCount: read.messageModels!.length,
                      // physics: const ClampingScrollPhysics(),
                      // itemBuilder: (context, index) {
                      //   return
                      //   // return Text(read.chatModel!.messageModels[index].content ?? '');
                      // },
                    ),
                  ),

                  /// bottom
                  if (watch.isUploadingFile)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    color: Colors.white,
                    child: const Column(
                      children: [
                        Text('Uploading...'),
                        Center(child: LinearProgressIndicator()),
                      ],
                    ),
                  ),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: const Border(top: BorderSide(color: Colors.grey,width: .7)),
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        // height: 60,
                        width: 1.wp(context),
                        child: Row(
                          children: [
                            !watch.startRecord ?
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.unFocus;
                                      read.chooseFile();
                                    },
                                    icon: const Icon(CupertinoIcons.paperclip,color: Colors.grey,size: 27,),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(width: .3,color: Colors.grey),
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
                                      child: Center(
                                        child: TextField(
                                          focusNode: watch.focusNode,
                                          controller: read.messageController,
                                          onChanged: (value) {
                                            (value.isNotEmpty) ?
                                            read.isTyping = true :
                                            read.isTyping = false;
                                            setState(() {});
                                          },
                                          // onTapOutside: (event) {
                                          //   if (!read.isTyping) {
                                          //     context.unFocus;
                                          //   }
                                          // },
                                          maxLines: 7,
                                          minLines: 1,
                                          decoration: const InputDecoration(
                                              isDense: true,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'Message'
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) :
                            AudioWaveforms(
                              recorderController: read.audioRecordController,
                              size: Size(context.width - 50, 50),
                              waveStyle: const WaveStyle(
                                showMiddleLine: false,
                                extendWaveform: true
                              ),
                            ),
                            (watch.isTyping) ?
                            IconButton(
                              onPressed: (){
                                // FocusScope.of(context).requestFocus(read.focusNode);
                                read.sendMessage(context);
                              },
                              icon: const Icon(Icons.send),
                            ) :
                            GestureDetector(
                              onLongPress: () {
                                context.unFocus;
                                read.startRecord = true;
                                read.record();
                                context.vibrateLight;
                                setState(() {

                                });
                              },
                              onLongPressEnd: (details) {
                                context.vibrateLight;
                                read.startRecord = false;
                                read.stop();
                              },
                              child: const SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(Icons.mic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (context.isKeyboardOpen)
                  Container(
                    height: 40,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => context.unFocus,
                          child: const Text('Done'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
