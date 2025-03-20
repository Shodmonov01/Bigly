import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/payments_data/presentation/widgets/payments_data_item.dart';

import '../../../core/theme/my_theme.dart';
import '../../../core/widgets/back_button.dart';
import '../../payments/presentation/widgets/money_data_box.dart';

class PaymentsData extends StatelessWidget {
  const PaymentsData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text('My Payouts & Payments'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MoneyDataBox(
                  title: 'My total founds',
                  money: 0.00
              ),
              15.hGap,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "These funds consist of ",
                      style: MyTheme.smallGreyText,
                    ),
                    const TextSpan(
                      text: "all of your earnings, ",
                      style: TextStyle(fontSize: 12,color: Colors.grey,fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: "whether or not they're available to be paid out to you. This includes your processiing and on-hold funds. ",
                      style: MyTheme.smallGreyText
                    ),
                    const TextSpan(
                      text: "Learn more",
                      style: TextStyle(fontSize: 12,color: Colors.black54,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)
                    )
                  ]
                ),
              ),
              10.hGap,

              ...List.generate(5, (index) => PaymentsDataItem(isLast: index==4,),)
            ],
          ),
        ),
      ),
    );
  }
}
