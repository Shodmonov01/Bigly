
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/video_record/view_model/video_record_view_model.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {

    final read = context.read<VideoRecordViewModel>();

    return GestureDetector(
      onTap: () {
        setState(() {
          isRecording = !isRecording;
        });
        read.onTapRecord(context, isRecording);
      },
      child: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: (isRecording) ?
          const Icon(Icons.person_outline, color: Colors.orange,):
          Container(
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
