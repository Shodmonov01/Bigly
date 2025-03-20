
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppPaths {
  // static downloadFolder =

  static Future<String?> get pathCacheVideo async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory("/storage/emulated/0/Download");
    }
    directory = await Directory('${directory.path}/Bigly/cache/video').create(recursive: true);
    return directory.path;
  }

  static Future<String?> get pathCacheImage async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory("/storage/emulated/0/Download");
    }
    directory = await Directory('${directory.path}/Bigly/cache/image').create(recursive: true);
    return directory.path;
  }

  static Future<String?> get pathDrawVideo async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory("/storage/emulated/0/Download");
    }
    directory = await Directory('${directory.path}/Bigly/draw').create(recursive: true);
    return directory.path;
  }

  static Future<String?> get pathMediaVideo async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory("/storage/emulated/0/Download");
    }
    directory = await Directory('${directory.path}/Bigly/media').create(recursive: true);
    return directory.path;
  }

  static Future<String?> get storageFolder async {
    var dir = await getExternalStorageDirectory();
    return dir?.path;
  }

  static Future<String> get cacheFolder async {
    var dir = await getApplicationCacheDirectory();
    return dir.path;
  }
}