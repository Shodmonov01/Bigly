
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';

import '../../../../core/data/data_source/local/app_local_data.dart';
import '../../../../di_service.dart';

abstract class ProfileRepo {
  Future<UserModel?> getUser();
  Future<UserModel?> getUserWithUsername(String username);
  Future<List<ContentPlanModel>> getContentPlanWithUsername(String username);
  Future<void> editBio(String bio);
  Future<void> editName(String name);
  Future<void> editProfileImage(String image);
  Future<void> editCoverImage(String image);
  Future<void> subscribe(int id);
  Future<void> follow(String username);
  Future<void> unFollow(String username);
}

class ProfileRepoImpl extends ProfileRepo {

  ProfileRepoImpl(this.dio);
  final Dio dio;

  @override
  Future<UserModel?> getUser() async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'profile/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJsonProfile(response.data);
        return userModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> getUserWithUsername(String username) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'user/$username/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200) {
        UserModel userModel = UserModel.fromJsonProfile(response.data);
        return userModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ContentPlanModel>> getContentPlanWithUsername(String username) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.get(
        'user/$username/content-plans/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );

      if (response.statusCode == 200) {
        List items = response.data;
        List<ContentPlanModel> contentPlanList = items.map((e) {
          return ContentPlanModel.fromJsonGetFromList(e);
        },).toList();
        return contentPlanList;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> editBio(String bio) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.put(
        'profile/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: {
          'bio' : bio,
        }
      );
    } catch (_) {}
  }

  @override
  Future<void> editName(String name) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.put(
          'profile/',
          options: Options(
            headers: headerWithAuth(token),
          ),
          data: {
            'first_name' : name,
          }
      );
    } catch (_) {}
  }

  @override
  Future<void> editProfileImage(String image) async {
    try {
      MultipartFile profileBase64Image = await MultipartFile.fromFile(image);

      final token = await AppLocalData.getUserToken;
      Response response = await dio.put(
        'profile/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: FormData.fromMap({
          'profile_picture' : profileBase64Image,
        }),
      );
    } catch (_) {}
  }

  @override
  Future<void> editCoverImage(String image) async {
    try {
      MultipartFile profileBase64Image = await MultipartFile.fromFile(image);

      final token = await AppLocalData.getUserToken;
      Response response = await dio.put(
        'profile/',
        options: Options(
          headers: headerWithAuth(token),
        ),
        data: FormData.fromMap({
          'cover_image' : profileBase64Image,
        }),
      );
    } catch (_) {}
  }

  @override
  Future<void> subscribe(int id) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.post(
        'content-plans/$id/subscribe/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
      }
      // return [];
    } catch (e) {
      // return [];
    }
  }

  @override
  Future<void> follow(String username) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.post(
        'user/$username/follow/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
      }
      // return [];
    } catch (e) {
      // return [];
    }
  }

  @override
  Future<void> unFollow(String username) async {
    try {
      final token = await AppLocalData.getUserToken;
      Response response = await dio.delete(
        'user/$username/follow/',
        options: Options(
          headers: headerWithAuth(token),
        ),
      );
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
      }
      // return [];
    } catch (e) {
      // return [];
    }
  }

}
