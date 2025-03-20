import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/create_section/create_image_message/view_model/create_image_message_view_model.dart';
import 'package:social_media_app/features/create_section/create_text_message/view_model/create_text_msg_view_model.dart';
import 'package:social_media_app/features/create_section/create_video_message/presentation/pages/create_video_message_page.dart';
import 'package:social_media_app/features/create_section/create_video_message/view_model/create_video_msg_view_model.dart';
import 'package:social_media_app/features/create_section/create_voice_message/view_model/create_voice_msg_view_model.dart';
import 'package:social_media_app/features/create_section/new_insight/view_model/new_insight_view_model.dart';
import 'package:social_media_app/features/team/add_members/view_model/add_member_view_model.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../constants/constants.dart';
import '../../view_model/add_to_view_model.dart';
import '../pages/add_to.dart';

class AddToBoxItem extends StatelessWidget {
  final int index;
  final bool isFirst;
  final AddToEnum? programState;
  final ContentPlanModel contentPlanModel;
  final AddToEnum? addToEnum;
  const AddToBoxItem({super.key,
    required this.index,
    required this.programState,
    this.isFirst = false,
    required this.contentPlanModel,
    this.addToEnum,
  });

  @override
  Widget build(BuildContext context) {

    final read = context.read<AddToViewModel>();
    final readVideo = context.read<NewInsightViewModel>();
    final readTextMessage = context.read<CreateTextMsgViewModel>();
    final readAudioMessage = context.read<CreateVoiceMsgViewModel>();
    final readImageMessage = context.read<CreateImageMessageViewModel>();
    final readVideoMessage = context.read<CreateVideoMsgViewModel>();

    return isFirst && !programState!.isAddMembers?
    //new plan container
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => read.showNewPlanScreen(context),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.6)
              ),
              child: Center(
                child: Text('New',style: Theme.of(context).textTheme.bodyLarge,),
              ),
            ),
          ),
        ),
        3.hGap,
        Text("New Content Plan",style: Theme.of(context).textTheme.bodyMedium,),
      ],
    ):
    //plan containers
    GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ContentModel? postModel;
                    print(addToEnum);
                    if (addToEnum != null) {
                      if (addToEnum!.isAdd) {
                        /// For video
                        if (readVideo.postModel != null) {
                          postModel = readVideo.postModel;
                        }
                        if (readTextMessage.contentModel != null) {
                          postModel = readTextMessage.contentModel;
                        }
                        if (readAudioMessage.contentModel != null) {
                          postModel = readAudioMessage.contentModel;
                        }
                        if (readImageMessage.contentModel != null) {
                          postModel = readImageMessage.contentModel;
                        }
                        if (readVideoMessage.contentModel != null) {
                          postModel = readVideoMessage.contentModel;
                        }
                        if (postModel != null) {
                          postModel.content_plan_id = contentPlanModel.id;
                          read.createPost(context, postModel);
                          readVideo.postModel = null;
                          readTextMessage.contentModel = null;
                          readAudioMessage.contentModel = null;
                          readImageMessage.contentModel = null;
                          readVideoMessage.contentModel = null;
                        }
                      } else if (addToEnum!.isManage) {
                        // print('START:');
                        // read.getContentPlan(contentPlanModel.id!);
                        context.push(RouteNames.posts, extra: contentPlanModel.id);
                      } else {
                        context.read<AddMemberViewModel>().getSubscribers(contentPlanModel.id!, contentPlanModel).then((value) {
                          context.pop();
                        },);
                      }
                    } else {
                      // context.push(RouteNames.posts, extra: 'Posts $index');
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image(
                          image: CachedNetworkImageProvider(contentPlanModel.bannerUrl!),
                          fit: BoxFit.cover,
                        ),
                        // child: Image.asset(AppImages.postImage,fit: BoxFit.cover,),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: opacitiyWhite,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                // child: BaseButton(
                                //     onPressed: () {
                                //
                                //     },
                                //     color: opacitiyWhite,
                                //     height: 30,
                                //     border: false,
                                //     padding: const EdgeInsets.symmetric(horizontal: 0),
                                //     child: DropdownButtonHideUnderline(
                                //       child: DropdownButton2<String>(
                                //         hint: Text(
                                //             context.watch<AddToViewModel>().selectedPriceType!,
                                //             style:Theme.of(context).textTheme.bodyLarge
                                //         ),
                                //         selectedItemBuilder: (context) => context.watch<AddToViewModel>().listEarning
                                //             .map((item) => DropdownMenuItem(
                                //           value: item,
                                //           child: SizedBox(
                                //             width: 78,
                                //             child: Padding(
                                //               padding: const EdgeInsets.only(left: 5),
                                //               child: Row(
                                //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //                 children: [
                                //                   Text(
                                //                     item,
                                //                     style:Theme.of(context).textTheme.bodyMedium,
                                //                   ),
                                //                   Icon(Icons.keyboard_arrow_down,size: 20,color: context.watch<AddToViewModel>().isSelectTime?Colors.white:Colors.black,)
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         ))
                                //             .toList(),
                                //         isExpanded: false,
                                //         iconStyleData: const IconStyleData(icon: SizedBox()),
                                //         value: context.watch<AddToViewModel>().selectedValue,
                                //         items: context.watch<AddToViewModel>().listEarning.map((e) => DropdownMenuItem(
                                //           value: e,
                                //           child: Text(
                                //             e,
                                //             style:Theme.of(context).textTheme.bodyMedium,
                                //           ),
                                //         )).toList(),
                                //         onChanged: (value)=> context.read<AddToViewModel>().updateSelectedValue(value),
                                //         buttonStyleData:  const ButtonStyleData(
                                //           padding:EdgeInsets.symmetric(horizontal: 0),
                                //           height: 35,
                                //           width: double.infinity,
                                //         ),
                                //         dropdownStyleData: DropdownStyleData(
                                //           maxHeight: 400,
                                //           width: 100,
                                //           padding: const EdgeInsets.symmetric(horizontal: 5),
                                //           decoration: BoxDecoration(
                                //               color: opacitiyWhite,
                                //               boxShadow: const [],
                                //               borderRadius: BorderRadius.circular(17)
                                //           ),
                                //         ),
                                //         menuItemStyleData: const MenuItemStyleData(
                                //             height: 40,
                                //             padding: EdgeInsets.zero
                                //         ),
                                //       ),
                                //     )
                                // ),
                              ),
                            ),
                            (!programState!.isAdd) && (!programState!.isAddMembers)?
                            GestureDetector(
                              onTap: () {
                                print(programState!.isAdd);
                                print(programState!.isAddMembers);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(Icons.more_horiz,color: Colors.white,size: 35,shadows: [Shadow(color: Colors.black,blurRadius: 2)],),
                              ),
                            )
                                :const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              3.hGap,
              // Text("Content Plan $index",style: Theme.of(context).textTheme.bodyMedium,),
              Text(contentPlanModel.name ?? '',style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
          // true?
          // Center(
          //   child: CircleAvatar(
          //     backgroundColor: opacitiyWhite,
          //     radius: 40,
          //     child: Icon(CupertinoIcons.checkmark_alt,color:Colors.black45,size: 50,),
          //   ),
          // )
          // :SizedBox()
        ],
      ),
    );
  }

}
