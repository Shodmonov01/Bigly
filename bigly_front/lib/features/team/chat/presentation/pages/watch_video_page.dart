/*
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../data/models/chat_video_model.dart';
import '../view_model/chat_view_model.dart';

class WatchVideoPage extends StatefulWidget {
  final ChatVideoModel chatVideoModel;
  const WatchVideoPage({super.key, required this.chatVideoModel});

  @override
  State<WatchVideoPage> createState() => _WatchVideoPageState();
}

class _WatchVideoPageState extends State<WatchVideoPage> {

  @override
  void initState() {
    context.read<ChatViewModel>().playVideo(widget.chatVideoModel.url!);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => context.read<ChatViewModel>().disposeVideo(),
      child: Container(
          color: Colors.black,
          child: Center(
            child: context.watch<ChatViewModel>().controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: context.watch<ChatViewModel>().controller.value.aspectRatio,
              child: Chewie(
                controller: context.watch<ChatViewModel>().chewieController,
              )//VideoPlayer(context.watch<ChatViewModel>().controller),
            )
                : Container(),
          )
      ),
    );
  }
}
*/

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';
import 'package:social_media_app/features/team/chat/view_model/chat_view_model.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/chat_video_model.dart';

class WatchVideoPage extends StatefulWidget {
  final String chatVideoModel;
  const WatchVideoPage({Key? key, required this.chatVideoModel}) : super(key: key);

  @override
  State<WatchVideoPage> createState() => _WatchVideoPageState();
}

class _WatchVideoPageState extends State<WatchVideoPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatViewModel>().playVideo(widget.chatVideoModel);
  }

  @override
  void deactivate() {
    context.watch<ChatViewModel>().controller!.pause();
    // context.watch<ChatViewModel>().chewieController!.pause();
    super.deactivate();
  }




  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        context.read<ChatViewModel>().disposeVideo();
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.topRight,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: context.watch<ChatViewModel>().controller!.value.isInitialized ?
              AspectRatio(
                aspectRatio: context.watch<ChatViewModel>().controller!.value.aspectRatio,
                // child: CachedVideoPlayerPlus(
                //     context.watch<ChatViewModel>().controller!
                // ),
                child: Chewie(
                  controller: context.watch<ChatViewModel>().chewieController!,
                ),
              ) :
              const CircularProgressIndicator(),
            ),

            SafeArea(
              child: IconButtonWithBackground(
                onTap: (){
                  context.read<ChatViewModel>().disposeVideo();
                  Navigator.pop(context);
                },
                height: 35,
                width: 35,
                icon: const Icon(Icons.close, color: Colors.white, size: 32,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
