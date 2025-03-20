import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/features/team/contacts/data/models/navigator_model.dart';

class NavigatorItem extends StatelessWidget {
  final NavigatorModel model;
  final bool isEnd;
  const NavigatorItem({super.key, required this.model, this.isEnd=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(model.page!);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade100,
              child: model.icon,
            ),
            10.wGap,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  7.hGap,
                  Text(model.text!,style: MyTheme.bodyMediumGreyText,),
                  7.hGap,
                  !isEnd?
                  Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: .4,
                  ):SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
