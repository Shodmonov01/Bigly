import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/content_view.dart';
import 'package:social_media_app/features/create_section/posts/presentation/widgets/post_item.dart';
import 'package:social_media_app/features/create_section/posts/view_model/posts_view_model.dart';
import 'package:social_media_app/router/router.dart';

import '../../../../../core/widgets/back_button.dart';
import '../../../../../core/widgets/button_circular.dart';
import '../../../choose_content_to_add/view_model/choose_content_view_model.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key, required this.id});

  final int id;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {

  @override
  void initState() {
    // print(widget.id);
    context.read<PostsViewModel>().getContents(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final read = context.read<PostsViewModel>();
    final watch = context.watch<PostsViewModel>();

    final watch2 = context.watch<ChooseContentToViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title:
        (read.contentPlan != null) ?
        Text('"${read.contentPlan!.name}"') : const SizedBox.shrink() ,
        actions: [
          // ButtonCircular(
          //   onPressed: (){
          //     DateTime now = DateTime.now();
          //     context.read<PostsViewModel>().getContents(widget.id);
          //     // context.pop(context);
          //   },
          //   text: 'Save',
          // ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(CupertinoIcons.share),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        context.push(RouteNames.chooseContentAdd);
                      },
                      icon: const Icon(Icons.add_circle,size: 28,),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //
                    //   },
                    //   icon: const Icon(CupertinoIcons.delete_solid),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  // itemCount: viewModel.contents.length ,
                    padding: const EdgeInsets.all(5),
                    itemCount: read.contents.length,
                    // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .6
                      // maxCrossAxisExtent: 200,
                      // mainAxisExtent: 220,
                      // mainAxisSpacing: 1,
                      // crossAxisSpacing: 1
                    ),
                    itemBuilder: (context, index) {
                      // return Text('wwe3f3f3rf3f3r3rfwef');
                      return PostItem(contentModel: read.contents[index],index: index,);
                    }
                ),
              )
            ],
          ),
          watch2.isShowContentWidget?
          watch2.showContentWidget(context, watch2.selectedContent) :
          const SizedBox.shrink(),
          // isShowContentWidget
          // watch.isPlayVideo?
          // const ContentView() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
