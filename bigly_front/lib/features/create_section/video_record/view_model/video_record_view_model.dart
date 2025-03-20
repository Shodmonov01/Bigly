
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/router/router.dart';
import '../../../../main.dart';

class VideoRecordViewModel extends ChangeNotifier {
  late CameraController controller;

  void initCamera() {
    videoTime = "00:00";
    if (timer != null) {
      timer!.cancel();
    }
    controller = CameraController(cameras[1], ResolutionPreset.max,);
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
    notifyListeners();
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
  Timer? timer;
  void onTapRecord(BuildContext context, bool isRecording) async {
    int second = 0;
    if (isRecording) {
      await controller.startVideoRecording();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        videoTime = _getFormatTime(Duration(seconds: second));
        second++;
        notifyListeners();
      });
      return;
    }
    videoTime = "00:00";
    timer!.cancel();
    XFile? file = await controller.stopVideoRecording();
    notifyListeners();
    context.push(
      RouteNames.videoView,
      extra: File(file.path),
    );
  }


}