
import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/di_service.dart';
import 'package:social_media_app/features/team/chat/data/models/chat_video_model.dart';
import 'package:social_media_app/core/data/models/chat_model.dart';
import 'package:social_media_app/features/team/teams/data/repo/team_repo.dart';
import 'package:video_player/video_player.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../constants/app_paths.dart';
import '../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../core/data/models/message_model.dart';

class ChatViewModel extends ChangeNotifier {
  VideoPlayerController? controller;
  ChewieController? chewieController;
  bool startRecord = false;
  // List chats = [
  //   VoiceController(
  //     audioSrc: 'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
  //     isFile: false,
  //     maxDuration: const Duration(seconds: 100),
  //     onComplete: () {  },
  //     onPause: () {  },
  //     onPlaying: () {  },
  //   ),
  //   'I want you to wake up to the fact that weight lass is a relatively easy '
  //       'process when you do it the smart and systematic way instead of just blindly '
  //       'cutting off carbs and calories. \n\nInstead of getting harder and harder on yourself, you need the opposite.\n\n'
  //       'I filmed you a little video insight, please, take a look',
  //   VoiceController(
  //     audioSrc: 'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
  //     isFile: false,
  //     maxDuration: const Duration(seconds: 100),
  //     onComplete: () {  },
  //     onPause: () {  },
  //     onPlaying: () {  },
  //   ),
  //   VoiceController(
  //     audioSrc: 'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
  //     isFile: false,
  //     maxDuration: const Duration(seconds: 100),
  //     onComplete: () {  },
  //     onPause: () {  },
  //     onPlaying: () {  },
  //   ),
  //   ChatVideoModel(url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
  // ];
  List<AssetEntity>? result;


  // void playVoiceMsg(String url) {
  //   for (var element in chats) {
  //     if (element is VoiceController) {
  //       if (element.audioSrc!=url){
  //         element.pausePlaying();
  //       }
  //     }
  //   }
  // }

