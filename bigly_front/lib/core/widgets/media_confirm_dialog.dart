
import 'package:flutter/material.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';

class MediaConfirmDialog extends StatelessWidget {
  const MediaConfirmDialog({super.key,
    required this.title,
    required this.content,
    required this.buttons,
  });

  final String title;
  final String content;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.black,
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          5.hGap,
          Text(
            content,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          10.hGap,
          Column(
            children: buttons.map((e) {
              return Column(
                children: [
                  const Divider(),
                  e,
                ],
              );
            }).toList(),
          )
        ],
      ).padding(const EdgeInsets.all(10)),
    );
  }
}