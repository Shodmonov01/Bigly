
import 'package:dio/dio.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';

import '../../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../../di_service.dart';
import '../../../../../core/data/models/content_model.dart';

abstract class ContentPlanRepo {
  Future<ContentPlanModel?> createContentPlan(ContentPlanModel contentPlanModel);
  Future<List<ContentPlanModel>?> getContentPlans();
  Future<ContentPlanModel?> getContentPlan(int id);
  Future<void> createPost(ContentModel postModel);
  Future<void> editContentPlan(ContentPlanModel contentPlanModel);
  Future<void> addContentToContentPlan(int id, String type, int contentPlanId);
  Future<void> deleteContent(int id);
}

class ContentPlanRepoImpl extends ContentPlanRepo {

  ContentPlanRepoImpl(this.dio);

  final Dio dio;

  @override
  Future<ContentPlanModel?> createContentPlan(ContentPlanModel contentPlanModel) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.post(
        'content-plans',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: contentPlanModel.toJsonCreate,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
        return contentPlanModel;
      }
      return null;
    } catch (_) {
      return null;
    }

  }

  @override
  Future<List<ContentPlanModel>?> getContentPlans() async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'content-plans',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List items = response.data;
        List<ContentPlanModel> contentPlanModel;
        contentPlanModel = items.map((json) {
          return ContentPlanModel.fromJsonGetFromList(json);
        },).toList();
        return contentPlanModel;
      }
      return null;
    } catch (_) {
      return null;
    }

  }

  @override
  Future<ContentPlanModel?> getContentPlan(int id) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.get(
        'content-plans/$id',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonGet(response.data);
        return contentPlanModel;
      }
      return null;
    } catch (_) {
      return null;
    }

  }

  @override
  Future<void> createPost(ContentModel postModel) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.post(
        'contents/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: postModel.toJsonCreate,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
        // return contentPlanModel;
      }
    } catch (_) {}

  }

  @override
  Future<void> editContentPlan(ContentPlanModel contentPlanModel) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.put(
        'content-plans/${contentPlanModel.id}',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: contentPlanModel.toJsonCreate,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
        // return contentPlanModel;
      }
    } catch (_) {}
  }

  @override
  Future<void> addContentToContentPlan(int id, String type, int contentPlanId) async {
    try {
      final token = await AppLocalData.getUserToken;
      final Response response = await dio.put(
        'contents/$id/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: {
          "type": type,
          "content_plan_id": contentPlanId,
        }
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ContentPlanModel contentPlanModel = ContentPlanModel.fromJsonCreate(response.data);
        // return contentPlanModel;
      }
    } catch (_) {}
  }

  @override
  Future<void> deleteContent(int id) async {
    try {
      print(id);
      final token = await AppLocalData.getUserToken;
      Response response = await dio.delete(
        'contents/$id/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 204) {}
    } catch (_) {}
  }
}
