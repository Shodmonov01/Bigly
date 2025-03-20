import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/avatar_with_radius.dart';
import 'package:social_media_app/core/widgets/avatar_with_size.dart';
import 'package:social_media_app/features/team/contacts/view_model/contacts_view_model.dart';

import '../../../../../core/theme/my_theme.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, required this.userModel, this.enableCheckBox, this.isLastItem = false});
  final bool? enableCheckBox;
  final UserModel userModel;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {

    final read = context.read<ContactsViewModel>();

    return GestureDetector(
      onTap: (){
        read.createChat(context, userModel.username!);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            AvatarWithSize(image: userModel.profilePictureUrl , radius: 22),
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
                          Text(userModel.firstName!, style: MyTheme.largeBlackText),
                          Text('@${userModel.username}', style: MyTheme.smallGreyText,),
                        ],
                      ),
                      enableCheckBox!=null?
                      Checkbox(
                        onChanged: (value) {
                        },
                        value: enableCheckBox ?? false,
                        side: const BorderSide(width: .5,color: Colors.grey),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),),
                      )
                        :const SizedBox.shrink()
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
