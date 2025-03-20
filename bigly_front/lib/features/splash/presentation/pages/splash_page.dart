
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../router/router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    Future.delayed(const Duration(seconds: 1), () async {
      // User? user = FirebaseAuth.instance.currentUser;
      // await context.read<ProfileViewModel>().getUser();
      String? token = await AppLocalData.getUserToken;
      if (token == null) {
        context.pushReplacement(RouteNames.register);
      } else {
        context.pushReplacement(
          RouteNames.home,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
