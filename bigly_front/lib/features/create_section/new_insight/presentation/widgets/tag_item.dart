
import 'package:flutter/material.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/widgets/add_tags_view.dart';

class TagItem extends StatelessWidget {
  const TagItem({
    super.key,
    this.color = Colors.black,
    this.margin,
    this.padding,
    required this.text,
    this.textStyle,
    this.onClose,
    required this.addTagsEnum,
  });

  final Color color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String text;
  final TextStyle? textStyle;
  final void Function()? onClose;
  final AddTagsEnum addTagsEnum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Badge(
        label: GestureDetector(
          onTap: onClose,
          child: const Text('X'),
        ),
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (addTagsEnum.isTagOtherSuperheroes)
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                Text(
                  text,
                  style: textStyle ?? const TextStyle(color: Colors.white)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
