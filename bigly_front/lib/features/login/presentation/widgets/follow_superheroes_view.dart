
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';

import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class FollowSuperheroesView extends StatefulWidget {

  const FollowSuperheroesView({super.key});

  @override
  State<FollowSuperheroesView> createState() => _FollowSuperheroesViewState();
}

class _FollowSuperheroesViewState extends State<FollowSuperheroesView> {
  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Follow 5+ Superheroes',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'appFontBold',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                20.hGap,
                CupertinoSearchTextField(
                  controller: read.searchController,
                  onChanged: (value) async {
                    await read.getUsers(username: value);
                    setState(() {});
                  },
                ),

                20.hGap,

                Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await read.getUsers();
                    },
                    child: ListView.builder(
                      itemCount: read.users.length,
                      itemBuilder: (context, index) {
                        return UserItem(userModel: read.users[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonRectangular(
                onPressed: () {
                  read.register();
                  read.onNext(context, 8);
                },
                height: 45,
                width: double.infinity,
                text: 'Next',
              ),
              10.hGap,
              const Text(
                'The following is not required but recommended for a personalized experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'appFont',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {

  final read = context.read<LoginViewModel>();

    return GestureDetector(
      onTap: () {
        read.onTapUserItem(widget.userModel);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            AvatarWithSize(
              height: 50,
              width: 50,
              image: widget.userModel.profilePictureUrl,
            ),

            10.wGap,

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel.firstName ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userModel.username ?? '',
                  style: TextStyle(

                  ),
                ),
              ],
            ),
            Spacer(),
            Checkbox(
              onChanged: (value) {},
              side: const BorderSide(width: .5,color: Colors.grey),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),),
              value: widget.userModel.isChecked,
            ),
          ],
        ),
      ),
    );
  }
}

