
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media_app/constants/app_paths.dart';
import 'package:video_player/video_player.dart';

import '../../../../router/router.dart';
import '../../new_insight/presentation/pages/new_insight.dart';

class VideoViewViewModel extends ChangeNotifier {

  bool isLoading = false;
  File? videoFile1;

  Future<void> downloadMedia(File videoFile) async {
    // isLoading = true;
    await Permission.manageExternalStorage.request();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      // if (Platform.isIOS) {
      //   directory = await getApplicationDocumentsDirectory();
      // } else {
      //   directory = Directory("/storage/emulated/0/Download");
      // }
      // directory = await Directory('${directory.path}/Bigly/media').create(recursive: true);

      final path = await AppPaths.pathMediaVideo;

      String fileName = videoFile!.path.split('/').last;
      print(fileName);
      final file = File('$path/$fileName');
      await file.writeAsBytes(videoFile!.readAsBytesSync());

    } catch (err, _) {
      debugPrint("Cannot get download folder path");
    }
  }

  Future<void> downloadDraw(File videoFile) async {
    // isLoading = true;
    await Permission.manageExternalStorage.request();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      // if (Platform.isIOS) {
      //   directory = await getApplicationDocumentsDirectory();
      // } else {
      //   directory = Directory("/storage/emulated/0/Download");
      // }
      // directory = await Directory('${directory.path}/Bigly/media').create(recursive: true);

      final path = await AppPaths.pathDrawVideo;

      String fileName = videoFile.path.split('/').last;
      print(fileName);
      final file = File('$path/$fileName');
      await file.writeAsBytes(videoFile.readAsBytesSync());

    } catch (err, _) {
      debugPrint("Cannot get download folder path");
    }
  }

  Future<void> downloadCacheFile(File videoFile) async {
    await Permission.manageExternalStorage.request();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // Directory? directory;
    try {
      // if (Platform.isIOS) {
      //   directory = await getApplicationDocumentsDirectory();
      // } else {
      //   directory = Directory("/storage/emulated/0/Download");
      // }
      // directory = await Directory('${directory.path}/Bigly/draw').create(recursive: true);

      final path = await AppPaths.pathDrawVideo;

      String fileName = videoFile.path.split('/').last;
      final file = File('$path/$fileName');
      await file.writeAsBytes(videoFile.readAsBytesSync());
      
    } catch (err, _) {
      debugPrint("Cannot get download folder path");
    }
  }

  int currentColorFilterIndex = 0;
  List<List<double>> colorFilters = [
    [
      // no filter
    ],
    [
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0,      0,      0,      1, 0,
    ],

    [
      1.2, 0, 0, 0, 0,
      0, 1.2, 0, 0, 0,
      0, 0, 1.1, 0, 0,
      0, 0, 0, 1, 0,
    ],

    [
      1.05, 0, 0, 0, 0.1,
      0, 1.05, 0, 0, 0.1,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ],

    [
      1.1, 0, 0, 0, 0,
      0, 1.1, 0, 0, 0,
      0, 0, 1.05, 0, 0,
      0, 0, 0, 1, 0,
    ],


    [
      0.9, 0, 0, 0, 0,
      0, 1.1, 0, 0, 0,
      0, 0, 1.1, 0, 0,
      0, 0, 0, 1, 0,
    ]
  ];
  Future<void> onChangeColorFilter({required bool isLeft}) async {
    print(isLeft);
    if (isLeft) {
      if (currentColorFilterIndex == 0) {
        currentColorFilterIndex = colorFilters.length-1;
      } else {
        currentColorFilterIndex--;
      }
    } else {
      if (currentColorFilterIndex == colorFilters.length-1) {
        currentColorFilterIndex = 0;
      } else {
        currentColorFilterIndex++;
      }
    }
    notifyListeners();
  }

  Future<void> saveFilteredVideo(VideoPlayerController controller) async {
    isLoading = true;
    notifyListeners();
    videoFile1 = File.fromUri(Uri.parse(controller.dataSource));
    String VIDEO_PATH = videoFile1!.path;
    String extension = videoFile1!.path.split('.').last;
    String OUTPUT_PATH = '${await AppPaths.pathCacheVideo}/video.$extension';
    String command = '-i $VIDEO_PATH -vf colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131 -c:a copy $OUTPUT_PATH';
    print(VIDEO_PATH);
    print(OUTPUT_PATH);

    await FFmpegKit.execute(command).then((value) {
      print('NATIJA:');
      value.getOutput().then((value) {
        print(value);
      },);
    },);

    videoFile1 = File(OUTPUT_PATH);
    isLoading = false;
    notifyListeners();
  }

  void onTapNext(BuildContext context, VideoPlayerController controller) async {
    if (currentColorFilterIndex != 0) {
      await saveFilteredVideo(controller);
    }
    await controller.pause();
    context.push(
      RouteNames.newInsight,
      extra: (NewInsightEnum.editContent, videoFile1),
    );
  }

}