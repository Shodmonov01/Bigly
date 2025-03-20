import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/features/team/contacts/presentation/widgets/contact_item.dart';
import 'package:social_media_app/features/team/contacts/presentation/widgets/item_container.dart';
import 'package:social_media_app/features/team/contacts/presentation/widgets/navigator_item.dart';
import 'package:social_media_app/features/team/contacts/view_model/contacts_view_model.dart';

import '../../../../constants/app_images.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {

  @override
  void initState() {
    context.read<ContactsViewModel>().getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<ContactsViewModel>();
    final watch = context.watch<ContactsViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text("New Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CupertinoSearchTextField(
              controller: read.searchEditingController,
              onChanged: (value) {
                read.searchUsers(value);
              },
              placeholder: 'Search by name or @username',
            ),

            if (read.isLoading)
            const LinearProgressIndicator().padding(
              const EdgeInsets.only(top: 5),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15,),
                    ItemContainer(
                      child: Column(
                        children: [
                          ...List.generate(context.watch<ContactsViewModel>().navigators.length, (index) {
                            return NavigatorItem(
                              model: context.watch<ContactsViewModel>().navigators[index],
                              isEnd: context.watch<ContactsViewModel>().navigators.length==index+1,
                            );
                          },)
                        ],
                      ),
                    ),
                    // ItemContainer(
                    //   text: 'Pinned Contacts',
                    //   child: Column(
                    //     children: [
                    //       ...List.generate(context.watch<ContactsViewModel>().navigators.length, (index) {
                    //         return ContactItem(image: AppImages.profileAd,);
                    //       },)
                    //     ],
                    //   ),
                    // ),

                    SafeArea(
                      // child: ListView.builder(
                      //   itemCount: read.contactsWithLetter.length,
                      //   physics: NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     return ItemContainer(
                      //       text: read.contactsWithLetter[index].letter,
                      //       child: Column(
                      //         children: [
                      //           ...List.generate(read.contactsWithLetter[index].users.length, (index) {
                      //             return ContactItem(userModel: read.contactsWithLetter[index].users[index], );
                      //             },),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      child: Column(
                        children: context.read<ContactsViewModel>().contactsWithLetter.map((e) {
                          return ItemContainer(
                            text: e.letter,
                            child: Column(
                              children: [
                                ...List.generate(e.users.length, (index) {
                                  return ContactItem(userModel: e.users[index], );
                                },),
                              ],
                            ),
                          );
                        },).toList(),
                      ),
                    ),

                    // ItemContainer(
                    //   text: 'A',
                    //   child: Column(
                    //     children: [
                    //       ...List.generate(7, (index) {
                    //         return ContactItem(image: AppImages.postImage,);
                    //       },)
                    //     ],
                    //   ),
                    // ),
                    // ItemContainer(
                    //   text: 'B',
                    //   child: Column(
                    //     children: [
                    //       ...List.generate(4, (index) {
                    //         return ContactItem(image: AppImages.avatar,);
                    //       },)
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
