
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PostCaption extends StatefulWidget {
  const PostCaption({super.key,
    required this.text,
  });

  final String text;

  @override
  State<PostCaption> createState() => _PostCaptionState();
}

class _PostCaptionState extends State<PostCaption> {
  @override
  Widget build(BuildContext context) {

    TextSpan generateTextSpan(String text) {
      if (text.isNotEmpty) {
        // Find the index of "@" symbol
        int atIndex = text.indexOf('@');
        if (atIndex != -1 && atIndex < text.length - 1) {
          // Find the index of the next space after "@" symbol
          int nextSpaceIndex = text.indexOf(' ', atIndex);
          if (nextSpaceIndex != -1) {
            return TextSpan(
              children: [
                TextSpan(
                  text: text.substring(0, atIndex),
                  style: const TextStyle(color: Colors.black),
                ),
                const TextSpan(
                  text: '@',
                  style: TextStyle(color: Colors.orange), // Color for the "@" symbol
                ),
                TextSpan(
                  text: text.substring(atIndex + 1, nextSpaceIndex),
                  style: const TextStyle(color: Colors.orange), // Color for the word after "@"
                  recognizer: TapGestureRecognizer()..onTap = () => print('Tap Here onTap'),
                ),
                TextSpan(
                  text: text.substring(nextSpaceIndex),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            );
          }
        }
      }
      // If "@" is not found or there's no word after it, just return the whole text with black color
      return TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black),
      );
    }

    return Text.rich(
      TextSpan(
        children: [generateTextSpan(widget.text)],
      ),
    );
  }
}

