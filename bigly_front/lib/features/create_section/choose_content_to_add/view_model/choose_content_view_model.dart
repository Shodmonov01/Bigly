import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/widgets/confirm_dialog.dart';
import 'package:social_media_app/di_service.dart';
import 'package:social_media_app/features/create_section/add_to/data/repo/content_plan_repo.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/data/choose_content_to_add_repo.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/widgets/icon_with_backgeound.dart';

class ChooseContentToViewModel extends ChangeNotifier {

  ChooseContentToViewModel(this.chooseContentToAddRepo);
  final ChooseContentToAddRepo chooseContentToAddRepo;

  PageController pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;
  bool messageCheckEnable = false;
  bool videoCheckEnable = false;
  List<bool> contentCheckedList = [];
  List<bool> messageCheckedList = [];
  List<ContentModel> contents = [];
  List<ContentModel> messages = [];


  List<ContentModel> selectedMessages = [];
  void changeCheckedMessage(index){
    messageCheckEnable = true;
    selectedMessages.add(messages[index]);
    messageCheckedList[index] = !messageCheckedList[index];

    // messages[index].isCheck  =! messages[index].isCheck;
    // messages.forEach((element) {if(element.isCheck)checkedList.add(element.isCheck);});
    if(!messageCheckedList.contains(true)) {
      selectedMessages.remove(messages[index]);
      messageCheckedList = List.generate(messages.length, (index) => false);
      messageCheckEnable = false;
    }
    notifyListeners();
  }

  List<ContentModel> selectedContents = [];
  void changeCheckedVideo(index) {
    videoCheckEnable = true;
    selectedContents.add(contents[index]);
    contentCheckedList[index] = !contentCheckedList[index];

    // contents[index].isCheck =! contents[index].isCheck;
    // List checkedList = [];
    // contents.forEach((element) {if(element.isCheck)checkedList.add(element.isCheck);});
    if(!contentCheckedList.contains(true)) {
      selectedContents.remove(contents[index]);
      contentCheckedList = List.generate(contents.length, (index) => false);
      videoCheckEnable = false;
    }
    notifyListeners();
  }

  ContentModel selectedContent = ContentModel();
  VideoPlayerController? videoPlayerController;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration audioPlayerDuration = const Duration();
  bool isAudioPlay = true;

  void openContainer(BuildContext context, ContentModel contentModel, int index) async {
    if (videoCheckEnable) {
      changeCheckedVideo(index);
      return;
    }
    if (messageCheckEnable) {
      changeCheckedMessage(index);
      return;
    }
    selectedContent = contentModel;
    notifyListeners();
    if (contentModel.media_type != null) {

      if (contentModel.media_type!.isVideo) {
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(contentModel.media!),
        )..initialize().then((value) {
          videoPlayerController?.setLooping(true);
          videoPlayerController?.play();
          notifyListeners();
        },);
      } else if (contentModel.media_type!.isAudio) {
        // await audioPlayer.dispose();
        await audioPlayer.setUrl(contentModel.media!);
        audioPlayerDuration = audioPlayer.duration!;
      }
      notifyListeners();

    } else {}

    notifyListeners();

