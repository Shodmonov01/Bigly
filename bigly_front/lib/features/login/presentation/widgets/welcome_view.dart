
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_icons.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/router/router.dart';
import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Spacer(),

            Image.asset(
              AppIcons.createSelect,
            ),

            Text(
              'Welcome to Bigly,\n${read.firstNameController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'appFontBold',
                fontWeight: FontWeight.w900,
              ),
            ),

            20.hGap,

            ButtonRectangular(
              onPressed: (){
                context.pushReplacement(RouteNames.home);
              },
              height: 45,
              width: double.infinity,
              text: "Let's GO!",
            ),

            const Spacer(),

            const Text('See our Terms and Privacy Policy'),

          ],
        ),
      ),
    );
  }
}
