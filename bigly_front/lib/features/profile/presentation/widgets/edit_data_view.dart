
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_enum.dart';
import 'package:social_media_app/features/profile/view_model/profile_view_model.dart';

class EditDataView extends StatefulWidget {
  const EditDataView({super.key, required this.title, required this.initialData, required this.profileEnum});

  final String title;
  final String initialData;
  final ProfileEnum profileEnum;

  @override
  State<EditDataView> createState() => _EditDataViewState();
}

class _EditDataViewState extends State<EditDataView> {

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.initialData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),

        actions: [
          IconButton(
            onPressed: (){
              if (widget.title == 'Description') {
                if (widget.profileEnum.isMyProfile) {
                  context.read<ProfileViewModel>().editBio(textEditingController.text.trim());
                } else {
                  // context.read<ChooseContentToViewModel>().
                }
              } else if (widget.title == 'Name') {
                context.read<ProfileViewModel>().editName(textEditingController.text.trim());
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.done, color: Colors.green,),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            label: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
