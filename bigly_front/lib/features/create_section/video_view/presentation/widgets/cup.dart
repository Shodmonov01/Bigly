import 'package:flutter/services.dart';

import 'tapioca_ball.dart';

/// Cup is a class to wrap a Content object and List object.
class Cup {
  /// Returns the [Content] instance for applying filters.
  final Content content;

  /// Returns the [List<TapiocaBall>] instance.
  final List<TapiocaBall> tapiocaBalls;

  /// Creates a Cup object.
  Cup(this.content, this.tapiocaBalls);

  /// Edit the video based on the [tapiocaBalls](list of processing)
  Future suckUp(String destFilePath) {
    final Map<String, Map<String, dynamic>> processing = Map.fromIterable(tapiocaBalls, key: (v) => v.toTypeName(), value: (v) => v.toMap());
    return VideoEditor.writeVideofile(content.name, destFilePath, processing);
  }
}

/// Content is a class to wrap a video file.
class Content {
  /// Returns a video file path.
  final String name;

  /// Creates a [Content] instance.
  Content(this.name);
}

class VideoEditor {
  static const MethodChannel _channel =
  const MethodChannel('video_editor');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future writeVideofile(String srcFilePath, String destFilePath, Map<String,Map<String, dynamic>> processing) async {
    await _channel.invokeMethod('writeVideofile',<String, dynamic> { 'srcFilePath': srcFilePath, 'destFilePath': destFilePath, 'processing': processing });
  }
}