  void playVideo(String url) async {
    // controller = CachedVideoPlayerPlusController.networkUrl(Uri.parse(url))
    //   ..initialize().then((value) {
    //     controller?.play();
    // },);
    // notifyListeners();
    controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        chewieController = ChewieController(
          videoPlayerController: controller!,
          autoPlay: true,
          looping: true,
          showControlsOnInitialize: true,
          showControls: true,
          allowMuting: false,
        );
        notifyListeners();
      })
      ..addListener(() {
        // notifyListeners();
      });
  }

  void disposeVideo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller!.dispose();
      // chewieController!.pause();
      // chewieController!.dispose();
    });
    startRecord = false;
    // notifyListeners();
  }

  void initFunc(context) async {
    result = await AssetPicker.pickAssets(context,pickerConfig: const AssetPickerConfig());
  }

  void recordState(bool value) {
    startRecord = value;
    notifyListeners();
  }







  /// ################################################################################################

  bool isUploadingFile = false;

  List<AudioPlayer> audioPlayerControllers = [];
  List<Duration> audioPlayerDurations = [];
  List<bool> isAudioPlayersPlay = [];
  void initAudioPlayerControllers() async {

    audioPlayerControllers = [];
    audioPlayerDurations = [];
    isAudioPlayersPlay = List.generate(messagesPagingController.itemList!.length, (index) => false);
    notifyListeners();
    print('initAudioPlayerControllers1');
    print(audioPlayerControllers.length);
    print(audioPlayerDurations.length);
    print(isAudioPlayersPlay.length);
    print(messagesPagingController.itemList!.length);
    print(messagesPagingController.itemList!.length);
    for (int i = 0; i < messagesPagingController.value.itemList!.length; i++) {
      if (messagesPagingController.itemList![i].media_type == 'audio') {
        print('i: ${messagesPagingController.itemList!.length}');
        AudioPlayer audioPlayer = AudioPlayer();
        Duration duration = await audioPlayer.setUrl(messagesPagingController.itemList![i].media!) ?? Duration.zero;
        audioPlayerControllers.add(audioPlayer);
        audioPlayerDurations.add(duration);
      } else {
        audioPlayerControllers.add(AudioPlayer());
        audioPlayerDurations.add(Duration.zero);
      }
    }

    print('initAudioPlayerControllers2');
    print(audioPlayerControllers.length);
    print(audioPlayerDurations.length);
    print(isAudioPlayersPlay.length);
    // print(messageModels.length);
    print(messagesPagingController.itemList!.length);
    notifyListeners();
  }

  void playAudio(int index) async {
    if (isAudioPlayersPlay[index]) {
      isAudioPlayersPlay = List.generate(messagesPagingController.itemList!.length, (index) => false);
      isAudioPlayersPlay[index] = false;
      audioPlayerControllers[index].pause();
    } else {
      isAudioPlayersPlay = List.generate(messagesPagingController.itemList!.length, (index) => false);
      isAudioPlayersPlay[index] = true;
      notifyListeners();
      if ((audioPlayerControllers[index].position < audioPlayerDurations[index])
            && (audioPlayerControllers[index].position >= Duration.zero)) {
        if (isAudioPlayersPlay.contains(true)) {
          for (var element in audioPlayerControllers) {
            element.stop();
          }
        }
      } else {
        await audioPlayerControllers[index].setUrl(messagesPagingController.itemList![index].media!);
        for (var element in audioPlayerControllers) {
          element.stop();
        }
      }
      await audioPlayerControllers[index].play().then((value) {
        isAudioPlayersPlay[index] = false;
      },);
    }
    notifyListeners();
  }

  void seekAudio(int index, Duration duration) async {
    await audioPlayerControllers[index].seek(duration);
    notifyListeners();
  }

  /// RECORD
  RecorderController audioRecordController = RecorderController();
  Future<void> record() async {
    // final hasPermission = await controller.checkPermission();
    await audioRecordController.record();
  }

  Future<void> stop() async {
    isUploadingFile = true;
    notifyListeners();
    final recordedAudioPath = await audioRecordController.stop();
    // final path = await AppPaths.pathCacheVideo;
    MultipartFile profileBase64Image = await MultipartFile.fromFile(recordedAudioPath!);
    final fileUrl = await getIt<TeamRepo>().sendFileToChat(profileBase64Image);

    channel!.sink.add(jsonEncode({
      "media": fileUrl,
      "media_type": 'audio',
      // "media_aspect_ratio": aspectRation
    }));

    isUploadingFile = false;
    notifyListeners();

    // chatModel = await getIt.get<TeamRepo>().getChat(chatID);
    // messageModels = chatModel!.messageModels;
    // initAudioPlayerControllers();
    notifyListeners();
  }

  void initRecorder() async {
    audioRecordController = RecorderController();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    notifyListeners();
  }
  /// RECORD

  bool isTyping = false;
  TextEditingController messageController = TextEditingController();
  ChatModel? chatModel;
  // List<MessageModel> messageModels = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int chatID = 0;
  Future<void> getChat(BuildContext context, int id) async {
    chatID = id;
    isLoading = true;
    scrollController.addListener(() {
      chatScrollListener(context);
    },);
    await connectChat(id);
    notifyListeners();

    chatModel = await getIt.get<TeamRepo>().getChat(id);
    // messageModels = chatModel?.messageModels;
    isLoading = false;
    notifyListeners();

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    // return chatModel;
  }

  static int pageSize = 10;
  PagingController<int, MessageModel> messagesPagingController = PagingController(firstPageKey: 1);

  void initMessagePagination() {
    messagesPagingController.dispose();
    messagesPagingController = PagingController(firstPageKey: 1);
    messagesPagingController.addPageRequestListener((pageKey) {
      getMessages(pageKey);
    });
  }
  Future<void> getMessages(int page) async {
    final messageModels = await getIt.get<TeamRepo>().getMessages(chatModel!.id!, page, pageSize);
    final isLastPage = messageModels.length < pageSize;
    print('END::');
    print(messageModels.length);
    if (isLastPage) {
      messagesPagingController.appendLastPage(messageModels);
      initAudioPlayerControllers();
      notifyListeners();
      // this.messageModels = messagesPagingController.itemList ?? [];
      // print(object)
    } else {
      // final nextPageKey = page + messageModels.length;
      final nextPageKey = page + 1;
      messagesPagingController.appendPage(messageModels, nextPageKey);
      initAudioPlayerControllers();
      notifyListeners();
      print('END:');
      print(nextPageKey);
      // this.messageModels = messagesPagingController.itemList ?? [];
    }
  }

  WebSocketChannel? channel;
  Future<void> connectChat(int id) async {
    // final wsUrl = Uri.parse('wss://socialmediauz.pythonanywhere.com/ws/chats/1000014/');
    // final wsUrl = Uri.parse('ws://socialmediauz.pythonanywhere.com/ws/chat/1000002/');
    // final wsUrl = Uri.parse('ws://192.168.0.124:8000/ws/chat/1000031/');
    final wsUrl = Uri.parse('ws://5.35.82.80:7777/ws/chat/$id/');
    final token = await AppLocalData.getUserToken;
    channel = IOWebSocketChannel.connect(
      wsUrl,
      headers: headerWithAuth(token),
    );
    channel!.stream.listen((event) {
      MessageModel messageModel = MessageModel.fromJson(jsonDecode(event)['message']);

      if (messageModel.media_type == null) {
        messageModel.mediaTypeModel = null;
      } else {
        messageModel.mediaTypeModel =
        messageModel.media_type!.mediaTypeModelFromString!;
      }

      AppLocalData.getUserName.then((value) {
        if (messageModel.sender_username == value){
          messageModel.isMine = true;
        }
      },);

      messagesPagingController.itemList!.insert(0, messageModel);
      // messageModels.insert(0, messageModel);
      initAudioPlayerControllers();
      notifyListeners();

      print(event);
      // print(messageModels[0].content);
    });

    await channel!.ready;

  }

  // File? pickedFile;
  Future<void> chooseFile() async {
    final filePicker = await FilePicker.platform.pickFiles(
      type: FileType.media
      // type: FileType.custom,
      // allowedExtensions: ['mp3',  'ogg', 'wav', 'm4a', 'mp4', 'mov', 'avi', 'jpg', 'jpeg', 'png'],
    );

    double aspectRation = 0;

    if (filePicker != null) {
      isUploadingFile = true;
      notifyListeners();
    }

    final pickedFile = filePicker!.files.first;

    int lastSlashIndex = pickedFile.path!.lastIndexOf('/');
    String pathWithoutFileName = pickedFile.path!.substring(0, lastSlashIndex + 1);
    String fileName = pickedFile.path!.split('/').last;
    fileName = fileName.replaceAll(RegExp(r'\s+'), '_');

    File copyFile = await File(pickedFile.path!).copy(pathWithoutFileName+fileName);

    print(copyFile.path);
    // return;

    MultipartFile profileBase64Image = await MultipartFile.fromFile(copyFile.path);
    final fileUrl = await getIt<TeamRepo>().sendFileToChat(profileBase64Image);

    String? fileType = lookupMimeType(pickedFile.path!);
    String mediaType = '';

    bool isImage = fileType!.startsWith('image');
    bool isVideo = fileType.startsWith('video');
    if (isImage) {
      final bytes = await File(pickedFile.path!).readAsBytes();
      final image = await decodeImageFromList(bytes);
      aspectRation = image.width / image.height;
      mediaType = 'image';
    } else if (isVideo) {

      VideoPlayerController videoPlayerController = VideoPlayerController.file(File(pathWithoutFileName+fileName));
      await videoPlayerController.initialize();
      aspectRation = videoPlayerController.value.aspectRatio;
      mediaType = 'video';
    } else {
      mediaType = 'audio';
    }

    print('aspectRation');
    print(aspectRation);

    channel!.sink.add(jsonEncode({
      "media": fileUrl,
      "media_type": mediaType,
      "media_aspect_ratio": aspectRation
    }));

    isUploadingFile = false;
    notifyListeners();

    print('END');
    notifyListeners();
  }

  FocusNode focusNode = FocusNode();
  void sendMessage(BuildContext context) {
    isTyping = false;
    channel!.sink.add(jsonEncode({
      'message': messageController.text
    }));
    messageController.clear();
    notifyListeners();
  }

  void chatScrollListener(BuildContext context) {
    context.unFocus;
  }

  void disposePage(BuildContext context) async {
    startRecord = false;
    scrollController.removeListener(() {
      chatScrollListener(context);
    },);
    await channel!.sink.close();
  }

}