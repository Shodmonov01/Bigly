
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/features/team/teams/data/models/chat_folder_model.dart';
import 'package:social_media_app/features/team/teams/data/repo/team_repo.dart';

import '../../../../core/data/models/chat_settings_model.dart';
import '../presentation/team_page_settings.dart';

class TeamsViewModel extends ChangeNotifier {

  TeamsViewModel(this.teamRepo);
  final TeamRepo teamRepo;

  // bool isAllChat =  true;
  final groupButtonController = GroupButtonController();
  MessageNotificationEnum? notificationEnum;
  List<PersonTypesEnum>? whoRespondMe;
  PersonTypesEnum? whoMessageFirstEnum;

  void initPage() {
    notificationEnum = MessageNotificationEnum.on;
    whoRespondMe = [PersonTypesEnum.nobody];
    whoMessageFirstEnum = PersonTypesEnum.superheroes;
  }


  List<ChatModel> chats = [];
  List<ChatModel> chatsUnread = [];
  List<ChatModel> chatsSuperhero = [];
  List<ChatModel> chatsSubscriber = [];
  List<ChatModel> chatsFollower = [];
  List<ChatModel> chatsGroup = [];
  List<ChatModel> chatsPinned = [];
  void changeChat(int index, String value) {
    print(index);
    // ChatFolderModel chatFolderModel = ChatFolderModel.fromJson(value);
    notifyListeners();
    switch (index) {
      case 0: {
        notifyListeners();
        break;
      }
      case 1: {
        notifyListeners();
        break;
      }
      case 2: {
        chatsSuperhero = [];
        for (var item in chats) {
          if (item.typeModel == null) {
            if (item.typeModel!.type!.isSubscriber) {
              chatsSuperhero.add(item);
            }
          }
        }
        notifyListeners();
        break;
      }
      case 3: {
        chatsSubscriber = [];
        for (var item in chats) {
          if (item.typeModel == null) {
            if (item.typeModel!.type!.isSubscriber) {
              chatsSubscriber.add(item);
            }
          }
        }
        notifyListeners();
        break;
      }
      case 4: {
        chatsFollower = [];
        for (var item in chats) {
          if (item.typeModel != null) {
            if (item.typeModel!.type!.isFollower) {
              chatsFollower.add(item);
            }
          }
        }
        notifyListeners();
        break;
      }
      case 5: {
        chatsGroup = [];
        for (var item in chats) {
          if (item.typeModel != null) {
            if (item.typeModel!.type!.isGroup) {
              chatsGroup.add(item);
            }
          }
        }
        notifyListeners();
        break;
      }
      case 6: {
        notifyListeners();
        break;
      }
    }
    groupButtonController.selectIndex(index);
    notifyListeners();
  }

  int get getChatsLength {
    switch (groupButtonController.selectedIndex) {
      case 0: {
        return chats.length;
      }
      case 1: {
        return chatsUnread.length;
      }
      case 2: {
        return chatsSuperhero.length;
      }
      case 3: {
        return chatsSubscriber.length;
      }
      case 4: {
        return chatsFollower.length;
      }
      case 5: {
        return chatsGroup.length;
      }
      case 6: {
        return chatsPinned.length;
      }
    }
    return chats.length;
  }

  showSettingsScreen(context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SafeArea(child: TeamPageSettings());
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: anim, curve: Curves.easeInOutExpo),
          ),
          child: child,
        );
      },
    );
  }

  Future<void> getChats() async {
    // chatsGroup.clear();
    // chatsUnread.clear();
    await getChatSettings();
    chats = await teamRepo.getChats();
    // for (var item in chats) {
    //   if (item.is_group != null) {
    //     if (item.is_group!) {
    //       chatsGroup.add(item);
    //     }
    //   }
    // }
    notifyListeners();
  }

  Future<void> deleteChat(int id) async {
    await teamRepo.deleteChat(id);
    getChats();
  }

  ChatSettingsModel? chatSettingsModel;
  Future<void> getChatSettings() async {
    chatSettingsModel = await teamRepo.getChatSettings();
    notifyListeners();
  }

  Future<void> changeChatSettings(ChatSettingsModel chatSettingsModel) async {
    this.chatSettingsModel = await teamRepo.changeChatSettings(chatSettingsModel);
    notifyListeners();
  }

}
