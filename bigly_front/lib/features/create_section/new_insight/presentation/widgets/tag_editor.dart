//
// import 'package:flutter/material.dart';
//
// class TagEditor extends StatelessWidget {
//   const TagEditor({super.key,
//     required this.suffixIcon,
//     required this.tags,
//     this.optionsViewBuilder,
//   });
//
//   final Widget Function(String tag) suffixIcon;
//   final List<String> tags;
//   final Widget Function(BuildContext context, void Function(String) onSelected, Iterable<String> options)? optionsViewBuilder;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Autocomplete(
//         fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
//           return TextFormField(
//             controller: textEditingController,
//             style: const TextStyle(fontSize: 12),
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10),
//               isDense: true,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//
//               suffixIcon: suffixIcon(textEditingController.text.trim()),
//
//             ),
//             focusNode: focusNode,
//           );
//         },
//         optionsBuilder: (textEditingValue) {
//           if (textEditingValue.text == '') {
//             return tags.where((String option) {
//               return true;
//             });
//           }
//           return tags.where((String option) {
//             return option.contains(textEditingValue.text.toLowerCase());
//           });
//         },
//         optionsViewBuilder: optionsViewBuilder,
//       ),
//     );
//   }
// }
