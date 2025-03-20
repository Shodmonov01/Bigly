import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/features/team/contacts/data/models/contactWithLetterModel.dart';
import 'package:social_media_app/features/team/contacts/data/models/navigator_model.dart';
import 'package:social_media_app/features/team/contacts/data/repo/new_chat_repo.dart';
import 'package:social_media_app/router/router.dart';

class ContactsViewModel extends ChangeNotifier {

  ContactsViewModel(this.newChatRepo);
  final NewChatRepo newChatRepo;

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
  List<ContactWithLetterModel> letters = [];
  List<ContactWithLetterModel> contactsWithLetter = [];
  List<UserModel> allUsers = [];
  TextEditingController searchEditingController = TextEditingController();

  Future<void> createChat(BuildContext context, String userName) async {
    isLoading = true;
    notifyListeners();
    ChatModel? chatModel = await newChatRepo.createChatPerson(userName);
    isLoading = false;
    notifyListeners();
    if (chatModel == null) return;
    context.pop();
    context.push(
      RouteNames.chat,
      extra: chatModel.id,
    );
  }

  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();
    initData();
    allUsers = await newChatRepo.getContacts();
    sortUsers();
    isLoading = false;
    notifyListeners();
  }
  Future<void> searchUsers(String text) async {
    isLoading = true;
    notifyListeners();
    initData();
    allUsers = await newChatRepo.searchUsers(text);
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

  List<NavigatorModel> navigators = [
    NavigatorModel(
      text: 'Create New Group',
      icon: const Icon(Icons.person_2,color: Colors.grey,),
      page: RouteNames.addMembers
    ),
    NavigatorModel(
      text:'Create Content Plan Message',
      icon: const Icon(Icons.calendar_view_month_sharp,color: Colors.grey,),
      page: RouteNames.newMessage
    ),
    NavigatorModel(
      text:'Message Requests',
      icon: const Icon(Icons.message_sharp,color: Colors.grey,),
      page: RouteNames.messageRequests
    ),
  ];
}
