
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/main.dart';

import '../../../../core/data/models/content_model.dart';
import '../../../../router/router.dart';
import '../../add_to/presentation/pages/add_to.dart';

class CreateVideoMsgViewModel extends ChangeNotifier {

  bool isSwiped = false;
  bool isComplete = false;
  bool isCompleteIcon = false;
  Timer? timer;
  int currentTagIndex = 0;
  List tags = ['Hi,','Hey,','Good morning,','What\'s Up,','Howdy,','Dear,'];
  late CameraController controller;

  // Future<void> record() async {
  //   // final hasPermission = await controller.checkPermission();
  //   // await controller.record();
  // }

  Future<void> stop() async {
    // final path = await controller.stop();

    isComplete=true;
    isCompleteIcon=true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      isCompleteIcon=false;
      notifyListeners();
      timer.cancel();
    });
  }

  void initCamera() {
    videoTime = "00:00";
    if (timer != null) {
      timer!.cancel();
    }
    controller = CameraController(cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      notifyListeners();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
    // notifyListeners();
  }

  String _getFormatTime(Duration duration) {
    // String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    // return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String videoTime = "";
  File? recordedVideo;
  void onTapRecord(BuildContext context, bool isRecording) async {
    isSwiped = isRecording;
    int second = 0;
    notifyListeners();
    if (isRecording) {
      isComplete = false;
      notifyListeners();
      await controller.startVideoRecording();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        videoTime = _getFormatTime(Duration(seconds: second));
        second++;
        notifyListeners();
      });
      return;
    }
    isComplete = true;
    videoTime = "00:00";
    timer!.cancel();
    XFile? file = await controller.stopVideoRecording();
    recordedVideo = File(file.path);
    notifyListeners();
  }

  ContentModel? contentModel;
  Future<void> addToContent(BuildContext context) async {
    String fileName = recordedVideo!.path.split('/').last;
    final file = await MultipartFile.fromFile(recordedVideo!.path, filename: fileName);

    contentModel = ContentModel(
      media_type: ContentMediaType.video,
      mediaFile: file,
      type: ContentType.message,
      tag_list: [],
      tagged_user_list: [],
    );
    context.push(
      RouteNames.contentPlan,
      extra: AddToEnum.add,
    );
  }

  void disposePage(){
    controller.dispose();
    isComplete=false;
    isSwiped=false;
    isCompleteIcon=false;
    // notifyListeners();
  }

  void setTagIndex(index) {
    currentTagIndex = index;
    notifyListeners();
  }
}