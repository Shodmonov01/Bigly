
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/login/presentation/widgets/choose_interest_view.dart';
import 'package:social_media_app/features/login/presentation/widgets/create_age_view.dart';
import 'package:social_media_app/features/login/presentation/widgets/create_name_view.dart';
import 'package:social_media_app/features/login/presentation/widgets/create_profile_photo.dart';
import 'package:social_media_app/features/login/presentation/widgets/create_user_name_view.dart';
import 'package:social_media_app/features/login/presentation/widgets/welcome_view.dart';

import '../../view_model/login_view_model.dart';
import '../widgets/create_password_view.dart';
import '../widgets/follow_superheroes_view.dart';
import '../widgets/social_auth_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  void initState() {
    // context.read<LoginViewModel>().ok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<LoginViewModel>();

    return Scaffold(
      body: PageView(
        controller: read.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SocialAuthView(),
          CreateUserNameView(),
          CreatePasswordView(),
          CreateNameView(),
          CreateAgeView(),
          CreateProfilePhoto(),
          ChooseInterestView(),
          FollowSuperheroesView(),
          WelcomeView(),
        ],
      ),
    );
  }
}
