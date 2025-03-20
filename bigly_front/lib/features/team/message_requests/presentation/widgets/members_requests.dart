
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';
import 'package:social_media_app/features/team/message_requests/view_model/message_request_view_model.dart';

class MembersRequests extends StatelessWidget {
  final ChatModel chatModel;
  const MembersRequests({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {

    final read = context.read<MessageRequestViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                read.acceptRequest(context, chatModel.id!);
              },
              backgroundColor: Colors.grey.shade50,
              label: 'Reply',
              padding: EdgeInsets.zero,
            ),
            SlidableAction(
              onPressed: (context) {

              },
              backgroundColor: Colors.grey.shade100,
              label: 'Block',
              padding: EdgeInsets.zero,
            ),
            SlidableAction(
              padding: EdgeInsets.zero,
              onPressed: (context) {

              },
              backgroundColor: Colors.redAccent,
              label: 'Delete',
              foregroundColor: Colors.black,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AvatarWithSize(
                  image: chatModel.image,
                  height: 55,
                  width: 55,
                  borderColor: Colors.grey,
                  borderWidth: .3,
                ),
                10.wGap,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(chatModel.name!),
                    Text(chatModel.lastMessageText, style: const TextStyle(color: Colors.grey),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
