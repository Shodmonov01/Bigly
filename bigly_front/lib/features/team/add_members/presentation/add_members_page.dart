import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/features/team/add_members/presentation/widgets/add_to_small_box.dart';
import 'package:social_media_app/features/team/add_members/presentation/widgets/user_item.dart';
import 'package:social_media_app/features/team/add_members/view_model/add_member_view_model.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/button_circular.dart';
import '../../contacts/presentation/widgets/contact_item.dart';
import '../../contacts/presentation/widgets/item_container.dart';
import '../../contacts/view_model/contacts_view_model.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({super.key});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {

  @override
  void initState() {
    context.read<AddMemberViewModel>().getUsers();
    super.initState();
  }

  @override
  void dispose() {
    context.read<AddMemberViewModel>().getUsers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<AddMemberViewModel>();
    final watch = context.watch<AddMemberViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text("Add Members"),
        actions: [
          ButtonCircular(
            onPressed: (watch.selectedUsers.isEmpty) ?
            null : (){
              context.push(RouteNames.createGroup);
            },
            text: 'Next',
            backgroundColor: (watch.selectedUsers.isEmpty) ?
            Colors.grey : Colors.orange,
          ),
          10.wGap,
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              GestureDetector(
                onTap: () => context.push(
                  RouteNames.addTo,
                  extra: AddToEnum.addMembers,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_view_month,size: 20,),
                            10.wGap,
                            Text('Add all Subscribers from a plan',style: MyTheme.mediumBlackText,)
                          ],
                        ),
                        const Icon(Icons.chevron_right_outlined,size: 25,)
                      ],
                    ),
                  ),
                ),
              ),
              7.hGap,

              if (read.selectedContentPlans.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image(
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(read.selectedContentPlans.first.bannerUrl!),
                          ),

                          Container(
                            height: 20,
                            width: 80,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.8),
                                borderRadius: BorderRadius.circular(45)
                            ),
                            child: Center(
                              child:
                              (read.selectedContentPlans.first.price_type == 'free') ?
                              const Text('FREE',
                                style: TextStyle(fontSize: 12),
                              ) :
                              Text('\$${read.selectedContentPlans.first.price}/${read.selectedContentPlans.first.price_type!}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(read.selectedContentPlans.first.name!),
                  ],
                ),

              7.hGap,
              false ? Wrap(
                children: [
                  AddToSmallBox(),
                ],
              ):
              // GridView.builder(
              //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     maxCrossAxisExtent: 100,
              //     mainAxisSpacing: 120
              //   ),
              //   padding:EdgeInsets.zero,
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   scrollDirection: Axis.vertical,
              //   itemBuilder: (context, index) => AddToSmallBox(),
              // ):
              const SizedBox(),
              DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  border: Border.all(width: .3,color: Colors.grey)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.search,size: 19,color: Colors.grey,),
                      5.wGap,
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                context.read<AddMemberViewModel>().searchUsers(value);
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400),
                                hintText: 'Search by name or @username',
                              ),
                            ),
                            if (read.isLoading)
                              const LinearProgressIndicator().padding(
                                const EdgeInsets.only(top: 5),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: context.watch<AddMemberViewModel>().contactsWithLetter.map((e) {
                  return ItemContainer(
                    text: e.letter,
                    child: Column(
                      children: [
                        ...List.generate(e.users.length, (index) {
                          return UserItem(userModel: e.users[index], );
                        },),
                      ],
                    ),
                  );
                },).toList(),
              ),
              // ItemContainer(
              //   text: 'A',
              //   child: Column(
              //     children: [
              //       ...List.generate(7, (index) {
              //         return ContactItem(image: AppImages.postImage,enableCheckBox: false,);
              //       },)
              //     ],
              //   ),
              // ),
              // ItemContainer(
              //   text: 'B',
              //   child: Column(
              //     children: [
              //       ...List.generate(4, (index) {
              //         return ContactItem(image: AppImages.avatar,enableCheckBox: true,);
              //       },)
              //     ],
              //   ),
              // ),
              10.hGap,
            ],
          ),
        ),
      ),
    );
  }
}
