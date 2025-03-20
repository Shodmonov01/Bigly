
import 'package:dio/dio.dart';

class GroupModel{

  String? group_name;
  String? group_image;
  int? content_plan_id;
  List? user_id_list;
  bool? is_group;

  MultipartFile? group_image_file;


  GroupModel({
    this.group_name,
    this.group_image,
    this.content_plan_id,
    this.user_id_list,
    this.is_group,
    this.group_image_file
  });

  GroupModel.fromJson(Map<String, dynamic> json){
    group_name = json['group_name'];
    group_image = json['group_image'];
    content_plan_id = json['content_plan_id'];
    user_id_list = json['user_id_list'];
    is_group = json['is_group'];
  }

  FormData get toJson => FormData.fromMap({
    'group_name' : group_name,
    'group_image' : group_image_file,
    // 'content_plan_id' : content_plan_id,
    // 'content_plan_id' : 1000000005,
    'user_id_list' : user_id_list,
    'is_group' : is_group,
  });

}