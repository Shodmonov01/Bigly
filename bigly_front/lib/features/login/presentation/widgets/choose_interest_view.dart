
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class ChooseInterestView extends StatefulWidget {
  const ChooseInterestView({super.key});

  @override
  State<ChooseInterestView> createState() => _ChooseInterestViewState();
}

class _ChooseInterestViewState extends State<ChooseInterestView> {

  @override
  void initState() {
    context.read<LoginViewModel>().listSelect = List.generate(14, (index) => false,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            context.read<LoginViewModel>().pageController.jumpToPage(5);
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),

      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                  'Your interest',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'appFontBold',
                    fontWeight: FontWeight.w900,
                  )
              ),
              20.hGap,
              Text(
                'Choose up to 10 main interests of yours.\nYou can change it later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  letterSpacing: .5,
                ),
              ),

              20.hGap,

              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                  ),
                  cursorColor: Colors.blue,
                ),
              ),

              100.hGap,

              Text(
                'Or pick from the trending interests among other users',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: .5,
                ),
              ),
              20.hGap,
              Wrap(
                children: read.interestList.map((text) {
                  return item(text);
                },).toList(),
              ),

              20.hGap,

              ButtonRectangular(
                onPressed: (){
                  read.getUsers();
                  read.onNext(context, 7);
                  // context.read<LoginViewModel>().pageController.jumpToPage(7);
                },
                height: 45,
                width: double.infinity,
                text: 'Next',
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget item(String text) {
    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();
    int index = read.interestList.indexOf(text);
    return GestureDetector(
      onTap: () {
        read.onTapInterestItem(index, text);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          color:
          (watch.listSelect[index]) ?
          Colors.grey.shade200 :
          Colors.grey.shade400 ,
        ),
        child: Text(text),
      ),
    );
  }

}
