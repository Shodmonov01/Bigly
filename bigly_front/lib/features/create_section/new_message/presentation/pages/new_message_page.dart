
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../core/widgets/icon_with_backgeound.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({super.key});

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Create new message'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interact with your audience in a fully automated and personalized way. Like a true Superhero.'
          ).padding(const EdgeInsets.all(20)),
          Expanded(
            child: Center(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 30
                ),
                children: [
                  IconButtonWithBackground(
                    onTap: () {
                      context.push(RouteNames.createVideoMessage);
                    },
                    label: 'Create video message',
                    height: 80,
                    width: 80,
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade800,),
                    color: Colors.grey[300],
                  ),
                  IconButtonWithBackground(
                    onTap: () {
                      context.push(RouteNames.createVoiceMessage);
                    },
                    label: 'Create a voice message',
                    height: 80,
                    width: 80,
                    icon: Icon(Icons.settings_voice_outlined, color: Colors.grey.shade800,),
                    color: Colors.grey[300],
                  ),
                  IconButtonWithBackground(
                    onTap: () {
                      context.push(RouteNames.createImageMessage);
                    },
                    label: 'Create a photo message',
                    height: 80,
                    width: 80,
                    icon: Icon(Icons.image_outlined, color: Colors.grey.shade800,),
                    color: Colors.grey[300],
                  ),
                  IconButtonWithBackground(
                    onTap: () {
                      context.push(RouteNames.createTextMessage);
                    },
                    label: 'Create a text message',
                    height: 80,
                    width: 80,
                    icon: Icon(Icons.textsms_outlined, color: Colors.grey.shade800,),
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
