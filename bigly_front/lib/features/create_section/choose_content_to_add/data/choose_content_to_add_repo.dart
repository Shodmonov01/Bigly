
import 'package:dio/dio.dart';

import '../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../core/data/models/content_model.dart';
import '../../../../di_service.dart';

abstract class ChooseContentToAddRepo {
  Future<List<ContentModel>> getContents();
  Future<List<ContentModel>> getMessages();
}

class ChooseContentToAddRepoImpl extends ChooseContentToAddRepo {

  ChooseContentToAddRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<List<ContentModel>> getContents() async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'contents/?type=content',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<ContentModel> contentModel = (response.data as List).map((e) =>
            ContentModel.fromJsonList(e)).toList();
        return contentModel;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ContentModel>> getMessages() async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'contents/?type=message',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<ContentModel> contentModel = (response.data as List).map((e) =>
            ContentModel.fromJsonList(e)).toList();
        return contentModel;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

}
