
import 'package:dio/dio.dart';

class UserModel {
  int id = 0;
  String? username = '';
  String? firstName = '';
  String? lastName = '';
  String? birthDate = '';
  MultipartFile? profilePicture;
  String? profilePictureUrl;
  List<String>? interestList = [];
  List<TagModel>? interests = [];
  String password = '';
  String password2 = '';
  String? bio = '';
  String? cover_image = '';
  int post_count = 0;
  int follower_count = 0;
  int following_count = 0;
  String? refresh = '';
  String? access = '';

  bool isChecked = false;

  UserModel({
    this.username,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.profilePicture,
    this.interestList,
    this.refresh,
    this.access,
  });

  FormData toJson() {
    return FormData.fromMap({
      'username': username,
      'password': password,
      'password2': password2,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate.toString(), // Convert DateTime to String
      'profile_picture': profilePicture,
      'interest_list': interestList,
    });
  }

  Map<String, dynamic> get toUpdateJson => {
    "username": username,
    "first_name": firstName,
    "last_name": firstName,
    "bio": bio,
    "birth_date": birthDate,
    "profile_picture": profilePicture,
    "cover_image": cover_image,
    "interest_list": interestList,
  };

  UserModel.fromJsonRegister(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
  }

  UserModel.fromJsonProfile(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    // lastName = json['last_name'];
    bio = json['bio'];
    birthDate = json['birth_date'];
    profilePictureUrl = json['profile_picture'];
    cover_image = json['cover_image'];
    post_count = json['post_count'];
    follower_count = json['follower_count'];
    following_count = json['following_count'];
    // interests = json['interests'].map((e) => InterestModel.fromJson(e),).toList();
  }

  UserModel.fromJsonContent(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePictureUrl = json['profile_picture'];
    cover_image = json['cover_image'];
  }

  List<UserModel>? fromJsonContentList(List? users) {
    if (users != null) {
      List<UserModel> usersList = [];
      for (var element in users) {
        usersList.add(UserModel.fromJsonContent(element));
      }
      return usersList;
    }
    return null;
  }

  UserModel copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? birthDate,
    MultipartFile? profilePicture,
    List<String>? interestList,
    String? refresh,
    String? access,
  }) => UserModel(
    username: username ?? this.username,
    firstName : firstName ?? this.firstName,
    lastName : lastName ?? this.lastName,
    birthDate : birthDate ?? this.birthDate,
    profilePicture : profilePicture ?? this.profilePicture,
    interestList: interestList ?? this.interestList,
    refresh: refresh ?? this.refresh,
    access: access ?? this.access,
  );

}

class TagModel {
  int id = 0;
  String name = '';

  TagModel();

  TagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  List<TagModel>? fromJsonList(List? tags) {
    List<TagModel> interests = [];
    if (tags != null) {
      for (var element in tags) {
        interests.add(TagModel.fromJson(element));
      }
      return interests;
    }
    return null;
  }

  Map<String, dynamic> get toJson => {
    'id' : id,
    'name' : name,
  };

}
