import 'package:flutter/cupertino.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/repo/content_plan_repo.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/post_item.dart';
import 'package:video_player/video_player.dart';

import '../data/models/post_model.dart';

class PostsViewModel extends ChangeNotifier {

  PostsViewModel(this.contentPlanRepo);
  final ContentPlanRepo contentPlanRepo;

  ContentPlanModel? contentPlan;
  List<ContentModel> contents = [];

  Future<void> getContents(int id) async {
    contentPlan = await contentPlanRepo.getContentPlan(id);
    if (contentPlan != null) {
      contents = contentPlan!.contents.map((e) {
        return ContentModel.fromJsonCreate(e);
      },).toList();
      notifyListeners();
      // return contents;
    }
    // return null;
  }

  void changeChecked(index){
    contents[index].isCheck = !contents[index].isCheck;
    notifyListeners();
  }

  bool isShowContentWidget = false;
  String videoFileUrl = '';
  // VideoPlayerController? videoPlayerController;
  // void onTapVideoContent(String media) {
  //   isPlayVideo = !isPlayVideo;
  //   if (isPlayVideo) {
  //     videoFileUrl = media;
  //     videoPlayerController = VideoPlayerController.networkUrl(Uri(path: media));
  //     videoPlayerController!.initialize();
  //     videoPlayerController!.play();
  //     notifyListeners();
  //   } else {
  //     videoPlayerController!.dispose();
  //   }
  //   notifyListeners();
  // }

}
