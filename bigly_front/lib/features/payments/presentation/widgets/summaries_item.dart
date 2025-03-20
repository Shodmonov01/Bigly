import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

class SummariesItem extends StatelessWidget {
  final String title;
  final double money;
  final String? time;
  const SummariesItem({super.key, required this.title, required this.money, this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 75,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(width: .6,color: Colors.grey)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700),),
                  Row(
                    children: [
                      Text('\$$money',style: const TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                      5.wGap,
                      if(time!=null) Text('($time)',style: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        15.hGap,
      ],
    );
  }
}
