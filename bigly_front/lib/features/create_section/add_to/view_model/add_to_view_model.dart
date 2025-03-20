
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/create_section/add_to/data/models/content_plan_model.dart';
import 'package:social_media_app/features/create_section/add_to/data/repo/content_plan_repo.dart';
import 'package:social_media_app/features/create_section/add_to/presentation/pages/add_to.dart';
import 'package:social_media_app/core/data/models/content_model.dart';
import 'package:social_media_app/features/home/view_model/home_view_model.dart';
import 'package:social_media_app/router/router.dart';
import '../presentation/pages/new_plan_screen.dart';

class AddToViewModel extends ChangeNotifier {

  AddToViewModel(this.contentPlanRepo);
  final ContentPlanRepo contentPlanRepo;

  // final List<String> listEarning = [
  //   'Free',
  //   '\$2/week',
  //   '\$10/week',
  // ];
  // final List<String> listTime = [
  //   'week',
  //   'month',
  //   '3 months',
  // ];
  // final List<String> listPeriodDiscount = [
  //   '50% of for 30 days',
  //   '80% of for 7 days',
  //   '60% of for 20 days',
  // ];
  AddToEnum? addToEnum;
  // int itemCount=4;
  // String? selectedValue='Free';
  // String? selectedTimeValue='week';
  // String? selectedPeriodDiscount='50% of for 30 days';
  // TextEditingController planNameController = TextEditingController();
  // TextEditingController moneyController = TextEditingController();
  // bool isFree = false;
  // bool isSelectTime = false;
  // bool isActive = false;
  // bool isSelectTrial = false;
  // bool enableNone = false;
  //
  // void updateSelectedValue(String? newValue) {
  //   selectedValue = newValue;
  //   notifyListeners();
  // }
  // void updateIsSelectTrial(bool newValue) {
  //   isSelectTrial = newValue;
  //   if (newValue) {
  //     updateNone(false);
  //   }
  //   notifyListeners();
  // }
  // void updateNone(bool newValue) {
  //   enableNone = newValue;
  //   if (newValue) {
  //     updateIsSelectTrial(false);
  //   }
  //   notifyListeners();
  // }
  // void updateTimeSelectedValue(String? newValue) {
  //   selectedTimeValue = newValue;
  //   notifyListeners();
  //   changeIsSelectTime(true);
  //   changeFree(false);
  // }
  // void updatePeriodDiscount(String? newValue) {
  //   selectedPeriodDiscount = newValue;
  //   notifyListeners();
  //   updateIsSelectTrial(true);
  // }
  // void changeFree(bool value) {
  //   isFree = value;
  //   notifyListeners();
  // }
  // void changeActive(bool active) {
  //   isActive = active;
  //   notifyListeners();
  // }
  //
  showNewPlanScreen(context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const NewPlanScreen();
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: anim, curve: Curves.easeInOutExpo),
          ),
          child: child,
        );
      },
    );
  }
  //
  // void incrementCount(context){
  //   itemCount++;
  //   addToEnum=AddToEnum.added;
  //   notifyListeners();
  //   Navigator.pop(context);
  // }



  ///

  void initData() {
    trialDaysAndDiscountPercentPeriod = trialDaysAndDiscountPercent.map((percentAndDay) {
      return '${percentAndDay.$1}% of for ${percentAndDay.$2} days';
    },).toList();
    print(trialDaysAndDiscountPercentPeriod);
  }

  bool isFree = true;
  bool isActive = false;
  TextEditingController planNameController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  List<ContentPlanModel> contentPlanList = [];
  MultipartFile? bannerFile;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountDescriptionController = TextEditingController();
  bool isDiscounted = false;
  List<(int, int)> trialDaysAndDiscountPercent = [
    // (percent, day)
    (80, 7), (50, 30), (80, 30),
  ];
  List<String> trialDaysAndDiscountPercentPeriod = ['1212', '121e12e'];
  String? selectedTrialDaysAndDiscountPercentPeriod;
  int? selectedTrialDay;
  int? selectedDiscountPercent;
  List<String> priceTypes = [
    'week',
    'month',
  ];
  String? selectedPriceType;

  void onTapPriceType(String priceType) {
    isFree = false;
    selectedPriceType = priceType;
    notifyListeners();
  }

  void onTapFreeOrPaid({required bool isFree}) {
    this.isFree = isFree;
    notifyListeners();
  }

  void onTapTrialPeriodItem(String item) {
    isDiscounted = true;
    selectedTrialDaysAndDiscountPercentPeriod = item;
    int index = trialDaysAndDiscountPercentPeriod.indexOf(item);
    selectedDiscountPercent = trialDaysAndDiscountPercent[index].$1;
    selectedTrialDay = trialDaysAndDiscountPercent[index].$2;
    notifyListeners();
  }

  void onTapNoneDiscount() {
    isDiscounted = false;
    selectedDiscountPercent = null;
    selectedTrialDay = null;
    notifyListeners();
  }

  void onTapActive({required bool isActive}) {
    this.isActive = isActive;
    notifyListeners();
  }

  /// Get Content Plans
  Future<void> getContentPlans() async {
    List<ContentPlanModel>? items = await contentPlanRepo.getContentPlans();
    if (items != null) {
      contentPlanList = items;
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    var picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    String fileName = file!.path.split('/').last;
    bannerFile = await MultipartFile.fromFile(file.path, filename: fileName);
  }

  bool isLoading = false;
  Future<void> createContentPlan(BuildContext context) async {

    /// null check

    try {
      isLoading = true;
      notifyListeners();

      int? money;
      if (moneyController.text.isNotEmpty) {
        money = int.parse(moneyController.text);
      }

      addToEnum = AddToEnum.added;
      notifyListeners();

      ContentPlanModel contentPlanModel = ContentPlanModel(
        is_active: isActive,
        price_type: (isFree) ? 'free' : selectedPriceType,
        name: planNameController.text,
        price: money,
        bannerFile: bannerFile,
        description: descriptionController.text,
        trial_days: selectedTrialDay,
        trial_discount_percent: selectedDiscountPercent,
        trial_description: discountDescriptionController.text,
      );

      await contentPlanRepo.createContentPlan(contentPlanModel);

      isLoading = false;
      notifyListeners();

      context.pop();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }

  }

  Future<void> createPost(BuildContext context, ContentModel postModel) async {
    isLoading = true;
    notifyListeners();

    await contentPlanRepo.createPost(postModel);
    isLoading = false;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(RouteNames.home);
      context.read<HomeViewModel>().currentIndex = 2;
      context.push(RouteNames.addTo, extra: AddToEnum.manage);
    });
  }

  // Future<void> getContentPlan(int id) async {
  //   await contentPlanRepo.getContentPlan(id);
  // }

}