
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/main_button.dart';

import '../../view_model/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.pop();
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),

      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'appFontBold',
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.hGap,

              // const Text(
              //   'How do you prefer to be called?\nYou can change it later.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey,
              //     letterSpacing: .5,
              //   ),
              // ),
              // 20.hGap,

              TextFormField(
                controller: read.userNameController,
                decoration: const InputDecoration(
                  hintText: 'Your user name',
                  hintStyle: TextStyle(
                    fontFamily: 'appFont',
                  ),
                ),
                cursorColor: Colors.blue,
              ),

              20.hGap,

              TextFormField(
                controller: read.passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontFamily: 'appFont',
                  ),
                ),
                cursorColor: Colors.blue,
              ),

              20.hGap,

              MainButton(
                onPressed: (){
                  if (read.userNameController.text.isEmpty) return;
                  if (read.passwordController.text.isEmpty) return;
                  read.login(context);
                },
                height: 45,
                width: double.infinity,
                text: 'Login',
              ),

            ],
          ),
        ),
      ),
    ).loadingView(watch.isLoading);
  }
}
