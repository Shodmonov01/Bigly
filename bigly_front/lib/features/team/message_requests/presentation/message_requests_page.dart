import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constants/app_images.dart';
import 'package:social_media_app/core/widgets/back_button.dart';
import 'package:social_media_app/features/team/message_requests/presentation/widgets/members_requests.dart';
import 'package:social_media_app/features/team/message_requests/view_model/message_request_view_model.dart';

class MessageRequestsPage extends StatefulWidget {
  const MessageRequestsPage({super.key});

  @override
  State<MessageRequestsPage> createState() => _MessageRequestsPageState();
}

class _MessageRequestsPageState extends State<MessageRequestsPage> {

  @override
  void initState() {
    context.read<MessageRequestViewModel>().getRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageRequestViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            leading: const AppBarBackButton(),
            title: const Text('Message Requests'),
          ),

          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              await viewModel.getRequests();
            },
            child: ListView.builder(
              itemCount: viewModel.requests.length,
              itemBuilder: (context, index) {
                return MembersRequests(chatModel: viewModel.requests[index],);
              },
            ),
          ),
          // body: SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Column(
          //       children: [
          //         ...List.generate(4, (index) {
          //           return MembersRequests(image: AppImages.postImage,);
          //         },)
          //       ],
          //     ),
          //   ),
          // ),
        );
      }
    );
  }
}
