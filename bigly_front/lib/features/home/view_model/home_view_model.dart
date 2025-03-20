
import 'package:flutter/material.dart';

import '../../team/teams/view_model/teams_view_model.dart';

class HomeViewModel extends ChangeNotifier {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void onOpenDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  int currentIndex = 1;
  void onTapNavBar(int index) {
    currentIndex = index;
    notifyListeners();
  }
}