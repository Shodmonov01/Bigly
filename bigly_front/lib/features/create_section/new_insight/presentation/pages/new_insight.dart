
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/widgets/open_camera_item.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/widgets/video_item.dart';
import 'package:social_media_app/features/create_section/new_insight/view_model/new_insight_view_model.dart';
import 'package:social_media_app/router/router.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/widgets/send_and_add_button_bar.dart';

class NewInsight extends StatefulWidget {
  const NewInsight({super.key,
    required this.newInsightParam,
  });

  final (NewInsightEnum, File?) newInsightParam;

  @override
  State<NewInsight> createState() => _NewInsightState();
}

class _NewInsightState extends State<NewInsight> {

  late NewInsightViewModel newInsightViewModel;
  late Stream stream;
  bool mediaFromAsset = true;

  @override
  void initState() {
    newInsightViewModel = context.read<NewInsightViewModel>();
    newInsightViewModel.initData(widget.newInsightParam.$2);
    stream = newInsightViewModel.fetchMedia();
    // stream = context.read<NewInsightViewModel>().fetchMedia(widget.newInsightParam.$2);
    // context.read<NewInsightViewModel>().fetchMedia(widget.newInsightParam.$2);
    super.initState();
  }

  @override
  void dispose() {
    // newInsightViewModel.disposeVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<NewInsightViewModel>();
    final watch = context.watch<NewInsightViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New insight'),
        actions: [
          if (widget.newInsightParam.$1.isSelectContent)
          ButtonCircular(
            onPressed: (){
              if (read.selectedVideFile == null) {

              } else {
                context.push(
                  RouteNames.videoView,
                  extra: read.selectedVideFile,
                );
              }
            },
            text: 'Next',
          ),
          10.wGap,
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Video player
          Expanded(
            child:
            (!watch.isSelectVideo) ?
            const Center(
              child: Text('Select video'),
            ) :
            Center(
              child:
              // (read.controller == null) ?
              // const Text('Select video22') :
              (!read.controller!.value.isInitialized) ?
              const Text('Select video33') :
              AspectRatio(
                aspectRatio: read.controller!.value.aspectRatio,
                child: VideoPlayer(read.controller!),
              ),
            ),
          ),

          if (widget.newInsightParam.$1.isEditContent)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: .5.hp(context),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: read.descriptionController,
                              maxLines: 10,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star),
                                  Text('Rewrite with AI'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: ListTile.divideTiles(
                            context: context,
                            tiles: [
                              ListTile(
                                onTap: (){
                                  read.onTapAddTag(context);
                                },
                                title: const Text('Add Tags'),
                                leading: const Icon(Icons.tag),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                              ListTile(
                                onTap: (){},
                                title: const Text('Add plan promotion banner'),
                                leading: const Icon(Icons.photo_size_select_actual_outlined),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                              ListTile(
                                onTap: (){
                                  read.onTapOtherSuperHeroes(context);
                                },
                                title: const Text('Tag other Superheroes'),
                                leading: const Icon(Icons.person_pin_outlined),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                              const SizedBox.shrink(),
                            ],
                          ).toList(),
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   height: 60,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: ButtonRectangular(
                    //           onPressed: (){},
                    //           text: 'Share',
                    //           subText: '(with Subscribers)',
                    //           icon: Image.asset(AppIcons.growSelect),
                    //           textStyle: const TextStyle(color: Colors.black),
                    //           subTextStyle: const TextStyle(fontSize: 8, color: Colors.black),
                    //         ).padding(const EdgeInsets.only(left: 10)),
                    //       ),
                    //       Expanded(
                    //         child: ButtonRectangular(
                    //           onPressed: (){},
                    //           text: 'Share',
                    //           subText: '(with Followers)',
                    //           icon: Image.asset(AppIcons.discoverSelect, width: 30,),
                    //           textStyle: const TextStyle(color: Colors.black),
                    //           subTextStyle: const TextStyle(fontSize: 7, color: Colors.black),
                    //           backgroundColor: Colors.grey,
                    //         ).padding(const EdgeInsets.symmetric(horizontal: 10)),
                    //       ),
                    //       ButtonCircular(
                    //         onPressed: (){
                    //           context.push(
                    //             RouteNames.contentPlan,
                    //             extra: AddToEnum.added
                    //           );
                    //         },
                    //         text: 'Add',
                    //         textStyle: const TextStyle(color: Colors.black),
                    //         icon: const Icon(Icons.arrow_right_alt, color: Colors.black,),
                    //         backgroundColor: Colors.grey,
                    //       ).padding(const EdgeInsets.only(right: 10)),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              // if (watch.showAddTagDialog)
              // const AddTags(),
            ],
          ),


          /// Select category
          if (widget.newInsightParam.$1.isSelectContent)
          Row(
            children: [
              GroupButton(
                controller: read.groupButtonController,
                onSelected: (value, index, isSelected) {
                  if (index == 0) {
                    mediaFromAsset = true;
                    stream = newInsightViewModel.fetchMedia();
                  } else {
                    mediaFromAsset = false;
                    stream = newInsightViewModel.fetchDraft();
                  }
                  setState(() {});
                },
                buttonBuilder: (selected, value, context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: selected ? Colors.black : Colors.grey,
                      ),
                    ),
                  );
                },
                buttons: const ["Recents", "Drafts"],
              ).padding(const EdgeInsets.all(10)),
              // const Spacer(),
              // IconButton(
              //   onPressed: (){
              //     read.chooseVideo();
              //   },
              //   icon: const Icon(Icons.folder_open),
              // ),
            ],
          ),

          /// Videos gridview
          if (widget.newInsightParam.$1.isSelectContent)
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {

              List<AssetEntity> videosFromAsset = [];
              List<FileSystemEntity> videosFromDraw = [];
              int itemCount = 0;
              bool isRecent = read.groupButtonController.selectedIndex == 0;

              if (snapshot.hasData) {
                if (mediaFromAsset) {
                  videosFromAsset = snapshot.data;
                  itemCount = videosFromAsset.length;
                } else {
                  videosFromDraw = snapshot.data;
                  itemCount = videosFromDraw.length;

                }
              } else if (isRecent) {
                // itemCount = 1;
              } else {
                // itemCount = 0;
              }

              if (read.groupButtonController.selectedIndex == 0) {
                itemCount++;
              }

              return SizedBox(
                height: .4.hp(context),
                child: GridView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if ((index == 0) && (read.groupButtonController.selectedIndex == 0)) {
                      return const OpenCameraItem();
                    }
                    if (read.groupButtonController.selectedIndex == 0) {
                      return VideoItem(index: index - 1);
                    } else {
                      return VideoItem(index: index);
                    }
                  },
                ),
              );
            }
          ),

        ],
      ),

      bottomNavigationBar: (widget.newInsightParam.$1 == NewInsightEnum.editContent) ?
        SafeArea(
        child: SendAndAddButtonBar(
          onPressed0: (){},

          onPressed1: (){},
          backgroundColor1: Colors.grey.shade400,

          onPressed2: () async {
            await read.createPost();
            context.push(
              RouteNames.contentPlan,
              extra: AddToEnum.add,
            );
          },
          backgroundColor2: Colors.grey.shade400,
        ),
      ) : null,
    ).loadingView(watch.isLoading);
  }
}

enum NewInsightEnum {
  selectContent,
  editContent,
}

extension NewInsightEnumEx on NewInsightEnum {
  bool get isSelectContent => NewInsightEnum.selectContent == this;
  bool get isEditContent => NewInsightEnum.editContent == this;
}
