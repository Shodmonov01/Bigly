import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/features/create_section/add_to/view_model/add_to_view_model.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/view_model/choose_content_view_model.dart';
import 'package:social_media_app/features/create_section/create_image_message/view_model/create_image_message_view_model.dart';
import 'package:social_media_app/features/create_section/create_voice_message/view_model/create_voice_msg_view_model.dart';
import 'package:social_media_app/features/create_section/posts/view_model/posts_view_model.dart';
import 'package:social_media_app/features/login/view_model/login_view_model.dart';
import 'package:social_media_app/features/profile/view_model/profile_view_model.dart';
import 'package:social_media_app/features/team/chat/view_model/chat_view_model.dart';
import 'package:social_media_app/features/team/contacts/view_model/contacts_view_model.dart';
import 'package:social_media_app/features/team/teams/view_model/teams_view_model.dart';

import 'di_service.dart';
import 'features/create_section/create_text_message/view_model/create_text_msg_view_model.dart';
import 'features/create_section/create_video_message/view_model/create_video_msg_view_model.dart';
import 'features/create_section/new_insight/view_model/new_insight_view_model.dart';
import 'features/create_section/video_edit/view_model/video_edit_view_model.dart';
import 'features/create_section/video_record/view_model/video_record_view_model.dart';
import 'features/create_section/video_view/view_model/video_view_view_model.dart';
import 'features/grow_and_discover/grow/view_model/grow_view_model.dart';
import 'features/home/view_model/home_view_model.dart';
import 'features/notifications/view_model/notification_view_model.dart';
import 'features/team/add_members/view_model/add_member_view_model.dart';
import 'features/team/message_requests/view_model/message_request_view_model.dart';
import 'router/router.dart';

late List<CameraDescription> cameras;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewInsightViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => AddToViewModel(getIt()) ,
        ),
        ChangeNotifierProvider(
          create: (_) => ChooseContentToViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => PostsViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          // create: (_) => TeamsViewModel(getIt())..initPage(),
          create: (_) => TeamsViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoRecordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateVoiceMsgViewModel()..initRecorder(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateTextMsgViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactsViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateVideoMsgViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoViewViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoEditViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddMemberViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageRequestViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => GrowViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationViewModel(getIt()),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateImageMessageViewModel(),
        ),

      ],
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Bigly',
          theme: MyTheme.lightMode,
        );
      }
    );
  }
}
