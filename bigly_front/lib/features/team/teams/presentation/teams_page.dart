import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/team/teams/presentation/widgets/chat_item.dart';
import 'package:social_media_app/router/router.dart';
import '../view_model/teams_view_model.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {


@override
  void initState() {
    // context.read<TeamsViewModel>().isAllChat=true;
    // context.read<TeamsViewModel>().getChats();
    context.read<TeamsViewModel>().initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<TeamsViewModel>();
    final watch = context.watch<TeamsViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Team'),
        leading: IconButton(
          onPressed: () {
            // read.getChat();
            // read.getChats();
            read.showSettingsScreen(context);
          },
          icon: const Icon(Icons.settings),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouteNames.contacts).then((value) {
                read.getChats();
              },);
            },
            icon: const  Icon(CupertinoIcons.add_circled,size: 28,),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(.8),
          child: Divider(height: 0,color: Colors.grey[300],),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await read.getChats();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GroupButton(
                      options: const GroupButtonOptions(
                        direction: Axis.horizontal,
                        groupingType: GroupingType.row,
                      ),
                      buttons: const ['All', 'Unread','Superheros','Subscribers', 'Followers','Groups','Pinned'],
                      controller: watch.groupButtonController,
                      isRadio: true,
                      buttonBuilder: (selected, value, context) {
                        if (value == 'Unread') {
                          return Stack(
                            children: [
                              Container(
                                height: 30,
                                margin: const EdgeInsets.only(top: 10,right: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 5),
                                decoration: BoxDecoration(
                                  color: selected ? Colors.blue.withOpacity(.5) : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  'Unread',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: -1.3,
                              //   right: 0,
                              //   child: Container(
                              //     padding: const EdgeInsets.all(4),
                              //     decoration: BoxDecoration(
                              //       color: Theme.of(context).colorScheme.primary,
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Text(
                              //       '5', // Replace with the desired number
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 13,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        } else {
                          return Container(
                            height: 30,
                            margin: const EdgeInsets.only(top: 10,right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                            decoration: BoxDecoration(
                              color: selected ? Colors.blue.withOpacity(.6) : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              value,
                              style: const TextStyle(
                                color:Colors.black,
                              ),
                            ),
                          );
                        }
                      },
                      onSelected: (value,index, isSelected) {
                        read.changeChat(index,value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            10.hGap,
            Expanded(
              child: ListView.builder(
                itemCount: watch.getChatsLength,
                itemBuilder: (context, index) {
                  int selectedIndex = watch.groupButtonController.selectedIndex ?? 0;
                  return selectedIndex == 0 ?
                  ChatItem(chatModel: watch.chats[index]):

                  selectedIndex == 2 ?
                  ChatItem(chatModel: watch.chatsSuperhero[index]):

                  selectedIndex == 3 ?
                  ChatItem(chatModel: watch.chatsSubscriber[index]):

                  selectedIndex == 4 ?
                  ChatItem(chatModel: watch.chatsFollower[index]):

                  selectedIndex == 5 ?
                  ChatItem(chatModel: watch.chatsGroup[index]):
                  const SizedBox();

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

