import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/data/models/content_model.dart';

import '../../../../router/router.dart';
import '../../add_to/presentation/pages/add_to.dart';

class CreateTextMsgViewModel extends ChangeNotifier {
  bool isComplete = true;
  bool isOpenField = false;
  TextEditingController textController = TextEditingController();
  bool next = false;

  void changeFieldState(value) async {
    await Future.delayed(const Duration(milliseconds: 350));
    isOpenField = value;
    notifyListeners();
  }

  void changeNextState(value) async {
    next = value;
    notifyListeners();
  }
  void disposePage(){
    isComplete = true;
    isOpenField = false;
    next = false;
    textController.clear();
  }

  ContentModel? contentModel;
  Future<void> addToContent(BuildContext context) async {
    contentModel = ContentModel(
      text: textController.text,
      type: ContentType.message,
      tag_list: [],
      tagged_user_list: [],
    );
    next = false;
    textController.clear();
    notifyListeners();
    context.push(
      RouteNames.contentPlan,
      extra: AddToEnum.add,
    );
  }

}