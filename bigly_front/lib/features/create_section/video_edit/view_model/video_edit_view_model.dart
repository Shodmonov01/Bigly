
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:video_editor/video_editor.dart';

import '../../../../constants/app_paths.dart';
import '../presentation/pages/export_service.dart';

class VideoEditViewModel extends ChangeNotifier {

  final exportingProgress = ValueNotifier<double>(0.0);
  final isExporting = ValueNotifier<bool>(false);

  void exportVideo(BuildContext context, VideoEditorController videoController) async {
    exportingProgress.value = 0;
    isExporting.value = true;
    var path = await AppPaths.pathCacheVideo;

    final config = VideoFFmpegVideoEditorConfig(
      videoController,
      outputDirectory: path,
    );

    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        exportingProgress.value = config.getFFmpegProgress(int.parse(stats.getTime().toString()));
      },
      // onError: (e, s) => _showErrorSnackBar("Error on export video :("),
      onCompleted: (file) {
        isExporting.value = false;
        // if (!mounted) return;
        // editedVideoFile = file;
        context.pop(file);
      },
    );
  }
}