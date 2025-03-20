
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_media_app/constants/app_paths.dart';
import 'package:social_media_app/core/data/data_source/local/app_local_data.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/widgets/common_dialog.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/create_section/new_insight/data/repo/new_insight_repo.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/data/models/user_model.dart';
import '../../posts/data/models/post_model.dart';
import '../presentation/widgets/add_tags_view.dart';

class NewInsightViewModel extends ChangeNotifier {

  NewInsightViewModel(this.newInsightRepo);
  final NewInsightRepo newInsightRepo;

  TextEditingController descriptionController = TextEditingController();
  List<Uint8List?> images = [];
  List<String> minutes = [];
  VideoPlayerController? controller;
  GroupButtonController groupButtonController = GroupButtonController(
    selectedIndex: 0,
  );
  List<bool> selectedCheck = [];
  File? selectedVideFile;
  bool isLoading = false;

  String mainSelectedTag = '';
  List<String> additionalSelectedTags = [];
  List<String> superHeroSelectedTags = [];

  void onSelectMainTag(String tag) {
    mainSelectedTag = tag;
    notifyListeners();
  }
  void onRemoveMainTag() {
    mainSelectedTag = '';
    notifyListeners();
  }

  void onSelectAdditionalTag(String tag) {
    if (additionalSelectedTags.length == 3) return;
    additionalSelectedTags.add(tag);
    notifyListeners();
  }
  void onRemoveAdditionalTag(String tag) {
    additionalSelectedTags.remove(tag);
    notifyListeners();
  }

  void onSelectSuperHeroTag(String tag) {
    if (superHeroSelectedTags.length == 3) return;
    superHeroSelectedTags.add(tag);
    notifyListeners();
  }
  void onRemoveSuperHeroTag(String tag) {
    superHeroSelectedTags.remove(tag);
    notifyListeners();
  }

  void onTapAddTag(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const CommonDialog(
          child: AddTagsView(
            addTagsEnum: AddTagsEnum.addTags,
            tags: [
              [
                'Psycology',
                'Breakup Healing',
                'Beuty',
                'Food',
                'Party',
                'Fitness',
                'Inspiration',
                'Antiaging',
                'Health',
                'Happyness',
                'Politics',
                'Society',
                'Future',
              ],
              [
                'Psycology',
                'Breakup Healing',
                'Beuty',
                'Food',
                'Party',
                'Fitness',
                'Inspiration',
                'Antiaging',
                'Health',
                'Happyness',
                'Politics',
                'Society',
                'Future',
              ],

            ],
          ),
        );
      },
    );
  }

  List<UserModel> users = [];
  void searchUsers(String username) async {
    users = await AppRemoteData.searchUsers(username);
    notifyListeners();
  }
  void onTapOtherSuperHeroes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          child: AddTagsView(
            addTagsEnum: AddTagsEnum.tagOtherSuperheroes,
            tags: [
              users.map((e) => e.username!).toList(),
            ],
          ),
        );
      },
    );
  }

  void initData(File? videoFile) {
    if (videoFile == null) return;
    selectedVideFile = videoFile;
  }

  List<AssetEntity> videosFromAsset = [];
  Stream<List<AssetEntity>> fetchMedia() async* {
    await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,

    );

    videosFromAsset = await albums[0].getAssetListPaged(page: 0, size: 80);

    selectedCheck = List.generate(videosFromAsset.length, (index) => false);
    notifyListeners();

    
    yield videosFromAsset;
  }

  List<FileSystemEntity> videosFromDraw = [];
  Stream<List<FileSystemEntity>> fetchDraft() async* {
    String? drawPath = await AppPaths.pathDrawVideo;
    videosFromDraw = Directory(drawPath ?? '').listSync();

    videosFromDraw[0];

    selectedCheck = List.generate(videosFromDraw.length, (index) => false);
    notifyListeners();

    yield videosFromDraw;
  }

  void chooseVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // type: FileType.video,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      Uri uri = Uri.parse(file.path);
      selectedVideFile = File.fromUri(uri);

      if (controller == null) { //if current controller is null
        controller = VideoPlayerController.file(file);
      } else {
        final oldController = controller;
        await oldController?.dispose();
        controller = VideoPlayerController.file(file);
      }

      isSelectVideo = true;
      await controller?.initialize();
      notifyListeners();
    } else {
      // User canceled the picker
    }
  }

  String printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    if (duration.inHours == 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  bool isSelectVideo = false;
  void onTapVideoItem(int index) async {
    try {
      isLoading = true;
      notifyListeners();

      selectedCheck = List.generate(videosFromAsset.length, (index) => false);
      selectedCheck[index] = true;
      File? file = await videosFromAsset[index].file;
      selectedVideFile = File.fromUri(Uri.parse(file!.path));

      if (controller == null) { //if current controller is null
        controller = VideoPlayerController.file(file!);
      } else {
        final oldController = controller;
        await oldController?.dispose();
        controller = VideoPlayerController.file(file!);
      }

      isSelectVideo = true;
      await controller?.initialize();
      notifyListeners();
    } on Exception catch (_) {} finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void disposeVideoController() {
    isSelectVideo = false;
    controller?.dispose();
  }


  /// backend
  ContentModel? postModel;
  Future<void> createPost() async {
    String fileName = selectedVideFile!.path.split('/').last;
    final file = await MultipartFile.fromFile(selectedVideFile!.path, filename: fileName);

    postModel = ContentModel(
      main_tag_name: mainSelectedTag,
      text: descriptionController.text,
      type: ContentType.content,
      media_type: ContentMediaType.video,
      tag_list: additionalSelectedTags,
      tagged_user_list: [],
      mediaFile: file,
    );
    // await newInsightRepo.createPost(postModel);
  }

}
