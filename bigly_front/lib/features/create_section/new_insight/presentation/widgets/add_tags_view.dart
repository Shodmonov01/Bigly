
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/features/create_section/new_insight/presentation/widgets/tag_item.dart';
import 'package:social_media_app/features/create_section/new_insight/view_model/new_insight_view_model.dart';

class AddTagsView extends StatelessWidget {
  const AddTagsView({super.key,
    required this.addTagsEnum,
    required this.tags
  });

  final AddTagsEnum addTagsEnum;
  final List<Iterable<String>> tags;

  @override
  Widget build(BuildContext context) {

    final read = context.read<NewInsightViewModel>();
    final watch = context.watch<NewInsightViewModel>();

    return Container(
      height: .4.hp(context),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 50,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Main tag
              if (addTagsEnum.isAddTags)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.hGap,
                  const Text('Choose the main teg for this insight').padding(const EdgeInsets.all(10)),
                  SizedBox(
                    height: 40,
                    child: Autocomplete(
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: TextButton(
                              onPressed: (){
                                focusNode.unfocus();
                                read.onSelectMainTag(textEditingController.text.trim());
                                textEditingController.clear();
                              },
                              child: const Text('Add new'),
                            ),
                          ),
                          focusNode: focusNode,
                        );
                      },
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return tags[0].where((String option) {
                            return true;
                          });
                        }
                        return tags[0].where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            return ListTagItem(text: options.elementAt(index), listTagItemEnum: ListTagItemEnum.main,);
                          },
                        );
                      },
                    ).padding(const EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  if (watch.mainSelectedTag.isNotEmpty)
                    Center(
                      child: TagItem(
                        onClose: () => read.onRemoveMainTag(),
                        addTagsEnum: addTagsEnum,
                        padding: const EdgeInsets.all(10),
                        text: read.mainSelectedTag,
                        margin: const EdgeInsets.all(5),
                      ),
                    ),
                ],
              ),

              /// Additional tags
              if (addTagsEnum.isAddTags)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.hGap,
                  const Text('Choose 3 additional tags for this insight').padding(const EdgeInsets.all(10)),
                  SizedBox(
                    height: 40,
                    child: Autocomplete(
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: TextButton(
                              onPressed: (){
                                focusNode.unfocus();
                                read.onSelectAdditionalTag(textEditingController.text.trim());
                                textEditingController.clear();
                              },
                              child: const Text('Add new'),
                            ),
                          ),
                          focusNode: focusNode,
                        );
                      },
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return tags[1].where((String option) {
                            return true;
                          });
                        }
                        return tags[1].where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            return ListTagItem(text: options.elementAt(index), listTagItemEnum: ListTagItemEnum.additional,);
                          },
                        );
                      },
                    ).padding(const EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  if (watch.additionalSelectedTags.isNotEmpty)
                    Center(
                      child: Wrap(
                        children: read.additionalSelectedTags.map((e){
                          return TagItem(
                            onClose: () => read.onRemoveAdditionalTag(e),
                            addTagsEnum: addTagsEnum,
                            text: e,
                            margin: const EdgeInsets.all(5),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),

              if (addTagsEnum.isTagOtherSuperheroes)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.hGap,
                  const Text('Choose up to 3 other Superheros to tag').padding(const EdgeInsets.all(10)),
                  SizedBox(
                    height: 40,
                    child: Autocomplete(
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          onChanged: (value) {
                            read.searchUsers(value);
                          },
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            suffixIcon: TextButton(
                              onPressed: (){
                                focusNode.unfocus();
                                read.onSelectAdditionalTag(textEditingController.text.trim());
                                textEditingController.clear();
                              },
                              child: const Text('Add new'),
                            ),
                          ),
                          focusNode: focusNode,
                        );
                      },
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return tags[0].where((String option) {
                            return true;
                          });
                        }
                        return tags[0].where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: ListTagItem(text: options.elementAt(index), listTagItemEnum: ListTagItemEnum.superheroes,),
                            );
                          },
                        );
                      },
                    ).padding(const EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  if (watch.superHeroSelectedTags.isNotEmpty)
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: read.superHeroSelectedTags.map((e){
                          return TagItem(
                            onClose: () => read.onRemoveSuperHeroTag(e),
                            addTagsEnum: addTagsEnum,
                            text: e,
                            margin: const EdgeInsets.all(5),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),

            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}

class ListTagItem extends StatelessWidget {
  const ListTagItem({super.key, required this.text, required this.listTagItemEnum});

  final String text;
  final ListTagItemEnum listTagItemEnum;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.unFocus;
        if (listTagItemEnum.isMain) {
          context.read<NewInsightViewModel>().onSelectMainTag(text);
        } else if (listTagItemEnum.isAdditional) {
          context.read<NewInsightViewModel>().onSelectAdditionalTag(text);
        } else {
          context.read<NewInsightViewModel>().onSelectSuperHeroTag(text);
        }
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (listTagItemEnum.isSuperheroes)
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                      ),
                    ),
                  ),
                ),
                Text(text, style: TextStyle(color: Colors.grey.shade800),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ListTagItemEnum {
  main,
  additional,
  superheroes,
}
extension ListTagItemEnumExtension on ListTagItemEnum {
  bool get isMain => this == ListTagItemEnum.main;
  bool get isAdditional => this == ListTagItemEnum.additional;
  bool get isSuperheroes => this == ListTagItemEnum.superheroes;
}

enum AddTagsEnum {
  addTags,
  tagOtherSuperheroes,
}
extension AddTagsEnumExtention on AddTagsEnum {
  bool get isAddTags => this == AddTagsEnum.addTags;
  bool get isTagOtherSuperheroes => this == AddTagsEnum.tagOtherSuperheroes;
}
