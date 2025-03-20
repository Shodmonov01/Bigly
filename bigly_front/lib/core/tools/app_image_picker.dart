
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/icon_with_backgeound.dart';


  Future<File> chooseImage(BuildContext context, ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: source);
    return File(file!.path);
  }

  /// if bool? is true then image is removed.
  /// If bool? is null bottomSheet is closed.
  /// If bool? is false then image is selected
  Future<(File?, bool?)> appImagePicker(BuildContext context, File? beforeSelectedImage) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.white,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: .8.wp(context),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  const Text(
                    "Choose your image",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButtonWithBackground(
                    onTap: () => Navigator.pop(context),
                    height: 40,
                    width: 40,
                    icon: const Icon(Icons.close),
                  ),

                ],
              ).padding(const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
              10.hGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await chooseImage(context, ImageSource.camera);
                      Navigator.pop(context, (result, false));
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 30,),
                      ),
                    ),
                  ),
                  10.wGap,
                  GestureDetector(
                    onTap: () async {
                      final result = await chooseImage(context, ImageSource.gallery);
                      Navigator.pop(context, (result, false));
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined, color: Colors.white, size: 30,),
                      ),
                    ),
                  ),
                ],
              ),


              10.hGap,
              if (beforeSelectedImage != null)
              CupertinoButton(
                onPressed: (){
                  Navigator.pop(context, (null, true));
                },
                color: Colors.grey.shade100,
                child: const Text('Remove image', style: TextStyle(color: Colors.red),),
              )
            ],
          ),
        );
      },
    );
  }
/*

* */