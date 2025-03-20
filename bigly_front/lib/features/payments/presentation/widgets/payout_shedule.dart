import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

class PayoutShedule extends StatelessWidget {
  final String time;
  const PayoutShedule({super.key, required this.time});

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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(CupertinoIcons.calendar),
                  ),
                  10.wGap,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Payout shedule',style: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700),),
                      Text(time,style: const TextStyle(fontSize: 13,color: Colors.grey,),),
                    ],
                  )
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
