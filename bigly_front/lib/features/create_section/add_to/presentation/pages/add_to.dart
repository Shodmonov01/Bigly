
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/widget_extension.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/widgets/add_to_boxes.dart';
import 'package:social_media_app/features/create_section/add_to/view_model/add_to_view_model.dart';

import '../../../../../core/widgets/back_button.dart';

class AddTo extends StatefulWidget {
  final AddToEnum pageState;
  const AddTo({super.key,required this.pageState});

  @override
  State<AddTo> createState() => _AddToState();
}

class _AddToState extends State<AddTo> {

  @override
  void initState() {
    context.read<AddToViewModel>().getContentPlans();
    context.read<AddToViewModel>().addToEnum=widget.pageState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddToViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.pageState.isAddMembers?
              "Add all Subscribers from" :
              widget.pageState.isManage?
              "Manage your content" :
              "Add to",
            ),
            leading: const AppBarBackButton(),
            actions: [
              viewModel.addToEnum!.isAdd?
              IconButton(
                onPressed: () {
                  context.pop(context);
                },
                icon: const Icon(Icons.close),
              ):const SizedBox()
            ],
          ),
          // body: ScrollableContainer(),
          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              await viewModel.getContentPlans();
            },
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount:
              (widget.pageState.isAddMembers) ?
              viewModel.contentPlanList.length :
              viewModel.contentPlanList.length + 1,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 200,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if ((!widget.pageState.isAddMembers) && (index == 0)) {
                  return AddToBoxItem(
                    index: index,
                    programState: widget.pageState,
                    isFirst: index == 0,
                    contentPlanModel: ContentPlanModel(),// viewModel.contentPlanList[index],
                  );
                } else {
                  return AddToBoxItem(
                    index: index,
                    programState: widget.pageState,
                    isFirst: index == 0,
                    contentPlanModel:
                    (widget.pageState.isAddMembers) ?
                    viewModel.contentPlanList[index]:
                    viewModel.contentPlanList[index - 1],
                    addToEnum: widget.pageState,
                  );
                }
              },
            ),
          ),
        ).loadingView(viewModel.isLoading);
      }
    );
  }
}


enum AddToEnum {add,added,manage,addMembers}

extension AddToEnumExtension on AddToEnum {
  bool get isAdd => AddToEnum.add==this;
  bool get isAdded => AddToEnum.added==this;
  bool get isManage => AddToEnum.manage==this;
  bool get isAddMembers => AddToEnum.addMembers==this;
}





/// /// ///



///
