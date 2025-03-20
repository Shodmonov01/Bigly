
class CheckPasswordModel {
  bool? isValid;
  List? errors = [];

  CheckPasswordModel.fromJson(Map<String, dynamic> json) {
    isValid = json['is_valid'];
    errors = json['errors'];
  }

  Map<String, dynamic> get toJson => {
    'is_valid' : isValid,
    'errors' : errors,
  };
}