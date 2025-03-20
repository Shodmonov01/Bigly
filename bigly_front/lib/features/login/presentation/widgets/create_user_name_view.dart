
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/core/widgets/button_rectangular.dart';

import '../../view_model/login_view_model.dart';

class CreateUserNameView extends StatelessWidget {
  const CreateUserNameView({super.key});

  @override
  Widget build(BuildContext context) {
    final read = context.read<LoginViewModel>();
    final watch = context.watch<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            read.onNext(context, 0);
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
                'Create username',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'appFontBold',
                  fontWeight: FontWeight.w900,
                )
              ),
              20.hGap,
              Text(
                'Create username for your new account.\nYou can change it later.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color:
                    Colors.grey[600],
                  letterSpacing: .5
                )
              ),

              20.hGap,

              TextFormField(
                controller: read.userNameController,
                onChanged: (text) {
                  read.checkUserName(text);
                },
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    fontFamily: 'appFont',
                  ),
                ),
                cursorColor: Colors.blue,
              ),
              /// Check username
              if (watch.isUserNameAvailable != null)
              (watch.isUserNameAvailable!) ?
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username "${watch.userNameController.text}" is available',
                  style: TextStyle(
                    color: Colors.green.shade700,
                  ),
                ),
              ) :
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username "${watch.userNameController.text}" is not available',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
        // else
        //         Align(
        //           alignment: Alignment.centerLeft,
        //           child: Text(
        //             'Username "${watch.userNameController.text}" is not available',
        //             style: const TextStyle(
        //               color: Colors.red,
        //             ),
        //           ),
        //         ),

              /// Suggestions
              10.hGap,

              if (watch.suggestions != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: double.infinity,),
                  const Text('Suggestions:'),
                  Wrap(
                    children: read.suggestions!.map((text) {
                      return InkWell(
                        onTap: (){
                          read.onTapSuggestionItem = text;
                        },
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ).padding(const EdgeInsets.only(right: 10));
                    },).toList(),
                  ),
                ],
              ),

              20.hGap,

              ButtonRectangular(
                onPressed: (){
                  if (read.userNameController.text.isEmpty) return;
                  if (read.isUserNameAvailable != null) {
                    if (read.isUserNameAvailable!) {
                      read.onNext(context, 2);
                    }
                  }
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
