
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

import '../../../../core/widgets/button_rectangular.dart';
import '../../view_model/login_view_model.dart';

class CreateAgeView extends StatelessWidget {
  const CreateAgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            read.onNext(context, 3);
          },
          icon: const Icon(CupertinoIcons.left_chevron),
        ),
      ),

      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Your age',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'appFontBold',
                  fontWeight: FontWeight.w900,
                ),
              ),
              20.hGap,

              Text(
                'Bigly is not permitted for usersn\nunder 13 years old.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  letterSpacing: .5,
                ),
              ),
              20.hGap,

              TextFormField(
                controller: read.birthDayController,
                readOnly: true,
                onTap: (){
                  read.onSelectBirthDay(context);
                },
                decoration: const InputDecoration(
                  hintText: 'Your birth date',
                  hintStyle: TextStyle(
                    fontFamily: 'appFont',
                  )
                ),
                cursorColor: Colors.blue,
              ),

              20.hGap,

              ButtonRectangular(
                onPressed: (){
                  if (read.selectedBirthDay.isEmpty) return;
                  read.onNext(context, 5);
                },
                height: 45,
                width: double.infinity,
                text: 'Next',
              ),

            ],
          ),
        ),
      ),
    );
  }
}
