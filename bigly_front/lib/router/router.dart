
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/features/create_section/create_voice_message/presentation/create_voice_message_page.dart';
import 'package:social_media_app/features/login/presentation/pages/login_page.dart';
import 'package:social_media_app/features/login/view_model/login_view_model.dart';
import 'package:social_media_app/features/payments/presentation/payments_page.dart';
import 'package:social_media_app/features/payments_data/presentation/payments_data.dart';
import 'package:social_media_app/features/profile/presentation/pages/my_content_plan_page.dart';
import 'package:social_media_app/features/team/add_members/presentation/create_group_page.dart';
import 'package:social_media_app/features/team/chat/presentation/pages/chat_page.dart';
import 'package:social_media_app/features/team/contacts/presentation/new_chat_page.dart';
import 'package:social_media_app/features/team/message_requests/presentation/message_requests_page.dart';

import '../features/create_section/choose_content_to_add/presentation/choose_content_to_add_screen.dart';
import '../features/create_section/create_image_message/presentation/pages/create_image_message_page.dart';
import '../features/create_section/create_text_message/presentation/create_text_message_page.dart';
import '../features/create_section/create_video_message/presentation/pages/create_video_message_page.dart';
import '../features/create_section/new_insight/presentation/pages/new_insight.dart';
import '../features/create_section/new_message/presentation/pages/new_message_page.dart';
import '../features/create_section/posts/presentation/pages/posts_page.dart';
import '../features/create_section/video_edit/presentation/pages/video_edit_page.dart';
import '../features/create_section/video_record/presentation/pages/video_record_page.dart';
import '../features/create_section/video_view/presentation/pages/video_view_page.dart';
import '../features/grow_and_discover/discover/presentation/pages/discover_page.dart';
import '../features/grow_and_discover/grow/presentation/pages/grow_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/login/presentation/pages/register_page.dart';
import '../features/navigation_bar/presentation/pages/navigation_bar.dart';
import '../features/profile/presentation/pages/profile_enum.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/team/add_members/presentation/add_members_page.dart';

part 'app_router.dart';