    if (!messageCheckEnable && !videoCheckEnable) {
      isShowContentWidget = true;
      notifyListeners();
    }
    if (messageCheckEnable && currentPageIndex==1) {
      changeCheckedMessage(index);
    } else if (videoCheckEnable && currentPageIndex==0) {
      isShowContentWidget = false;
      notifyListeners();
      changeCheckedVideo(index);
    }
  }
  bool isShowContentWidget = false;
  Widget showContentWidget(BuildContext context, ContentModel contentModel) {
    return GestureDetector(
      onTap: () {
        isShowContentWidget = false;
        isAudioPlay = false;
        notifyListeners();
        if (videoPlayerController != null) {
          videoPlayerController!.dispose();
        }
        audioPlayer.stop();
      },
      child: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  height: .5.hp(context),
                  width: .8.wp(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1.3,color: Colors.black),
                  ),
                  child: Stack(
                    children: [
                      if (contentModel.media_type!.isVideo)
                      const Center(child: Text('Loading...'),),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (contentModel.media_type != null) ?
                          (contentModel.media_type!.isVideo) ?
                          Center(
                            child: AspectRatio(
                              aspectRatio: videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController!),
                            ),
                          ) :
                          (contentModel.media_type!.isMessage) ?
                          Center(
                            child: SingleChildScrollView(child: Text(
                              contentModel.text ?? '',
                            ),),
                          ) :
                          (contentModel.media_type!.isAudio) ?
                          Center(
                            child: Container(
                              height: 70,
                              width: .7.wp(context),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  IconButtonWithBackground(
                                    onTap: () async {
                                      // isAudioPlay = !isAudioPlay;
                                      notifyListeners();
                                      if ((audioPlayer.position < audioPlayerDuration)
                                          && (audioPlayer.position >= Duration.zero)) {

                                        if (!isAudioPlay) {
                                          isAudioPlay = true;
                                          await audioPlayer.play();
                                          // await audioPlayer.stop();
                                          isAudioPlay = false;
                                          notifyListeners();
                                        } else {
                                          isAudioPlay = false;
                                          notifyListeners();
                                          audioPlayer.pause();
                                        }

                                      } else {
                                        isAudioPlay = true;
                                        notifyListeners();
                                        audioPlayerDuration = await audioPlayer.setUrl(contentModel.media!) ?? const Duration();
                                        await audioPlayer.play();
                                      }

                                      notifyListeners();
                                      // read.playAudio(index);
                                    },
                                    height: 40,
                                    width: 40,
                                    color: Colors.grey.shade200,
                                    icon: isAudioPlay ?
                                    const Icon(Icons.pause):
                                    const Icon(Icons.play_arrow),
                                  ),
                                  10.wGap,
                                  Expanded(
                                    child:
                                    StreamBuilder(
                                      stream: audioPlayer.positionStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const SizedBox();
                                        } else {
                                          return ProgressBar(
                                            progress: audioPlayer.position,
                                            buffered: audioPlayer.bufferedPosition,
                                            total: audioPlayerDuration,
                                            timeLabelLocation: TimeLabelLocation.none,
                                            thumbGlowRadius: 15,
                                            thumbRadius: 8,
                                            onSeek: (duration) async {
                                              if (isAudioPlay) {
                                                await audioPlayer.seek(duration);
                                              } else {
                                                await audioPlayer.seek(duration);
                                                audioPlayer.pause();
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) :
                          Center(
                            child: Image(
                              image: CachedNetworkImageProvider(contentModel.media ?? ''),
                            ),
                          ):
                          const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }



  void changeContentType(int index) {
    contentCheckedList = List.generate(contents.length, (index) => false);
    messageCheckedList = List.generate(messages.length, (index) => false);
    selectedContents = [];
    selectedMessages = [];
    messageCheckEnable = false;
    videoCheckEnable = false;
    currentPageIndex = index;
    pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    notifyListeners();
  }

  Future<void> getContents() async {
    messageCheckEnable = false;
    videoCheckEnable = false;
    selectedContents = [];
    selectedMessages = [];
    currentPageIndex = 0;
    pageController = PageController(initialPage: 0);
    contents = await chooseContentToAddRepo.getContents();
    contentCheckedList = List.generate(contents.length, (index) => false);
    notifyListeners();
  }

  Future<void> getMessages() async {
    messageCheckEnable = false;
    videoCheckEnable = false;
    pageController = PageController(initialPage: 0);
    messages = await chooseContentToAddRepo.getMessages();
    messageCheckedList = List.generate(messages.length, (index) => false);
    notifyListeners();
  }

  Future<void> deleteContent(BuildContext context) async {

    bool? isYes = await confirmDialog(
      context,
      title: 'Delete Content',
      content: 'Are you sure you want to delete?',
    );

    if (isYes == null) return;

    if (videoCheckEnable) {
      for (int i = 0; i < selectedContents.length; i++) {
        if (contentCheckedList[i]) {
          await getIt.get<ContentPlanRepo>().deleteContent(selectedContents[i].id!);
        }
      }
      await getContents();
    }
    if (messageCheckEnable) {
      print('DELETE:');
      print(messageCheckedList);
      print(selectedMessages);
      for (int i = 0; i < selectedMessages.length; i++) {
        if (messageCheckedList[i]) {
          await getIt.get<ContentPlanRepo>().deleteContent(selectedMessages[i].id!);
        }
      }
      await getMessages();
    }

  }

  Future<void> addContent(int contentPlanId) async {
    if (videoCheckEnable) {
      for (var item in selectedContents) {
        await getIt.get<ContentPlanRepo>().addContentToContentPlan(item.id!, item.type!.contentTypeToString(), contentPlanId);
      }
    }
    if (messageCheckEnable) {
      for (var item in selectedMessages) {
        await getIt.get<ContentPlanRepo>().addContentToContentPlan(item.id!, item.type!.contentTypeToString(), contentPlanId);
      }
    }
  }

}