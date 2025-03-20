import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMsgView extends StatelessWidget {
  final VoiceController? voiceController;

  const VoiceMsgView({super.key, this.voiceController});

  @override
  Widget build(BuildContext context) {
    return VoiceMessageView(
      circlesColor: Theme.of(context).colorScheme.primary,
      activeSliderColor: Theme.of(context).colorScheme.primary,
      controller: voiceController!,
      innerPadding: 5,
      cornerRadius: 15,
    );
  }
}
