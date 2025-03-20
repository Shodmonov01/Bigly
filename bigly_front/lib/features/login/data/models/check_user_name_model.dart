
class CheckUserNameModel {
  bool? available = false;
  List? suggestions = [];

  CheckUserNameModel();

  CheckUserNameModel.fromJson(Map<String, dynamic> json) {
    print('START');
    available = json['available'];
    print('START');
    suggestions = json['suggestions'];
    print('START');
  }

  Map<String, dynamic> get toJson => {
    'available' : available,
    'suggestions' : suggestions,
  };
}