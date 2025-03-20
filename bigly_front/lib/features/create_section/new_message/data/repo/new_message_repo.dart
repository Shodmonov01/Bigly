
import 'package:dio/dio.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../core/data/models/content_model.dart';
import '../../../../../di_service.dart';

// abstract class NotificationRepo {
//   Future<void> createPost(ContentModel postModel);
// }
//
// class NotificationRepoImpl implements NotificationRepo {
//
//   NotificationRepoImpl(this.dio);
//   final Dio dio;
//
//   @override
//   Future<void> createPost(ContentModel postModel) async {
//     try {
//       final token = await AppLocalData.getUserToken;
//       final Response response = await dio.post(
//         'contents/',
//         options: Options(
//           headers: headerWithAuth(token),
//         ),
//         data: postModel.toJsonCreate,
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
//         // return contentPlanModel;
//       }
//     } catch (_) {}
//   }
// }
