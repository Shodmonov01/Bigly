
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/features/team/teams/view_model/teams_view_model.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../core/widgets/avatar_with_size.dart';
import '../../../../../core/data/models/chat_model.dart';
import '../../../../../core/widgets/confirm_dialog.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {

    final read = context.read<TeamsViewModel>();

    return  InkWell(
      onTap: () {
        context.push(RouteNames.chat, extra: chatModel.id).then((value) {
          read.getChats();
        },);
      },
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              padding: EdgeInsets.zero,
              onPressed: (context) async {
                bool? isYes = await confirmDialog(
                  context,
                  title: 'Delete Chat',
                  content: 'Are you sure you want to delete this chat?',
                );
                if (isYes != null) {
                  read.deleteChat(chatModel.id ?? 0);
                }
              },
              backgroundColor: Colors.redAccent,
              icon: CupertinoIcons.delete,
              label: 'Delete',
              foregroundColor: Colors.white,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 90,
          width: double.infinity,
          child: Row(
            children: [
              Stack(
                children: [
                  AvatarWithSize(
                    image: chatModel.image ?? '',
                    height: 50,
                    width: 50,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border:Border.all(
                          color: Colors.grey,
                          width:.4,
                        ) ,
                      ),
                      child: Icon(
                        chatModel.chatIcon,
                        size: 12,
                        color: Colors.orange,
                      )
                    ),
                  )
                ],
              ),
              10.wGap,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: .8.wp(context),
                      height: .8,
                      color: Colors.grey[300],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        // Text('14:04 AM', style: MyTheme.bodyMediumGreyText),
                        // Text(chatModel.lastMessageModel.created_at.toString().getTimeFromTimeStamp, style: MyTheme.bodyMediumGreyText),
                        // Text(chatModel.lastMessageModel!.created_at.toString().getTimeFromTimeStamp, style: MyTheme.bodyMediumGreyText),
                        Text(chatModel.lastMessageTime, style: MyTheme.bodyMediumGreyText),
                      ],
                    ),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            // width: MediaQuery.of(context).size.width - 100, // Adjust width to prevent overflow
                            width: .65.wp(context),
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(text: chatModel.name, style: MyTheme.mediumBlackBoldText),
                                  // TextSpan(text: ' (Your GYM Coach)', style: MyTheme.smallBlackBoldText),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                // width: MediaQuery.of(context).size.width - 110,
                                width: .65.wp(context),
                                child: Text(chatModel.lastMessageText),
                                // (chatModel.lastMessage != null) ?
                                // Text(
                                //   chatModel.lastMessageModel?.content ?? '',
                                //   style: MyTheme.bodyMediumGreyText,
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis, // Use ellipsis instead of visible for overflow
                                // ) : Text(
                                //     chatModel.lastMessageModel?.media_type ?? ''
                                // ),
                              ),
                              chatModel.new_message_count != 0?
                              Container(
                                height: .07.wp(context),
                                width: .07.wp(context),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                // padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    (chatModel.new_message_count! > 99) ?
                                    '99+' :
                                    '${chatModel.new_message_count}'.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ) :
                              const SizedBox()
                            ],
                          )
                        ],
                      ),
                    ),

                    Container(
                      width: .8.wp(context),
                      height: .8,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

