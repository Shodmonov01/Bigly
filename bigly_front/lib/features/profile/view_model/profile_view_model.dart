
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/core/tools/app_image_picker.dart';
import 'package:social_media_app/di_service.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/repo/content_plan_repo.dart';
import 'package:social_media_app/features/profile/data/repo/profile_repo.dart';
import 'package:social_media_app/features/profile/presentation/widgets/edit_data_view.dart';

import '../presentation/pages/profile_enum.dart';

class ProfileViewModel extends ChangeNotifier {

  ProfileViewModel(this.profileRepo);
  final ProfileRepo profileRepo;

  void onTapEditButton(BuildContext context, ProfileEnum profileEnum, String title, String data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        EditDataView(title: title, initialData: data, profileEnum: profileEnum,)));
  }

  bool isLoading = false;
  void onLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  UserModel? userModel;
  String? name = '';
  String? username = '';
  String? coverImage = '';
  String? profileImage = '';
  int followers = 0;
  int followings = 0;
  String? bio = '';
  int planSubscribers = 0;
  int planLength = 0;


  /// user profile
  Future<void> getUserWithUsername(String username) async {
    userModel = await profileRepo.getUserWithUsername(username);
    await getContentPlansWithUsername(username);
    notifyListeners();
    if (userModel == null) return;

    name = userModel?.firstName;
    this.username = '@${userModel?.username}';
    coverImage = userModel?.cover_image;
    profileImage = userModel?.profilePictureUrl;
    followers = userModel!.follower_count;
    followings = userModel!.following_count;
    bio = userModel?.bio;
    notifyListeners();
  }

  /// get content plans
  List<ContentPlanModel> contentPlanList = [];
  Future<void> getContentPlansWithUsername(String username) async {
    contentPlanList = await profileRepo.getContentPlanWithUsername(username);
    notifyListeners();
  }

  /// my profile
  Future<void> getUser() async {
    isLoading = true;
    notifyListeners();
    userModel = await profileRepo.getUser();
    AppRemoteData.userModel = userModel;
    notifyListeners();
    if (userModel == null) return;

    name = userModel?.firstName;
    username = '@${userModel?.username}';
    coverImage = userModel?.cover_image;
    profileImage = userModel?.profilePictureUrl;
    followers = userModel!.follower_count;
    followings = userModel!.following_count;
    bio = userModel?.bio;
    isLoading = false;
    notifyListeners();

    await getContentPlans();

  }

  /// Content plan and profile
  ContentPlanModel? contentPlanModel;
  Future<void> getContentPlanAndUser(String username, int id) async {
    isLoading = true;
    notifyListeners();
    await getUserWithUsername(username);
    contentPlanModel = await getIt<ContentPlanRepo>().getContentPlan(id);
    planSubscribers = contentPlanModel!.subscriber_count ?? 0;
    planLength = contentPlanModel!.length ?? 0;
    bio = contentPlanModel!.description!;
    isLoading = false;
    notifyListeners();
  }

  Future<void> editBio(String newBio) async {
    await profileRepo.editBio(newBio);
    await getUser();
  }

  Future<void> editName(String newName) async {
    await profileRepo.editName(newName);
    await getUser();
  }

  Future<void> editProfileImage() async {

    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (pickedFile == null) return;


    await profileRepo.editProfileImage(pickedFile.path);
    await getUser();
  }

  Future<void> editCoverImage() async {

    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (pickedFile == null) return;


    await profileRepo.editCoverImage(pickedFile.path);
    await getUser();
  }

  Future<void> getContentPlans() async {
    ContentPlanRepo contentPlanRepo = getIt.get<ContentPlanRepo>();
    final list = await contentPlanRepo.getContentPlans();
    if (list != null) {
      contentPlanList = list;
      print(contentPlanList);
    }
    notifyListeners();

  }

  Future<void> editContentPlan(BuildContext context, ContentPlanModel contentPlanModel) async {
    MultipartFile? bannerImageFile;
    final pickedImage = await appImagePicker(context, null);
    isLoading = true;
    notifyListeners();
    if (pickedImage.$2 != null) {
      isLoading = false;
      notifyListeners();
      if (pickedImage.$2!) {

      } else {
        bannerImageFile = await MultipartFile.fromFile(pickedImage.$1!.path);
        contentPlanModel.bannerFile = bannerImageFile;
        await getIt.get<ContentPlanRepo>().editContentPlan(contentPlanModel);
        await getContentPlans();
        isLoading = false;
        notifyListeners();
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> follow(String username) async {
    await profileRepo.follow(username);
    notifyListeners();
  }

  Future<void> unFollow(String username) async {
    await profileRepo.unFollow(username);
    notifyListeners();
  }

  Future<void> subscribe(int id) async {
    await profileRepo.subscribe(id);
    notifyListeners();
  }

}