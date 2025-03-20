
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/content_model.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../di_service.dart';

abstract class GrowRepo {
  Future<List<ContentModel>> getPosts(int page, int pageSize);
  Future<List<ContentModel>> getDiscover(int page, int pageSize);
}

class GrowRepoImpl extends GrowRepo {

  GrowRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<List<ContentModel>> getPosts(int page, int pageSize) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'grow/?page=$page&page_size=$pageSize',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        List<ContentModel> contents = [];
        List list = response.data['results'];
        for (var element in list) {
          ContentModel contentModel = ContentModel.fromJsonList(element);
          if (contentModel.type != null) {
            if (contentModel.type!.isVideo) {
              contents.add(contentModel);
            }
          }
        }
        return contents;
      }
      return [];
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Future<List<ContentModel>> getDiscover(int page, int pageSize) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'discover/?page=$page&page_size=$pageSize',
        // 'discover/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      print("response.data");
      print(response.data['results'].length);
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        List<ContentModel> contents = [];
        List list = response.data['results'];
        for (var element in list) {
          ContentModel contentModel = ContentModel.fromJsonList(element);
          contents.add(contentModel);
        }
        return contents;
      }
      return [];
    } catch (e) {
      return [];
    }
    return [];
  }

}
