
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/data/models/content_model.dart';
import '../../../../router/router.dart';
import '../../add_to/presentation/pages/add_to.dart';

class CreateImageMessageViewModel extends ChangeNotifier {

  List<AssetEntity> imagesFromAsset = [];
  List<bool> selectedCheck = [];

  Stream<List<AssetEntity>> fetchMedia() async* {
    isNext = false;
    await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    imagesFromAsset = await albums[0].getAssetListPaged(page: 0, size: 80);

    selectedCheck = List.generate(imagesFromAsset.length, (index) => false);
    notifyListeners();


    yield imagesFromAsset;
  }

  void onTapImageItem(int index) {
    selectedCheck = List.generate(imagesFromAsset.length, (index) => false);
    selectedCheck[index] = true;
    notifyListeners();
  }

  bool isNext = false;
  onTapNext() {
    isNext = !isNext;
    print(isNext);
    notifyListeners();
  }

  ContentModel? contentModel;
  Future<void> addToContent(BuildContext context) async {
    File? selectedFile = await imagesFromAsset[selectedCheck.indexOf(true)].file;
    String fileName = selectedFile!.path.split('/').last;
    final file = await MultipartFile.fromFile(selectedFile.path, filename: fileName);

    contentModel = ContentModel(
      media_type: ContentMediaType.image,
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