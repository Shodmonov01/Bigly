import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/constants/constants.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';

class MusicWave extends StatelessWidget {
  const MusicWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: const Color.fromRGBO(248, 174, 124, .8),
          child: Icon(CupertinoIcons.play_arrow_solid,color: Theme.of(context).colorScheme.primary,),
        ),
        10.wGap,
        Row(
          children: [
            ...List.generate(8, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 3.3),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey.shade700
                    ),
                    child: SizedBox(
                      height: musicWaveHeight[index].toDouble()*3,
                      width: 3.8,
                    )
                ),
              );
            })
          ],
        )
      ],
    );
  }
}
