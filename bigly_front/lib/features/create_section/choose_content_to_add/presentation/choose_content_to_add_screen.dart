import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/core/widgets/base_button.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/presentation/widgets/video_item.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/presentation/widgets/message_item.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/create_section/posts/view_model/posts_view_model.dart';

import '../../../../core/theme/my_theme.dart';
import '../../../../core/widgets/button_circular.dart';

class ChooseContentToAdd extends StatefulWidget {
  const ChooseContentToAdd({super.key});

  @override
  State<ChooseContentToAdd> createState() => _ChooseContentToAddState();
}

class _ChooseContentToAddState extends State<ChooseContentToAdd> {

  @override
  void initState() {
    context.read<ChooseContentToViewModel>().getMessages();
    context.read<ChooseContentToViewModel>().getContents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<ChooseContentToViewModel>();
    final watch = context.watch<ChooseContentToViewModel>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const AppBarBackButton(),
            title: const Text("Choose Content To Add"),
            actions: [
              if (watch.videoCheckEnable || watch.messageCheckEnable)
              ButtonCircular(
                onPressed: () async {
                  int id = context.read<PostsViewModel>().contentPlan!.id!;
                  await read.addContent(id);
                  context.pop(context);
                },
                text: 'Add',
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BaseButton(
                            height: 30,
                            onPressed: () {
                              read.changeContentType(0);
                            },
                            border: false,
                            color: watch.currentPageIndex==0?Colors.black:Colors.grey.shade100,
                            child: Text('Videos',style: watch.currentPageIndex==0?MyTheme.bodyMediumWhiteText:MyTheme.bodyMediumGreyText,),
                          ),
                          10.wGap,
                          BaseButton(
                            height: 30,
                            onPressed: () {
                              read.changeContentType(1);
                            },
                            border: false,
                            color: watch.currentPageIndex==1?Colors.black:Colors.grey.shade100,
                            child: Text('Messages',style: watch.currentPageIndex==1?MyTheme.bodyMediumWhiteText:MyTheme.bodyMediumGreyText,),
                          )
                        ],
                      ),
                    ),
                    if (watch.videoCheckEnable || watch.messageCheckEnable)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          read.deleteContent(context);
                        },
                        icon: const Icon(CupertinoIcons.delete_solid),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: watch.pageController,
                  children: [
                    GridView.builder(
                        itemCount: watch.contents.length + 1,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .6,
                          // maxCrossAxisExtent: 200,
                          // mainAxisExtent: 220,
                          // mainAxisSpacing: 1,
                          // crossAxisSpacing: 1
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return VideoItem(isFirst: index == 0, index: index,);
                          } else {
                            return VideoItem(isFirst: false, index: index - 1, contentModel: read.contents[index - 1],);
                          }
                        }
                    ),
                    GridView.builder(
                        itemCount: watch.messages.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: .6
                          // maxCrossAxisExtent: 200,
                          // mainAxisExtent: 220,
                          // mainAxisSpacing: 1,
                          // crossAxisSpacing: 1
                        ),
                        itemBuilder: (context, index) {
                          return MessageItem(contentModel: watch.messages[index],index: index);
                        }
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
        if (watch.isShowContentWidget)
          read.showContentWidget(context, read.selectedContent),
      ],
    );
  }
}
