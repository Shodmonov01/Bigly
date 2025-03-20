
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_icons.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/button_rectangular.dart';
import 'package:social_media_app/core/widgets/main_button.dart';
import 'package:social_media_app/router/router.dart';

import '../../view_model/login_view_model.dart';

class SocialAuthView extends StatelessWidget {
  const SocialAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();
    return Column(
      children: [
        (!watch.isAnimated) ?
        Container(
          height: .4.hp(context),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 50),
          // color: const Color(0xFFf09f3a),
          color: const Color(0xFFfe9b00),
          child: Lottie.asset(
              'assets/animation/anim_logo.json',
              repeat: false,
              onLoaded: (p0) async {
                await Future.delayed(Duration(seconds: p0.duration.inSeconds + 1));
                // read.isAnimated = true;
                read.ok();
                // setState(() {});
              },
              options: LottieOptions()
          ),
          // child: Image.asset('assets/images/logo.png'),
        ) :
        Container(
          height: .4.hp(context),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 83),
          // color: const Color(0xFFf09f3a),
          color: const Color(0xFFfe9b00),
          child: Image.asset(
            AppImages.biglyLogo,
          ),
          // child: Image.asset('assets/images/logo.png'),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              20.hGap,
              const Text('Choose how you want to get onboard',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'appFontBold',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              20.hGap,
              SocialAuthButton(
                onPressed: (){},
                text: 'Continue with Google',
                icon: Image.asset(
                  height: 20,
                  width: 20,
                  AppIcons.googleIcon
                ),
              ),
              SocialAuthButton(
                onPressed: (){},
                text: 'Continue with Apple',
                icon: Image.asset(
                  height: 25,
                  width: 25,
                  AppIcons.apple,
                ),
              ),
              SocialAuthButton(
                onPressed: (){},
                text: 'Continue with Facebook',
                icon: Image.asset(
                  height: 20,
                  width: 20,
                  AppIcons.facebookIcon,
                ),
              ),
              SocialAuthButton(
                onPressed: (){},
                text: 'Other method',
                icon: const SizedBox.shrink(),
              ),

              TextButton(
                onPressed: () {
                  context.push(RouteNames.login);
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    fontFamily: 'appFont'
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({super.key,
    required this.text,
    required this.icon,
    required this.onPressed
  });

  final String text;
  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    return MainButton(
      onPressed: (){
        onPressed();
        read.pageController.jumpToPage(1);
      },
      width: double.infinity,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(5),
      borderColor: Colors.black,
      child: Row(
        children: [
          icon,
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
