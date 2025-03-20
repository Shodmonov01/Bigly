
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/video_record/presentation/widgets/record_button.dart';
import 'package:social_media_app/features/create_section/video_record/view_model/video_record_view_model.dart';

class VideoRecordPage extends StatefulWidget {
  const VideoRecordPage({super.key});

  @override
  State<VideoRecordPage> createState() => _VideoRecordPageState();
}

class _VideoRecordPageState extends State<VideoRecordPage> {

  late VideoRecordViewModel videoRecordViewModel;


  @override
  void initState() {
    context.read<VideoRecordViewModel>().initCamera();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    videoRecordViewModel = context.read<VideoRecordViewModel>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    videoRecordViewModel.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<VideoRecordViewModel>();
    final watch = context.watch<VideoRecordViewModel>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text(read.videoTime, style: const TextStyle(color: Colors.white),),
        ),
        body:
        (!watch.controller.value.isInitialized) ?
        const Center(
          child: Text(
            'No camera found ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ) :
        Stack(
          children: [
            CameraPreview(
              read.controller,
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RecordButton(),
            ),
          ],
        ),
      ),
    );
  }
}
