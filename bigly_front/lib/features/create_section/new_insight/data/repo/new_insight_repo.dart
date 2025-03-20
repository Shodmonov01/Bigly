
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/content_model.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../di_service.dart';

abstract class NewInsightRepo {
  Future<void> createPost(ContentModel postModel);
}

class NewInsightRepoImpl extends NewInsightRepo {

  NewInsightRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<void> createPost(ContentModel postModel) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.post(
        'posts/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: postModel.toJsonCreate,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        // ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
        // return contentPlanModel;
      }
      // return null;
    } catch (_) {
      // return null;
    }

  }
}
