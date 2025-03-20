
import 'package:dio/dio.dart';
import 'package:social_media_app/core/data/models/content_model.dart';

class ContentPlanModel {

  String? name;
  int? price;
  String? price_type;
  String? bannerUrl;
  MultipartFile? bannerFile;
  bool? is_active;
  String? description;
  int? subscriber_count;
  int? length;
  int? trial_days;
  int? trial_discount_percent;
  String? trial_description;

  int? id;
  int? created_at;
  List contents = [];

  ContentPlanModel({
    this.name,
    this.price,
    this.price_type,
    this.bannerFile,
    this.is_active,
    this.description,
    this.trial_days,
    this.trial_discount_percent,
    this.trial_description,
  });

  ContentPlanModel.fromJsonCreate(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    price_type = json['price_type'];
    bannerUrl = json['banner'];
    is_active = json['is_active'];
    description = json['description'];
    trial_days = json['trial_days'];
    trial_discount_percent = json['trial_discount_percent'];
    created_at = json['created_at'];
  }

  ContentPlanModel.fromJsonGetFromList(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    price_type = json['price_type'];
    bannerUrl = json['banner'];
    is_active = json['is_active'];
    description = json['description'];
    trial_days = json['trial_days'];
    trial_discount_percent = json['trial_discount_percent'];
    created_at = json['created_at'];
    // contents = json['contents'];
  }

  ContentPlanModel.fromJsonGet(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    price_type = json['price_type'];
    bannerUrl = json['banner'];
    is_active = json['is_active'];
    description = json['description'];
    trial_days = json['trial_days'];
    trial_discount_percent = json['trial_discount_percent'];
    created_at = json['created_at'];
    contents = json['contents'];
  }

  FormData get toJsonCreate => FormData.fromMap({
    'name' : name,
    'price' : price,
    'price_type' : price_type,
    'banner' : bannerFile,
    'is_active' : is_active,
    'description' : description,
    'trial_days' : trial_days,
    'trial_discount_percent' : trial_discount_percent,
    'trial_description' : trial_description
  });

}
