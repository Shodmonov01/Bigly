
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/features/team/message_requests/data/repo/message_request_repo.dart';

import '../../../../router/router.dart';
import '../../../home/view_model/home_view_model.dart';
import '../../teams/view_model/teams_view_model.dart';

class MessageRequestViewModel extends ChangeNotifier {

  MessageRequestViewModel(this.messageRequestRepo);
  final MessageRequestRepo messageRequestRepo;
  List<ChatModel> requests = [];

  Future<void> getRequests() async {
    requests = await messageRequestRepo.getRequests();
    notifyListeners();
  }

  Future<void> acceptRequest(BuildContext context, int chatId) async {
    bool isAccept = await messageRequestRepo.acceptRequest(chatId);
    if (isAccept) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // context.go(RouteNames.home);
        // context.read<HomeViewModel>().currentIndex = 4;
        context.pop();
        context.pop();
        context.push(
          RouteNames.chat,
          extra: chatId,
        );
      });

    }
  }

}