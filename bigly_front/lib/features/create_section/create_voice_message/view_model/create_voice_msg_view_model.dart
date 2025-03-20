import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/data/models/content_model.dart';
import '../../../../router/router.dart';
import '../../add_to/presentation/pages/add_to.dart';

class CreateVoiceMsgViewModel extends ChangeNotifier {

  bool isSwiped = false;
  bool isComplete = false;
  bool isCompleteIcon = false;
  Timer? timer;
  int currentTagIndex = 0;
  // List tags = ['Hi,','Hey,','Good morning,','What\'s Up,','Howdy,','Dear,'];
  List tags = [];
  RecorderController controller = RecorderController();

  void changeSwiped(bool value){
    isSwiped=value;
    notifyListeners();
  }

  Future<void> record() async {
    // final hasPermission = await controller.checkPermission();
    await controller.record();
  }

  File? recordedAudioFile;
  Future<void> stop() async {
    final path = await controller.stop();
    recordedAudioFile = File(path!);
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

  void initRecorder() async {
    controller = RecorderController();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    notifyListeners();
  }

  void disposePage(){
    controller.dispose();
    isComplete=false;
    isSwiped=false;
    isCompleteIcon=false;
    notifyListeners();
  }

  void setTagIndex(index) {
    currentTagIndex = index;
    notifyListeners();
  }

  ContentModel? contentModel;
  Future<void> addToContent(BuildContext context) async {
    String fileName = recordedAudioFile!.path.split('/').last;
    final file = await MultipartFile.fromFile(recordedAudioFile!.path, filename: fileName);

    contentModel = ContentModel(
      media_type: ContentMediaType.audio,
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

}