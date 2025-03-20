import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/avatar_with_radius.dart';

class PaymentsDataItem extends StatelessWidget {
  final bool isLast;
  const PaymentsDataItem({super.key, this.isLast=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.grey.shade300,thickness: .8,height: 10,),
        SizedBox(
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: AvatarWithRadius(
                    image: AppImages.avatar, radius: 23,
                  ),
                ),
              ),
              5.wGap,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Subscription for free',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                        5.wGap,
                        const Expanded(child: Text('1234567891011',style: TextStyle(fontSize: 14,color: Colors.black87),)),
                        const Text('-\$1.00',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black))
                      ],
                    ),
                    5.hGap,
                    Row(
                      children: [
                        const Expanded(
                          child: Text('\"Self Love Babe.Yummer time \" by @amanda.nunez',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.black87),overflow: TextOverflow.ellipsis,),
                        ),
                        5.wGap,
                        const Text('-\$1.00',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black))
                      ],
                    ),
                    5.hGap,
                    Text('Completed',style: MyTheme.smallGreyText,)
                  ],
                ),
              )
            ],
          ),
        ),
        if(isLast)Divider(color: Colors.grey.shade300,thickness: .8,height: 10,),
      ],
    );
  }
}
