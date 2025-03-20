import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/base_button.dart';

class MoneyDataBox extends StatelessWidget {
  final String title;
  final double money;
  final Widget? content;
  const MoneyDataBox({super.key, required this.title, required this.money, this.content});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 7),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                Text('\$$money',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                if(content!=null) content!,
                5.hGap
              ],
            )
          ],
        ),
      ),
    );
  }
}
