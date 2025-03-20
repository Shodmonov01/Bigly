
import '../../../../../core/data/models/user_model.dart';

class ContactWithLetterModel {
  String letter = '';
  List<UserModel> users = [];

  ContactWithLetterModel.fromJson(Map<String, dynamic> json) {
    letter = json['letter'];
    users = json['users'];
  }

}
