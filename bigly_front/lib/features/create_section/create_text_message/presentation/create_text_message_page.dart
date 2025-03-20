import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/core/widgets/button_rectangular.dart';

import '../../../../constants/app_icons.dart';
import '../../../../core/theme/my_theme.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/send_and_add_button_bar.dart';
import '../view_model/create_text_msg_view_model.dart';

class CreateTextMessagePage extends StatefulWidget {
  const CreateTextMessagePage({super.key});

  @override
  State<CreateTextMessagePage> createState() => _CreateTextMessagePageState();
}

class _CreateTextMessagePageState extends State<CreateTextMessagePage> {
  @override
  Widget build(BuildContext context) {

    final read = context.read<CreateTextMsgViewModel>();
    final watch = context.watch<CreateTextMsgViewModel>();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => read.disposePage(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading:
            watch.next ?
            IconButton(
              onPressed: () {
                read.next = false;
                setState(() {});
              },
              icon: const Icon(
                CupertinoIcons.left_chevron,
                color:Colors.white,
              ),
            ) : const SizedBox(),
            actions: [
              IconButton(
                onPressed: () {
                  context.pop(context);
                },
                icon: const Icon(Icons.close,color:Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          body: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: read.isOpenField?BorderRadius.circular(0):BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: 1.wp(context),
              height: 1.hp(context),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: watch.next?
                Center(
                  child: SingleChildScrollView(child: Text(watch.textController.text, style: MyTheme.largeBlackText,))
                )
                :Column(
                  mainAxisAlignment: read.isOpenField?MainAxisAlignment.spaceBetween:MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                        10.wGap,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'When you see the word "NAME" with all four letters in uppercase , it will be automaticaly replaced with the name of each individual recipiend.',
                                style: TextStyle(color: Colors.grey,fontSize: 17,fontWeight: FontWeight.w500),
                                maxLines: 4,
                              ),
                              5.hGap,
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(width: .7,color: Colors.grey)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: .7,color: Colors.grey),
                                            shape: BoxShape.circle
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(3.0),
                                          child: Icon(CupertinoIcons.person,size: 20,),
                                        ),
                                      ),
                                      3.wGap,
                                      Text('Use it for me!',style: MyTheme.smallGreyText,)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: read.isOpenField?MainAxisAlignment.end:MainAxisAlignment.center,
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: const Border.symmetric(vertical: BorderSide(color: Colors.grey,width: .8),horizontal: BorderSide(color: Colors.grey,width: .8))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0,right:8,),
                            child: Column(
                              children: [
                                TextField(
                                  minLines: 1,
                                  maxLines: 7,
                                  onChanged: (value) {
                                    if (value.contains('NAME')) {
                                      read.textController.text = value.replaceAll('NAME', AppRemoteData.userModel!.firstName!);
                                    }
                                  },
                                  controller: watch.textController,
                                  onTap: () => read.changeFieldState(true),
                                  onTapOutside: (event) {
                                    read.changeFieldState(false);
                                    context.unFocus;
                                  },
                                  // style: TextStyle(),
                                  decoration: const InputDecoration(
                                    filled: false,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    hintText: 'Create Text Message',
                                  ),
                                ).padding(const EdgeInsets.all(10)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(width: .7,color: Colors.grey)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppIcons.growSelect,
                                              height: 20,
                                            ),
                                            3.wGap,
                                            Text('Rewrite with AI',style: MyTheme.smallGreyText,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      height: 16,
                                      minWidth: 16,
                                      elevation: 0,
                                      padding: const EdgeInsets.all(5),
                                      onPressed: () =>read.changeNextState(true),
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                      child: const Icon(Icons.arrow_forward_outlined,color: Colors.white,),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    if (!read.isOpenField)const SizedBox()
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar:
          watch.isComplete ?
          ColoredBox(
            color: Colors.black,
            child: SendAndAddButtonBar(
              onPressed0: (){},
              onPressed1: (){},
              onPressed2: (){
                read.addToContent(context);
              },
            ),
          ) :
          const SizedBox(
            height:65,
            child: ColoredBox(color: Colors.black,),
          ),
        ),
      ),
    );
  }
}
