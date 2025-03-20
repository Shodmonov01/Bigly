
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/data/data_source/remote/app_remote_data.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/tools/toast_bar.dart';
import 'package:social_media_app/di_service.dart';
import 'package:social_media_app/features/login/data/repo/login_repo.dart';
import 'package:social_media_app/router/router.dart';

import '../../../core/data/data_source/local/app_local_data.dart';
import '../../../core/data/models/user_model.dart';
import '../data/models/check_password_model.dart';
import '../data/models/check_user_name_model.dart';

class LoginViewModel extends ChangeNotifier{

  LoginViewModel(this.loginRepo);
  final LoginRepo loginRepo;

  int currentIndex = 0;
  PageController pageController = PageController();
  void onChangeIndex(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    notifyListeners();
  }



  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController birthDayController = TextEditingController();
  String selectedBirthDay = '';
  XFile? pickedFile;
  MultipartFile? profileBase64Image;
  List<String> selectedInterests = [];
  List<String> interestList = [
    'Psycology',
    'Breakup Healing',
    'Food',
    'Party',
    'Fitness',
    'Antiaging',
    'Travel',
    'Health',
    'Beuty',
    'Inspiration',
    'Happyness',
    'Politics',
    'Society',
    'Future',
  ];

  bool? isUserNameAvailable;
  List? suggestions;
  Future<void> checkUserName(String userName) async {
    if (userName.isEmpty) {
      isUserNameAvailable = null;
    }
    CheckUserNameModel? checkUserNameModel = await loginRepo.checkUserName(userName);
    if (checkUserNameModel == null) {
      isUserNameAvailable = false;
      suggestions = null;
    } else {
      isUserNameAvailable = checkUserNameModel.available;
      suggestions = checkUserNameModel.suggestions;

    }
    notifyListeners();
  }

  set onTapSuggestionItem(String text) {
    userNameController = TextEditingController(text: text);
    userNameController.selection = TextSelection.fromPosition(TextPosition(offset: userNameController.text.length));
    checkUserName(userNameController.text);
    notifyListeners();
  }

  bool? isPasswordValid;
  List? passwordErrors;
  void checkPassword(String password) async {
    CheckPasswordModel? checkPasswordModel = await loginRepo.checkPassword(password);
    if (checkPasswordModel == null) {
      isPasswordValid = null;
      passwordErrors = null;
    } else {
      isPasswordValid = checkPasswordModel.isValid;
      passwordErrors = checkPasswordModel.errors;
    }
    notifyListeners();
  }

  void onSelectBirthDay(BuildContext context) {
    showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((dateTime) {
      if (dateTime == null) return;
      selectedBirthDay = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      birthDayController.text = selectedBirthDay;
      notifyListeners();
    },);
  }

  void onSelectProfileImage() async {
    final ImagePicker picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    if (pickedFile == null) return;

    // List<int> bytes = await pickedFile!.readAsBytes();
    // profileBase64Image = base64Encode(bytes);
    // final bytes = await pickedFile!.readAsBytes();
    // print(bytes);
    // final bytes = await pickedFile!.readAsBytes();
    // File file = File('/path/to/your/file.jpg');
    // String fileName = file.path.split('/').last;
    // FormData formData = FormData.fromMap({
    //   'file': await MultipartFile.fromFile(file.path, filename: fileName),
    // });

    String fileName = pickedFile!.path.split('/').last;
    profileBase64Image = await MultipartFile.fromFile(pickedFile!.path, filename: fileName);
    // FormData formData = FormData.fromMap({
    //   'profile_picture' : await MultipartFile.fromFile(pickedFile!.path, filename: fileName),
    // });

    notifyListeners();
  }

  List<bool> listSelect = [];
  void onTapInterestItem(int index, String text) {
    if (!listSelect[index]) {
      if (selectedInterests.length == 5) return;
    }
    listSelect[index] = !listSelect[index];
    if (listSelect[index]) {
      selectedInterests.add(text);
    } else {
      selectedInterests.remove(text);
    }
  }

  void onNext(BuildContext context, int index) async {
    if (index == 7) {
      await getUsers();
    }
    pageController.jumpToPage(index);
    context.unFocus;
    notifyListeners();
  }

  Future<void> register() async {
    isLoading = true;
    notifyListeners();
    UserModel userModel = UserModel(
      username: userNameController.text,
      firstName: firstNameController.text,
      birthDate: selectedBirthDay,
      // lastName: firstNameController.text,
      profilePicture: profileBase64Image,
      interestList: selectedInterests,
    );

    userModel.password = passwordController.text;
    userModel.password2 = cPasswordController.text;

    await loginRepo.register(userModel);
    userNameController.clear();
    passwordController.clear();
    cPasswordController.clear();
    firstNameController.clear();
    birthDayController.clear();

    isLoading = false;
    notifyListeners();
  }

  bool isLoading = false;
  Future<void> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    bool isLogin = await loginRepo.login(userNameController.text, passwordController.text);

    if (!isLogin) {
      isLoading = false;
      notifyListeners();
      showToast('Username or password is wrong!', Colors.red);
      return;
    }

    await AppLocalData.saveUserName(userNameController.text);
    userNameController.clear();
    passwordController.clear();
    cPasswordController.clear();
    firstNameController.clear();
    birthDayController.clear();

    isLoading = false;
    notifyListeners();
    context.go(RouteNames.home);
  }

  List<UserModel> users = [];
  TextEditingController searchController = TextEditingController();
  Future<void> getUsers({String username = ''}) async {
    isLoading = true;
    notifyListeners();
    users = await AppRemoteData.searchUsers(username);
    isLoading = false;
    notifyListeners();
  }

  List<String> selectedUsers = [];
  void onTapUserItem(UserModel userModel) {
    userModel.isChecked = !userModel.isChecked;
    if (userModel.isChecked) {
      selectedUsers.add(userModel.username!);
    } else {
      selectedUsers.remove(userModel.username!);
    }
    notifyListeners();
  }

  Future<void> followUsers() async {
    // for (var element in users) {
      // await loginRepo.followUser(element.username!);
    // }
  }

  bool isAnimated = false;
  void ok() {
    isAnimated = true;
    notifyListeners();
  }

}
