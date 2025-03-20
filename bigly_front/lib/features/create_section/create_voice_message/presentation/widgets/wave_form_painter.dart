import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../view_model/create_voice_msg_view_model.dart';

class WaveWidget extends StatelessWidget {
  const WaveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      size: Size(MediaQuery.of(context).size.width, 140.0),
      recorderController: context.watch<CreateVoiceMsgViewModel>().controller,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      enableGesture: false,
      waveStyle: const  WaveStyle(
        waveThickness: 10,
        scaleFactor: 50,
        bottomPadding: 70,
        labelSpacing: 20,
        showDurationLabel: false,
        spacing: 15,
        waveCap: StrokeCap.round,
        showBottom: true,
        extendWaveform: true,
        showMiddleLine: false,
      ),
    );
  }
}
