
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';

import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class CreatePasswordView extends StatelessWidget {
  const CreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            read.onNext(context, 1);
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Create password',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'appFontBold',
                    fontWeight: FontWeight.w900,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                20.hGap,

                Text(
                  'Create a safe password for your new account.\nYou can change it later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    letterSpacing: .5,
                  ),
                ),
                20.hGap,

                TextFormField(
                  controller: read.passwordController,
                  onChanged: (password) {
                    read.checkPassword(password);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontFamily: 'appFont',
                    )
                  ),
                  cursorColor: Colors.blue,
                ),

                20.hGap,

                TextFormField(
                  controller: read.cPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(
                      fontFamily: 'appFont',
                    )
                  ),
                  cursorColor: Colors.blue,
                ),



                if (watch.isPasswordValid != null)
                if (!watch.isPasswordValid!)
                if (watch.passwordErrors != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: watch.passwordErrors!.map((e) {
                    return Text(
                      '* $e',
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ).padding(const EdgeInsets.only(top: 10));
                  },).toList(),
                ),




                20.hGap,

                ButtonRectangular(
                  onPressed: (){
                    String p = read.passwordController.text;
                    String cp = read.cPasswordController.text;
                    if (p.isEmpty || cp.isEmpty) return;
                    if (p != cp) {
                      return;
                    }
                    if (read.isPasswordValid != null) {
                      if (read.isPasswordValid!) {
                        read.onNext(context, 3);
                      }
                    }
                  },
                  height: 45,
                  width: double.infinity,
                  text: 'Next',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
