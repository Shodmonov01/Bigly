
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_media_app/features/create_section/add_to/data/repo/content_plan_repo.dart';
import 'package:social_media_app/features/create_section/choose_content_to_add/data/choose_content_to_add_repo.dart';
import 'package:social_media_app/features/create_section/new_insight/data/repo/new_insight_repo.dart';
import 'package:social_media_app/features/create_section/new_insight/data/repo/new_insight_repo.dart';
import 'package:social_media_app/features/grow_and_discover/grow/data/repo/grow_repo.dart';
import 'package:social_media_app/features/login/data/repo/login_repo.dart';
import 'package:social_media_app/features/notifications/data/repo/notification_repo.dart';
import 'package:social_media_app/features/profile/data/repo/profile_repo.dart';
import 'package:social_media_app/features/team/add_members/data/repo/add_member_repo.dart';
import 'package:social_media_app/features/team/add_members/data/repo/add_member_repo.dart';
import 'package:social_media_app/features/team/contacts/data/repo/new_chat_repo.dart';
import 'package:social_media_app/features/team/teams/data/repo/team_repo.dart';
import 'package:social_media_app/features/team/teams/data/repo/team_repo.dart';

import 'features/team/message_requests/data/repo/message_request_repo.dart';

var getIt = GetIt.instance;

final header = {
  'accept' : 'application/json',
  'Content-Type' : 'application/json',
};

Map<String, dynamic> headerWithAuth(String? token) => {
  'accept' : 'application/json',
  'Content-Type' : 'application/json',
  "Authorization": "Bearer $token",
};

Future<void> init() async {
  /// Hive
  await initHive();
  /// Get_it
  getItInit();
  /// Local database init
  // await GetStorage.init();
}

void getItInit() async {

  getIt

    ..registerLazySingleton(
          () => Dio()
        ..options = BaseOptions(
          // baseUrl: 'https://socialmediauz.pythonanywhere.com/api/',
          // baseUrl: 'http://5.35.82.80:7777/api/',
          baseUrl: 'https://api.invest-jewstone.ru/api/',
          // baseUrl: 'http://192.168.0.124:8000/api/',
          headers: header,
          sendTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        )
        ..interceptors.addAll(
          [
            LogInterceptor(
              requestBody: kDebugMode,
              responseBody: kDebugMode,
              logPrint: (object) =>
              kDebugMode ? log('dio: ${object.toString()}') : null,
            ),
            // chuck.getDioInterceptor(),
          ],
        ),
    )

  /// Data Sources
  //   ..registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl())
  //   ..registerLazySingleton<LoginLocalDataSource>(() => LoginLocalDataSourceImpl())
  //
  //   ..registerLazySingleton<CommonRemoteDataSource>(() => CommonRemoteDataSourceImpl())
  //   ..registerLazySingleton<CommonLocalDataSource>(() => CommonLocalDataSourceImpl())
  // ..registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance)
  // ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance,)

  /// Repository
    ..registerLazySingleton<LoginRepo>(() => LoginRepoImpl(getIt()))
    ..registerLazySingleton<ProfileRepo>(() => ProfileRepoImpl(getIt()))
    ..registerLazySingleton<ContentPlanRepo>(() => ContentPlanRepoImpl(getIt()))
    ..registerLazySingleton<NewInsightRepo>(() => NewInsightRepoImpl(getIt()))
    ..registerLazySingleton<TeamRepo>(() => TeamRepoImpl(getIt()))
    ..registerLazySingleton<NewChatRepo>(() => NewChatRepoImpl(getIt()))
    ..registerLazySingleton<AddMemberRepo>(() => AddMemberRepoImpl(getIt()))
    ..registerLazySingleton<MessageRequestRepo>(() => MessageRequestRepoImpl(getIt()))
    ..registerLazySingleton<GrowRepo>(() => GrowRepoImpl(getIt()))
    ..registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(getIt()))
    ..registerLazySingleton<ChooseContentToAddRepo>(() => ChooseContentToAddRepoImpl(getIt()));
  //   ..registerLazySingleton<SignUpRepo>(() => SignUpRepoImpl(getIt()));

  /// ViewModel
  //   ..registerSingleton<AuthViewModel>(AuthViewModel(),)

}

Future<void> initHive() async {

  await Hive.initFlutter();
  await Hive.openBox("appBox");

  // const boxName = 'appBox';
  // final Directory directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path);
  // _box = await Hive.openBox<dynamic>(boxName);
}
