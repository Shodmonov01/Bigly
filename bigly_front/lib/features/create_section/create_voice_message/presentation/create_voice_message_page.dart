import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/constants.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/core/widgets/send_and_add_button_bar.dart';
import 'package:social_media_app/features/create_section/create_voice_message/presentation/widgets/wave_form_painter.dart';
import '../../../../constants/app_icons.dart';
import '../../../../core/widgets/swipe_button.dart';
import '../view_model/create_voice_msg_view_model.dart';

class CreateVoiceMessagePage extends StatefulWidget {
  const CreateVoiceMessagePage({super.key});

  @override
  State<CreateVoiceMessagePage> createState() => _CreateVoiceMessagePageState();
}

class _CreateVoiceMessagePageState extends State<CreateVoiceMessagePage> with TickerProviderStateMixin{

  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    context.read<CreateVoiceMsgViewModel>().initRecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<CreateVoiceMsgViewModel>();
    final watch = context.watch<CreateVoiceMsgViewModel>();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          read.disposePage();
        },);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: StreamBuilder(
            stream: watch.controller.onCurrentDuration,
            builder: (context, snapshot) {
              final durationSecond = snapshot.hasData ? Duration(seconds: snapshot.data!.inSeconds) : Duration.zero;
              final durationMinute = snapshot.hasData ? Duration(minutes: snapshot.data!.inMinutes) : Duration.zero;

              Duration duration = durationMinute + durationSecond;

              String twoDigits(int n) => n.toString().padLeft(2,'0');
              final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
              final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

              return Text(
                '$twoDigitMinutes:$twoDigitSeconds',
                style: MyTheme.mediumWhiteText,
              );

            },
          ),
          centerTitle: true,
          leading: const AppBarBackButton(iconColor: Colors.white,),
          actions: [
            IconButton(
              onPressed: () {
                context.pop(context);
              },
              icon: const Icon(Icons.close,color:Colors.white),
            )
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: ColoredBox(
                color: Colors.grey.shade400,
                child: Column(
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center ,
                        children: [
                          Icon(CupertinoIcons.mic_circle_fill,size: 390,color: Colors.white54,),
                          // 50.hGap
                        ],
                      ),
                    ),
                    !watch.isComplete?
                    SizedBox(
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children:[
                              const Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: WaveWidget()
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,top: 60),
                                child: FadeTransition(
                                  opacity: _controller,
                                  child: Wrap(
                                    spacing: 7,
                                    runSpacing: 10,
                                    children: List.generate(watch.tags.length, (index) =>  GestureDetector(
                                        onTap: () {
                                          read.setTagIndex(index);
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: watch.currentTagIndex==index?Colors.white:opacitiyWhite.withOpacity(.5),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 6),
                                            child: Text(watch.tags[index],style: MyTheme.mediumBlackText,),
                                          ),
                                        ),
                                       )
                                    )
                                  ),
                                ),
                              ),
                            ]
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: .05.hp(context)),
                              width: 200,
                              child: SwipeButton(
                                width: 400,
                                height: 60,
                                thumbPadding: EdgeInsets.zero,
                                trackPadding: EdgeInsets.zero,
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                thumb: watch.isSwiped?
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
                                  await read.record();
                                  read.changeSwiped(true);
                                  _controller.forward();
                                  setState(() {});

                                },
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: Colors.white),
                                    borderRadius: const BorderRadius.all(Radius.circular(35)),
                                  ),
                                  child: watch.isSwiped?
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: ()async {
                                        await read.stop();
                                        read.changeSwiped(false);
                                      },
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 2, color: Colors.white),
                                        ),
                                        child: SizedBox(
                                            height: 65,
                                            width: 56,
                                            child: Icon(CupertinoIcons.mic_fill,size: 50,color: Theme.of(context).colorScheme.primary,)
                                        ),
                                      ),
                                    ),
                                  )
                                      :const SizedBox(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        :const SizedBox(height: 220,),
                    10.hGap,
                  ],
                ),
              ),
            ),
            Center(
              child: watch.isCompleteIcon?
              const Icon(CupertinoIcons.check_mark_circled_solid,size: 130,color: Colors.white70,)
              :const SizedBox(),
            )
          ],
        ),
        bottomNavigationBar: watch.isComplete?
        ColoredBox(
          color: Colors.black,
          child: SafeArea(
            child: SendAndAddButtonBar(
              onPressed0: (){},
              onPressed1: (){},
              onPressed2: (){
                read.addToContent(context);
              },
            ),
          ),
        )
        :const SizedBox(height:65,child: ColoredBox(color: Colors.black,)),
      ),
    );
  }

}