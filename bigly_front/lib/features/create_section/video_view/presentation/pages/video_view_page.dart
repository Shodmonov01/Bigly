
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/core/widgets/confirm_dialog.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';
import 'package:social_media_app/core/widgets/media_confirm_dialog.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/pages/new_insight.dart';
import 'package:social_media_app/features/create_section/video_edit/view_model/video_edit_view_model.dart';
import 'package:social_media_app/features/create_section/video_view/view_model/video_view_view_model.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../router/router.dart';
import '../../../video_edit/presentation/pages/video_edit_page.dart';
import '../widgets/cup.dart';
import '../widgets/tapioca_ball.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({super.key, required this.file});

  final File file;

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {

  late VideoPlayerController controller;

  @override
  void initState() {
    initVideo(widget.file);
    super.initState();
  }

  // File? videoFile;
  void initVideo(file) async {
    context.read<VideoViewViewModel>().videoFile1 = file;
    controller = VideoPlayerController.file(context.read<VideoViewViewModel>().videoFile1!);
    await controller.setLooping(true);
    await controller.initialize();
    await controller.play();
    setState(() {});

  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void addTextToVideo() async {
    final tapiocaBalls = [
      // TapiocaBall.filter(Filters.pink),
      // TapiocaBall.imageOverlay(imageBitmap, 300, 300),
      TapiocaBall.textOverlay("text",100,10,50, const Color(0xffffc0cb)),
    ];
    var tempDir = await getApplicationDocumentsDirectory();
    final path = '${tempDir.path}/result.mp4';
    final cup = Cup(Content(widget.file.path), tapiocaBalls);
    cup.suckUp(path).then((_) {
      print("finish processing");
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    final read = context.read<VideoViewViewModel>();
    final watch = context.watch<VideoViewViewModel>();

    return PopScope(
      onPopInvoked: (didPop) {
        showDialog(
          context: context,
          builder: (context) {
            return MediaConfirmDialog(
              title: 'Discard media',
              content: "If you discard now, you will lose any changes you've made",
              buttons: [
                ButtonCircular(
                  onPressed: () {
                    controller.dispose();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: 'Discard',
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey.shade300,
                ),
                ButtonCircular(
                  onPressed: (){},
                  text: 'Save draft',
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey.shade300,
                ),
                ButtonCircular(
                  onPressed: () => Navigator.pop(context),
                  text: 'Keep editing',
                  textStyle: const TextStyle(color: Colors.black),
                  backgroundColor: Colors.grey.shade300,
                ),

              ],
            );
          },
        );
      },
      canPop: false,
      child: Consumer<VideoViewViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                /// Video player
                Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! > 0) {
                              viewModel.onChangeColorFilter(isLeft: false);
                            }
                            if (details.primaryVelocity! < 0) {
                              viewModel.onChangeColorFilter(isLeft: true);
                            }
                          },
                          child: ColorFiltered(
                            colorFilter: (viewModel.currentColorFilterIndex == 0) ?
                            const ColorFilter.mode(Colors.transparent, BlendMode.saturation) :
                            ColorFilter.matrix(viewModel.colorFilters[viewModel.currentColorFilterIndex]),
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          ButtonCircular(
                            onPressed: () {
                              controller.pause().then((value) async {
                                File? file = await context.push(
                                  RouteNames.videoEdit,
                                  extra: (widget.file, controller.value.aspectRatio),
                                );
                                if (file != null) {
                                  read.videoFile1 = file;
                                  setState(() {});
                                  initVideo(read.videoFile1);
                                }
                                controller.play();
                              });
                            },
                            text: 'Edit Video',
                          ),
                          const Spacer(),
                          ButtonCircular(
                            onPressed: () async {
                              read.onTapNext(context, controller);
                              // await controller.pause();
                              // context.push(
                              //   RouteNames.newInsight,
                              //   extra: (NewInsightEnum.editContent, videoFile),
                              // );
                            },
                            text: 'Next',
                            icon: const Icon(Icons.play_arrow_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButtonWithBackground(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return MediaConfirmDialog(
                              title: 'Discard media',
                              content: "If you discard now, you will lose any changes you've made",
                              buttons: [
                                ButtonCircular(
                                  onPressed: () {
                                    controller.dispose();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  text: 'Discard',
                                  textStyle: const TextStyle(color: Colors.black),
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                ButtonCircular(
                                  onPressed: () {
                                    viewModel.downloadDraw(read.videoFile1!);
                                    context.pop();
                                    context.pop();

                                  },
                                  text: 'Save draft',
                                  textStyle: const TextStyle(color: Colors.black),
                                  backgroundColor: Colors.grey.shade300,
                                ),
                                ButtonCircular(
                                  onPressed: () => Navigator.pop(context),
                                  text: 'Keep editing',
                                  textStyle: const TextStyle(color: Colors.black),
                                  backgroundColor: Colors.grey.shade300,
                                ),

                              ],
                            );
                          },
                        );
                      },
                      height: 40,
                      width: 40,
                      icon: const Icon(Icons.close, color: Colors.white,),
                      color: Colors.black.withOpacity(.7),
                    ),
                    const Spacer(),
                    IconButtonWithBackground(
                      onTap: () {
                        addTextToVideo();
                      },
                      height: 40,
                      width: 40,
                      icon: const Icon(CupertinoIcons.textformat, color: Colors.white,),
                      color: Colors.black.withOpacity(.7),
                    ),
                    5.wGap,
                    IconButtonWithBackground(
                      onTap: () async {
                        final readVideoEdit = context.read<VideoEditViewModel>();
                        print(read.videoFile1?.path);
                        viewModel.downloadMedia(read.videoFile1!);
                        // read.downloadCacheFile(videoFile: videoFile!);
                      },
                      height: 40,
                      width: 40,
                      icon: const Icon(Icons.download, color: Colors.white,),
                      color: Colors.black.withOpacity(.7),
                    ),
                  ],
                ).padding(const EdgeInsets.all(5)),
              ],
            ),
          ),
        ),
      ),
    ).loadingView(watch.isLoading);
  }
}
