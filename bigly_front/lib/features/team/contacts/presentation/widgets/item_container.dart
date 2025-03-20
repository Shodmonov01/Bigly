import 'package:flutter/material.dart';

import '../../../../../core/theme/my_theme.dart';

class ItemContainer extends StatelessWidget {
  final Widget child;
  final String? text;

  const ItemContainer({super.key, required this.child, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(text!=null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Text(text!,style:const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey)),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: .3,color: Colors.grey),
            color: Colors.white,
          ),
          child: child,
        )
      ],
    );
  }
}
