
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/core/widgets/button_rectangular.dart';
import 'package:social_media_app/core/widgets/send_and_add_button_bar.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../constants/app_icons.dart';
import '../../../../../constants/constants.dart';
import '../../../../../core/theme/my_theme.dart';
import '../../../../../core/widgets/main_button.dart';
import '../../../../../core/widgets/swipe_button.dart';
import '../../view_model/create_video_msg_view_model.dart';

class CreateVideoMessagePage extends StatefulWidget {
  const CreateVideoMessagePage({super.key});

  @override
  State<CreateVideoMessagePage> createState() => _CreateVideoMessagePageState();
}

class _CreateVideoMessagePageState extends State<CreateVideoMessagePage> {

  late CreateVideoMsgViewModel videoRecordViewModel;


  @override
  void initState() {
    // videoRecordViewModel = context.read<CreateVideoMsgViewModel>();
    context.read<CreateVideoMsgViewModel>().initCamera();
    // videoRecordViewModel.initCamera();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    videoRecordViewModel = context.read<CreateVideoMsgViewModel>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    videoRecordViewModel.controller.dispose();
    videoRecordViewModel.disposePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<CreateVideoMsgViewModel>();
    final watch = context.watch<CreateVideoMsgViewModel>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(read.videoTime, style: const TextStyle(color: Colors.white),),
      ),
      body:
      (!watch.controller.value.isInitialized) ?
      const Center(
        child: Text(
          'No camera found ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ) :
      Stack(
        children: [
          Center(
            child: CameraPreview(
              read.controller,
            ),
          ),
          // const Align(
          //   alignment: Alignment.bottomCenter,
          //   child: RecordButton(),
          // ),



          if (!context.watch<CreateVideoMsgViewModel>().isComplete)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (context.watch<CreateVideoMsgViewModel>().isSwiped)
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 60),
                child: Wrap(
                    spacing: 7,
                    runSpacing: 10,
                    children: List.generate(context.watch<CreateVideoMsgViewModel>().tags.length, (index) =>  GestureDetector(
                      onTap: () {
                        context.read<CreateVideoMsgViewModel>().setTagIndex(index);
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: context.watch<CreateVideoMsgViewModel>().currentTagIndex==index?Colors.white:opacitiyWhite.withOpacity(.5),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 6),
                          child: Text(context.watch<CreateVideoMsgViewModel>().tags[index],style: MyTheme.mediumBlackText,),
                        ),
                      ),
                    )
                    )
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: .05.hp(context)),
                width: 200,
                child: SwipeButton(
                  width: 400,
                  height: 60,
                  thumbPadding: EdgeInsets.zero,
                  trackPadding: EdgeInsets.zero,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  thumb: context.watch<CreateVideoMsgViewModel>().isSwiped?
                  const SizedBox()
                      :const Center(
                    child: Icon(
                      CupertinoIcons.person_crop_circle,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  activeThumbColor: Colors.transparent,
                  activeTrackColor: Colors.grey.shade400,
                  onSwipe: () async {
                    read.onTapRecord(context, true);
                    // await context.read<CreateVideoMsgViewModel>().record();
                    // context.read<CreateVideoMsgViewModel>().changeSwiped(true);
                    setState(() {});

                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                    child: context.watch<CreateVideoMsgViewModel>().isSwiped?
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          // await context.read<CreateVideoMsgViewModel>().stop();
                          read.onTapRecord(context, false);
                          // read.changeSwiped(false);
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: SizedBox(
                              height: 65,
                              width: 56,
                              child: Icon(CupertinoIcons.person_crop_square,size: 50,color: Theme.of(context).colorScheme.primary,)
                          ),
                        ),
                      ),
                    )
                        :const SizedBox(),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),


      bottomNavigationBar: context.watch<CreateVideoMsgViewModel>().isComplete?
      ColoredBox(
        color: Colors.black,
        child: SafeArea(
          // height: 65,
          // width: double.infinity,
          child: SendAndAddButtonBar(
            onPressed0: () {},
            onPressed1: () {},
            onPressed2: () {
              read.addToContent(context);
            },

          )
        ),
      )
          :const SizedBox(height:65,child: ColoredBox(color: Colors.black,)),

    );
  }
}
