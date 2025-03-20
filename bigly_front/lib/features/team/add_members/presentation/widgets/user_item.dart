
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/features/team/add_members/view_model/add_member_view_model.dart';

import '../../../../../core/data/models/user_model.dart';
import '../../../../../core/theme/my_theme.dart';
import '../../../../../core/widgets/avatar_with_size.dart';
import '../../../contacts/view_model/contacts_view_model.dart';

class UserItem extends StatefulWidget {
  const UserItem({super.key, required this.userModel, this.enableCheckBox = false, this.isLastItem = false});
  final bool enableCheckBox;
  final UserModel userModel;
  final bool isLastItem;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {

    final read = context.read<AddMemberViewModel>();

    return GestureDetector(
      onTap: (){
        read.onTapUserItem(widget.userModel);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            AvatarWithSize(image: widget.userModel.profilePictureUrl , radius: 22),
            10.wGap,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  7.hGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.userModel.firstName!, style: MyTheme.largeBlackText),
                          Text('@${widget.userModel.username}', style: MyTheme.smallGreyText,),
                        ],
                      ),
                      // enableCheckBox!=null?
                      Checkbox(
                        onChanged: (value) {},
                        value: widget.userModel.isChecked,
                        // value: enableCheckBox,
                        side: const BorderSide(width: .5,color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),),
                      )
                          // :const SizedBox.shrink()
                    ],
                  ),

                  Container(
                    width: double.infinity,
                    color: Colors.black54,
                    height: .4,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}