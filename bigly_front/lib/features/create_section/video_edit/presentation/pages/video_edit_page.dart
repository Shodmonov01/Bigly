
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_paths.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/features/create_section/video_edit/view_model/video_edit_view_model.dart';
import 'dart:io';

import 'package:video_editor/video_editor.dart';


import 'export_service.dart';

class VideoEditPage extends StatefulWidget {
  const VideoEditPage({super.key, required this.file, required this.aspectRatio});

  final File file;
  final double aspectRatio;

  @override
  State<VideoEditPage> createState() => _VideoEditPageState();
}

class _VideoEditPageState extends State<VideoEditPage> {

  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(hours: 24),
    trimStyle: TrimSliderStyle(
      edgesType: TrimSliderEdgesType.circle,
    )
  );

  @override
  void initState() {
    super.initState();
    _controller
        // .initialize(aspectRatio: 9 / 16)
        // .initialize(aspectRatio: _controller.video.value.aspectRatio)
        .initialize(aspectRatio: widget.aspectRatio)
        .then((_) => setState(() {}))
        .catchError((error) {
      Navigator.pop(context);
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  void dispose() async {
    // exportingProgress.dispose();
    // _isExporting.dispose();
    _controller.dispose();
    ExportService.dispose();
    super.dispose();
  }

  // File? editedVideoFile;

  File? audioFile;
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  void chooseAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      Uri uri = Uri(path: file.path);
      audioFile = File.fromUri(uri);
      if (audioFile == null) return;
      await _trimmer.loadAudio(audioFile: audioFile!);
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<VideoEditViewModel>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // _topNavBar(),

                  Expanded(
                    child: Column(
                      children: [

                        /// VIDEO
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.reply),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      (_controller.isPlaying) ?
                                      _controller.video.pause() :
                                      _controller.video.play() ;
                                      setState(() {});
                                    },
                                    icon: (_controller.isPlaying) ?
                                    const Icon(Icons.pause) :
                                    const Icon(Icons.play_arrow),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    10.hGap,
                                    Expanded(
                                      child: Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: AspectRatio(
                                            aspectRatio: _controller.video.value.aspectRatio,
                                            child: CropGridViewer.preview(
                                              controller: _controller,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedBuilder(
                                      animation: Listenable.merge([
                                        _controller,
                                        _controller.video,
                                      ]),
                                      builder: (_, __) {
                                        return Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(formatter(_controller.startTrim), style: const TextStyle(color: Colors.white),),
                                          const Text(' / ', style: TextStyle(color: Colors.white),),
                                          Text(formatter(_controller.endTrim), style: const TextStyle(color: Colors.grey),),
                                        ]).padding(const EdgeInsets.symmetric(horizontal: 60 / 4),);
                                      },
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// CUT VIDEO
                        Container(
                          height: 200,
                          color: Colors.black,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              _trimVideoSlider(),
                              (audioFile == null) ?
                              GestureDetector(
                                onTap: () {
                                  chooseAudio();
                                },
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(left: 15, right: 15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff1f1f1f),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      10.wGap,
                                      const Icon(Icons.music_note, color: Colors.grey,),
                                      const Text('Tap to add video', style: TextStyle(color: Colors.grey),)
                                    ],
                                  ),
                                ),
                              ) :
                              TrimViewer(
                                trimmer: _trimmer,

                                viewerWidth: MediaQuery.of(context).size.width,

                                durationStyle: DurationStyle.FORMAT_MM_SS,
                                backgroundColor: Colors.black12,
                                barColor: Colors.white,
                                durationTextStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                allowAudioSelection: true,
                                editorProperties: const TrimEditorProperties(
                                  borderPaintColor: Colors.orange,
                                  circlePaintColor: Colors.orange,
                                  borderWidth: 2,
                                  borderRadius: 5,
                                ),
                                showDuration: true,
                                areaProperties:
                                TrimAreaProperties.edgeBlur(blurEdges: true),
                                onChangeStart: (value) => _startValue = value,
                                onChangeEnd: (value) => _endValue = value,
                                onChangePlaybackState: (value) {
                                  if (mounted) {
                                    setState(() => _isPlaying = value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        /// Buttons
                        Container(
                          height: 60,
                          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonCircular(
                                onPressed: (){
                                  context.pop();
                                },
                                text: 'Cancel',
                              ),
                              ButtonCircular(
                                onPressed: () => read.exportVideo(context, _controller),
                                text: 'Next',
                              ),
                            ],
                          ),
                        ),

                        ValueListenableBuilder(
                          valueListenable: read.isExporting,
                          builder: (_, bool export, Widget? child) =>
                              AnimatedSize(
                                duration: kThemeAnimationDuration,
                                child: export ? child : null,
                              ),
                          child: AlertDialog(
                            title: ValueListenableBuilder(
                              valueListenable: read.exportingProgress,
                              builder: (_, double value, __) => Text(
                                "Exporting video ${(value * 100).ceil()}%",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ).loadingView(!_controller.initialized),
      ),
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  /// KESISH
  Widget _trimVideoSlider() {
    return Container(
        width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.symmetric(vertical: 60 / 4),
       margin: const EdgeInsets.only(top: 10),
        child: TrimSlider(
          controller: _controller,
          height: 60,
          horizontalMargin: 60 / 4,
          child: TrimTimeline(
            controller: _controller,
            textStyle: const TextStyle(color: Colors.transparent),
            padding: const EdgeInsets.only(top: 0),
          ),
        ),
      );
  }

}
