import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

class SummariesOptions extends StatelessWidget {
  final String debitEnding;
  final String name;
  const SummariesOptions({super.key, required this.debitEnding, required this.name});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(width: .6,color: Colors.grey)
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Visa Debit ending in $debitEnding',style: const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700)),
                    Image.asset(AppImages.visaCard,width: 45,)
                  ],
                ),
                Text('Used for payouts',style: TextStyle(color: Colors.green,fontSize: 14),),
                Text(name,style: TextStyle(color: Colors.grey,fontSize: 14),),
              ],
            ),
          ),
          Divider(height: 0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Edit',style: TextStyle(color: Colors.blue),),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Manage',style: TextStyle(color: Colors.blue),),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Delete',style: TextStyle(color: Colors.blue),),
              )
            ],
          )
        ],
      )
    );
  }
}
