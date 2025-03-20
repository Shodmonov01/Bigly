
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/core/widgets/button_circular.dart';
import 'package:social_media_app/features/create_section/create_image_message/view_model/create_image_message_view_model.dart';

import '../../../../../core/widgets/send_and_add_button_bar.dart';

class CreateImageMessagePage extends StatefulWidget {
  const CreateImageMessagePage({super.key});

  @override
  State<CreateImageMessagePage> createState() => _CreateImageMessagePageState();
}

class _CreateImageMessagePageState extends State<CreateImageMessagePage> {

  late Stream stream;

  @override
  void initState() {
    stream = context.read<CreateImageMessageViewModel>().fetchMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<CreateImageMessageViewModel>();
    final watch = context.watch<CreateImageMessageViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: (watch.isNext) ? Colors.black : Colors.white,
        title: (!watch.isNext) ? const Text('Create a message') : const SizedBox(),
        leading: AppBarBackButton(iconColor: (!watch.isNext) ? Colors.black : Colors.white,),
        actions: [
          if (watch.isNext)
            IconButton(
              onPressed: (){
                read.onTapNext();
              },
              color: Colors.white,
              icon: const Icon(Icons.close),
            ) else
            ButtonCircular(
              onPressed: () {
                if (read.selectedCheck.contains(true)) {
                  read.onTapNext();
                }
              },
              text: 'Next',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: (!watch.selectedCheck.contains(true)) ?
            const Center(
              child: Text('Select image'),
            ) :
            AssetEntityImage(
              watch.imagesFromAsset[watch.selectedCheck.indexOf(true)],
              fit: (watch.isNext) ?
              null :
              BoxFit.cover ,
            ),
          ),
          StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {

                List<AssetEntity> imagesFromAsset = [];
                int itemCount = 0;

                if (snapshot.hasData) {

                  imagesFromAsset = snapshot.data;
                  itemCount = imagesFromAsset.length;

                }

                return (!watch.isNext) ? SizedBox(
                  height: .4.hp(context),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          read.onTapImageItem(index);
                        },
                        child: Stack(
                          children: [
                            const Center(child: Text('Loading...')),
                            SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: AssetEntityImage(
                                imagesFromAsset[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (watch.selectedCheck[index])
                              Container(
                                color: Colors.grey.withOpacity(.5) ,
                              ),
                          ],
                        ),
                      );

                      // return Image.file(
                      //   File(videosFromAsset[index].path),
                      // )
                      // if ((index == 0) && (read.groupButtonController.selectedIndex == 0)) {
                      //   return const OpenCameraItem();
                      // }
                      // if (read.groupButtonController.selectedIndex == 0) {
                      //   return VideoItem(index: index - 1);
                      // } else {
                      //   return VideoItem(index: index);
                      // }
                    },
                  ),
                ) :
                const SizedBox.shrink();
              }
          ),
        ],
      ),

      bottomNavigationBar: ColoredBox(
        color: Colors.black,
        child: SafeArea(
          child: SendAndAddButtonBar(
            onPressed0: (){},

            onPressed1: (){},
            backgroundColor1: Colors.grey.shade400,

            onPressed2: () async {
              read.addToContent(context);
              // await read.createPost();
              // context.push(
              //   RouteNames.contentPlan,
              //   extra: AddToEnum.add,
              // );
            },
            backgroundColor2: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
