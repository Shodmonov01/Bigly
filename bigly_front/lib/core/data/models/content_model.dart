
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/user_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';

class ContentModel {

  bool isCheck = false;
  ContentMediaType? contentMediaType;

  /// POST
  List? tagged_user_list;
  String? media;
  String? thumbnail;
  MultipartFile? mediaFile;
  String? main_tag_name;
  List? tag_list;
  int? content_plan_id;
  ContentMediaType? media_type;
  ContentType? type;

  /// GET
  int? id;
  UserModel? user;
  String? text;
  int? comment_count;
  int? like_count;
  bool? has_liked;
  TagModel? main_tag;
  bool? has_saved;
  DateTime? created_at;
  DateTime? updated_at;
  List<TagModel>? tags;
  List<UserModel>? tagged_users;
  String? banner;
  double? media_aspect_ratio;

  bool? has_subscribed;
  bool? is_following;
  ContentPlanModel? contentPlanModel;

  ContentModel({
    this.text,
    this.tagged_user_list,
    this.mediaFile,
    this.main_tag_name,
    this.tag_list,
    this.content_plan_id,
    this.media_type,
    this.type,
  });

  ContentModel.fromJsonCreate(Map<String, dynamic> json) {
    id = json['id'];
    user = (json['user'] != null) ? UserModel.fromJsonContent(json['user']) : null;
    text = json['text'];
    comment_count = json['comment_count'];
    type = json['type'].toString().contentTypeFromString();
    like_count = json['like_count'];
    has_liked = json['has_liked'];
    main_tag = (json['main_tag'] != null) ? TagModel.fromJson(json['main_tag']) : null;
    has_saved = json['has_saved'];
    created_at = (json['created_at'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['created_at']*1000, isUtc: true): null;
    updated_at = json['updated_at'];
    media = json['media'];
    thumbnail = json['thumbnail'];
    media_type = json['media_type'].toString().contentMediaTypeFromString();
    tags = TagModel().fromJsonList(json['tags']);
    tagged_users = UserModel().fromJsonContentList(json['tagged_users']);
    media_aspect_ratio = json['media_aspect_ratio'];
    banner = json['banner'];
    // tagged_user_list = json['tagged_user_list'];
    // media = json['media'];
    // tag_list = json['tag_list'];
    // content_plan_id = json['content_plan_id'];
  }

  ContentModel.fromJsonList(Map<String, dynamic> json) {
    id = json['id'];
    user = (json['user'] != null) ? UserModel.fromJsonContent(json['user']) : null;
    text = json['text'];
    comment_count = json['comment_count'];
    type = json['type'].toString().contentTypeFromString();
    like_count = json['like_count'];
    has_liked = json['has_liked'];
    main_tag = (json['main_tag'] != null) ? TagModel.fromJson(json['main_tag']) : null;
    has_saved = json['has_saved'];
    created_at = (json['created_at'] != null) ? DateTime.fromMillisecondsSinceEpoch(json['created_at']*1000, isUtc: true): null;
    // updated_at = json['updated_at'];
    media = json['media'];
    thumbnail = json['thumbnail'];
    media_type = json['media_type'].toString().contentMediaTypeFromString();
    tags = TagModel().fromJsonList(json['tags']);
    tagged_users = UserModel().fromJsonContentList(json['tagged_users']);
    media_aspect_ratio = json['media_aspect_ratio'];
    banner = json['banner'];
    has_subscribed = json['has_subscribed'];
    is_following = json['is_following'];
    // print('JAVOB');
    // print('javob: ${json['content_plan']}');
    if (json['content_plan'] != null) {
      contentPlanModel = ContentPlanModel.fromJsonGetFromList(json['content_plan']);
    }
    // tagged_user_list = json['tagged_user_list'];
    // media = json['media'];
    // tag_list = json['tag_list'];
    // content_plan_id = json['content_plan_id'];
  }

  FormData get toJsonCreate => FormData.fromMap({
    'text' : text,
    'type': type?.contentTypeToString(),
    'main_tag_name' : main_tag_name,
    'tagged_user_list' : tagged_user_list,
    'media' : mediaFile,
    'media_type' : media_type?.contentTypeToString(),
    'tag_list' : tag_list,
    'content_plan_id' : content_plan_id,
    'media_aspect_ratio' : media_aspect_ratio,
    'banner' : banner,
  });

}


enum ContentType{content, message}

extension ContentTypeExtension on ContentType {
  bool get isVideo => ContentType.content == this;
  bool get isMessage => ContentType.message == this;
}
extension ContentTypeToStringExtension on ContentType {
  String contentTypeToString() {
    switch (this) {
      case ContentType.content:
        return 'content';
      case ContentType.message:
        return 'message';
    }
  }
}
extension ContentTypeFromStringExtension on String {
  ContentType? contentTypeFromString() {
    switch (this) {
      case 'content':
        return ContentType.content;
      case 'message':
        return ContentType.message;
    }
    return null;
  }
}



enum ContentMediaType{video,audio,text,image}

extension ContentMediaTypeExtension on ContentMediaType {
  bool get isVideo => ContentMediaType.video == this;
  bool get isAudio => ContentMediaType.audio == this;
  bool get isMessage => ContentMediaType.text == this;
  bool get isImage => ContentMediaType.image == this;
}
extension ContentMediaTypeToStringExtension on ContentMediaType {
  String contentTypeToString() {
    switch (this) {
      case ContentMediaType.video:
        return 'video';
      case ContentMediaType.audio:
        return 'audio';
      case ContentMediaType.text:
        return 'text';
      case ContentMediaType.image:
        return 'image';
    }
  }
}
extension ContentMediaTypeFromStringExrtension on String {
  ContentMediaType? contentMediaTypeFromString() {
    switch (this) {
      case 'video':
        return ContentMediaType.video;
      case 'audio':
        return ContentMediaType.audio;
      case 'null':
        return ContentMediaType.text;
      case 'image':
        return ContentMediaType.image;
    }
    return null;
  }
}
