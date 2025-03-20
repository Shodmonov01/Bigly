import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/features/payments/presentation/widgets/money_data_box.dart';
import 'package:social_media_app/features/payments/presentation/widgets/payout_shedule.dart';
import 'package:social_media_app/features/payments/presentation/widgets/summaries_item.dart';
import 'package:social_media_app/features/payments/presentation/widgets/summaries_options.dart';
import 'package:social_media_app/router/router.dart';

import '../../../core/widgets/base_button.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

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
              MoneyDataBox(
                content: BaseButton(
                  onPressed: () {
                    context.push(RouteNames.myPayoutsData);
                  },
                  border: true,
                  width: 160,
                  color: Colors.grey.shade100,
                  child: Text('See All activity',style: MyTheme.mediumBlackText,),
                ),
                title: 'My total funds',
                money: 0.00
              ),
              15.hGap,
              const MoneyDataBox(
                  title: 'On hold',
                  money: 0.00
              ),
              15.hGap,
              Text('My summaries',style: MyTheme.mediumBlackBoldText,),
              10.hGap,
              const SummariesItem(
                title: 'Last month total earnings',
                money: 176.44,
                time: 'May 2024',
              ),
              const SummariesItem(
                title: 'This year total earnings so far',
                money: 1031.30,
                time: '2024',
              ),
              const SummariesItem(
                title: 'All time total earnings',
                money: 1447.52,
              ),
              10.hGap,
              Text('My payout options',style: MyTheme.mediumBlackBoldText,),
              10.hGap,
              SummariesOptions(debitEnding: '0209',name: 'Ivan Lukin',),
              15.hGap,
              Center(
                child: BaseButton(
                  onPressed: () {

                  },
                  border: true,
                  width: 230,
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,size: 25,),
                      5.wGap,
                      Text('Add payment option',style: MyTheme.mediumBlackText,)
                    ],
                  )
                ),
              ),
              30.hGap,
              Text('My payout shedule',style: MyTheme.mediumBlackBoldText,),
              10.hGap,
              PayoutShedule(time: 'Weekly on Thursday')
            ],
          ),
        ),
      ),
    );
  }
}
