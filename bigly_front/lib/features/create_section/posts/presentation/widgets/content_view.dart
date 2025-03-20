
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/create_section/posts/view_model/posts_view_model.dart';
import 'package:video_player/video_player.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {

  // VideoPlayerController get videoPlayerController => widget.videoPlayerController;

  @override
  void initState() {
    // videoPlayerController.play();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<PostsViewModel>();
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.5),
      body: GestureDetector(
        onTap: (){
          // read.onTapVideoContent(read.videoFileUrl);
          setState(() {});
        },
        child: SizedBox(
          height: .8.hp(context),
          width: .8.wp(context),
          // child: VideoPlayer(
          //   read.videoPlayerController!,
          // ),
        ),
      ),
    );
  }
}
