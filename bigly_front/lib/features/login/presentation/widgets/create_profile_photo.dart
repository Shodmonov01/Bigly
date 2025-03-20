
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_icons.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';

import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class CreateProfilePhoto extends StatelessWidget {
  const CreateProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {

    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            read.onNext(context, 4);
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
                'Add profile photo',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'appFontBold',
                  fontWeight: FontWeight.w900,
                ),
              ),
              20.hGap,

              Text(
                'Upload a profile photo so your friends recoglize you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  letterSpacing: .5,
                ),
              ),
              20.hGap,

              (watch.pickedFile == null) ?
              GestureDetector(
                onTap: (){
                  read.onSelectProfileImage();
                },
                child: Image.asset(
                  height: .4.wp(context),
                  AppIcons.addProfilePhoto,
                ),
              ) :
              GestureDetector(
                onTap: () {
                  read.onSelectProfileImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  child: Image.file(
                    File.fromUri(Uri.file(read.pickedFile!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const Spacer(),

              ButtonRectangular(
                onPressed: (){
                  // if (read.profileBase64Image) return;
                  read.onNext(context, 6);
                },
                height: 45,
                width: double.infinity,
                text: 'Next',
                // child: const Text('Next'),
              ),
              TextButton(
                onPressed: (){
                  read.onNext(context, 6);
                },
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
