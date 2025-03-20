
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_media_app/di_service.dart';
import 'package:social_media_app/features/grow_and_discover/grow/data/repo/grow_repo.dart';
import 'package:social_media_app/features/profile/data/repo/profile_repo.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/data/models/content_model.dart';

class GrowViewModel extends ChangeNotifier {

  GrowViewModel(this.growRepo);
  final GrowRepo growRepo;

  List<ContentModel> contents = [];
  List<VideoPlayerController?> videoControllersGrow = [];
  List<VideoPlayerController?> videoControllersDiscover = [];


  static const int _pageSize = 10;
  PagingController<int, ContentModel> growPagingController = PagingController(firstPageKey: 1);
  PagingController<int, ContentModel> discoverPagingController = PagingController(firstPageKey: 1);

  void initGrowPagination() {
    growPagingController.dispose();
    growPagingController = PagingController(firstPageKey: 1);
    growPagingController.addPageRequestListener((pageKey) {
      getPosts(pageKey);
    });
  }

  void initDiscoverPagination() {
    discoverPagingController.dispose();
    discoverPagingController = PagingController(firstPageKey: 1);
    discoverPagingController.addPageRequestListener((pageKey) {
      getDiscover(pageKey);
    });
  }


  Future<void> playVideoGrow(int index, String path) async {
    if (videoControllersGrow[index] == null) {

      videoControllersGrow[index] = VideoPlayerController.networkUrl(

        Uri.parse(path),
        // Uri.parse('https://firebasestorage.googleapis.com/v0/b/take-a-look-ac060.appspot.com/o/video%201.MP4?alt=media&token=c2ed209e-3ead-4af2-a3ab-1cb0c65690cc'),
        // Uri.parse('https://firebasestorage.googleapis.com/v0/b/take-a-look-ac060.appspot.com/o/video%2010.MP4?alt=media&token=5871b304-59b4-4448-9360-801825476256'),
      )..initialize().then((value) {
        notifyListeners();
      },)..setLooping(true)..play();
    }
      if (!videoControllersGrow[index]!.value.isPlaying) {
        videoControllersGrow[index]!.play();
      }
      notifyListeners();
  }

  Future<void> playVideoDiscover(int index, String path) async {
    if (videoControllersDiscover[index] == null) {

      videoControllersDiscover[index] = VideoPlayerController.networkUrl(

        Uri.parse(path),
        // Uri.parse('https://firebasestorage.googleapis.com/v0/b/take-a-look-ac060.appspot.com/o/video%201.MP4?alt=media&token=c2ed209e-3ead-4af2-a3ab-1cb0c65690cc'),
        // Uri.parse('https://firebasestorage.googleapis.com/v0/b/take-a-look-ac060.appspot.com/o/video%2010.MP4?alt=media&token=5871b304-59b4-4448-9360-801825476256'),
      )..initialize().then((value) {
        notifyListeners();
      },)..setLooping(true)..play();
    }

    if (!videoControllersDiscover[index]!.value.isPlaying) {
      videoControllersDiscover[index]!.play();
    }
    // notifyListeners();
  }

  void stopVideoGrow(int index, ) {
    if (videoControllersGrow[index] != null) {
      videoControllersGrow[index]!.pause();
    }
    notifyListeners();
  }
  void stopVideoDiscover(int index, ) {
    if (videoControllersDiscover[index] != null) {
      videoControllersDiscover[index]!.pause();
    }
    // notifyListeners();
  }

  void stopAllVideos() {
    for (var element in videoControllersGrow) {
      element?.pause();
    }
    for (var element in videoControllersDiscover) {
      element?.pause();
    }
  }


  Future<void> getPosts(int page) async {
    contents = await growRepo.getPosts(page, _pageSize);
    final isLastPage = contents.length < _pageSize;
    if (isLastPage) {
      growPagingController.appendLastPage(contents);
    } else {
      final nextPageKey = page + 1;
      growPagingController.appendPage(contents, nextPageKey);
    }
    notifyListeners();

    VideoPlayerController? videoPlayerController;
    // videoControllersGrow = List.generate(growPagingController.value.nextPageKey ?? 0, (index) => videoPlayerController,);
    videoControllersGrow = List.generate(contents.length, (index) => videoPlayerController,);
    notifyListeners();
  }

  List<ContentModel> contentsDiscover = [];
  Future<void> getDiscover(int page) async {
    contents = await growRepo.getDiscover(page, _pageSize);
    final isLastPage = contents.length < _pageSize;
    if (isLastPage) {
      discoverPagingController.appendLastPage(contents);
    } else {
      final nextPageKey = page + 1;
      discoverPagingController.appendPage(contents, nextPageKey);
    }
    // contentsDiscover = await growRepo.getDiscover();

    VideoPlayerController? videoPlayerController;
    // videoControllersDiscover = List.generate(contentsDiscover.length, (index) => videoPlayerController,);
    videoControllersDiscover = List.generate(contents.length, (index) => videoPlayerController,);
    notifyListeners();
    // notifyListeners();
  }


  Future<void> follow(String username) async {
    await getIt.get<ProfileRepo>().follow(username);
    notifyListeners();
  }

  Future<void> unFollow(String username) async {
    await getIt.get<ProfileRepo>().unFollow(username);
    notifyListeners();
  }

  Future<void> subscribe(int id) async {
    await getIt.get<ProfileRepo>().subscribe(id);
    notifyListeners();
  }
}