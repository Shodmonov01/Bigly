
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../constants/app_images.dart';

import '../../../../../constants/constants.dart';
import '../../../../../core/widgets/base_button.dart';

class AddToSmallBox extends StatelessWidget {

  AddToSmallBox({super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push(RouteNames.posts),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.asset(AppImages.postImage,fit: BoxFit.cover,),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: opacitiyWhite,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: BaseButton(
                                onPressed: () {

                                },
                                color: opacitiyWhite,
                                height: 20,
                                width: 50,
                                border: false,
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Text("\$10/week",style: TextStyle(fontSize: 9),)
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          3.hGap,
          Text("Content Plan",style: TextStyle(fontSize: 10),),
        ],
      ),
    );
  }

}
