
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/data/models/group_model.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/home/view_model/home_view_model.dart';
import 'package:social_media_app/features/team/add_members/data/repo/add_member_repo.dart';
import 'package:social_media_app/features/team/teams/view_model/teams_view_model.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../core/data/models/user_model.dart';
import '../../../../core/tools/app_image_picker.dart';
import '../../../../di_service.dart';
import '../../contacts/data/models/contactWithLetterModel.dart';
import '../../contacts/data/repo/new_chat_repo.dart';

class AddMemberViewModel extends ChangeNotifier {

  AddMemberViewModel(this.addMemberRepo);
  final AddMemberRepo addMemberRepo;

  bool isLoading = false;
  void initData() {
    letters.clear();

    for (var i = 65; i <= 90; i++) {
      String letter = String.fromCharCode(i);
      ContactWithLetterModel contactWithLetterModel = ContactWithLetterModel.fromJson({
        "letter": letter,
        "users": <UserModel>[]
      });
      letters.add(contactWithLetterModel);
    }

    contactsWithLetter = [];
    notifyListeners();
  }
  void initCreateGroupPage() {
    groupImage = null;
    groupNameController.clear();
    notifyListeners();
  }
  List<ContactWithLetterModel> letters = [];
  List<ContactWithLetterModel> contactsWithLetter = [];
  List<UserModel> allUsers = [];
  TextEditingController searchEditingController = TextEditingController();

  // Future<void> createChat(BuildContext context, String userName) async {
  //
  // }

  Future<void> getUsers() async {
    selectedContentPlans = [];
    selectedUsers = [];
    isLoading = true;
    notifyListeners();
    initData();
    allUsers = await addMemberRepo.getUsers();
    sortUsers();
    isLoading = false;
    notifyListeners();
  }
  Future<void> searchUsers(String text) async {
    isLoading = true;
    notifyListeners();
    initData();
    allUsers = await getIt<NewChatRepo>().searchUsers(text);
    sortUsers();
    isLoading = false;
    notifyListeners();
  }
  void sortUsers() {
    for (var i = 0; i < allUsers.length; i++) {
      String letter = allUsers[i].firstName![0].toUpperCase();
      letters
          .where((element) => element.letter == letter)
          .first.users
          .add(allUsers[i]);
    }

    for (var item in letters) {
      if (item.users.isNotEmpty) {
        contactsWithLetter.add(item);
      }
    }
  }

  TextEditingController groupNameController = TextEditingController();

  File? groupImage;
  void chooseGroupImage(BuildContext context) async {
    final pickedImage = await appImagePicker(context, groupImage);
    if (pickedImage.$2 != null) {
      if (pickedImage.$2!) {
        groupImage = null;
      } else {
        groupImage = pickedImage.$1;
      }
    }
    notifyListeners();
  }


  Future<void> createGroup(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    MultipartFile? profileBase64Image;
    if (groupImage != null) {
      profileBase64Image = await MultipartFile.fromFile(groupImage!.path);
    }
    GroupModel groupModel = GroupModel(
      group_name: groupNameController.text,
      group_image_file: profileBase64Image,
      is_group: true,
      user_id_list: selectedUsers,
    );
    ChatModel? chatModel = await addMemberRepo.createGroup(groupModel);

    isLoading = false;
    notifyListeners();
    if (chatModel == null) {
      context.showSnackBar('Something went wrong. Please, try again');
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamsViewModel>().getChats().then((value) {
        context.go(RouteNames.home);
        context.read<HomeViewModel>().onTapNavBar(4);
        context.push(
          RouteNames.chat,
          extra: chatModel.id,
        );
      },);
    },);
  }

  List<int> selectedUsers = [];
  void onTapUserItem(UserModel userModel) {
    userModel.isChecked = !userModel.isChecked;
    if (userModel.isChecked) {
      selectedUsers.add(userModel.id);
    } else {
      selectedUsers.remove(userModel.id);
    }
    notifyListeners();
  }

  List<ContentPlanModel> selectedContentPlans = [];
  Future<void> getSubscribers(int id, ContentPlanModel contentPlanModel) async {
    selectedUsers.clear();
    selectedContentPlans.clear();

    selectedContentPlans.add(contentPlanModel);
    final list = await addMemberRepo.getSubscribers(id);
    for (var item in list) {
      selectedUsers.add(item.id);
    }

    for (var item in allUsers) {
      item.isChecked = selectedUsers.contains(item.id);
    }

    notifyListeners();
  }

}