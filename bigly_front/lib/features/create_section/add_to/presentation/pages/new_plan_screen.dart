import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/context_extension.dart';
import 'package:social_media_app/core/extensions/num_extension.dart';
import 'package:social_media_app/core/theme/my_theme.dart';
import 'package:social_media_app/core/widgets/base_button.dart';
import 'package:social_media_app/features/create_section/add_to/view_model/add_to_view_model.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class NewPlanScreen extends StatefulWidget {
  const NewPlanScreen({super.key,});

  @override
  State<NewPlanScreen> createState() => _NewPlanScreenState();
}

class _NewPlanScreenState extends State<NewPlanScreen> {

  @override
  void initState() {
    context.read<AddToViewModel>().initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final read = context.read<AddToViewModel>();
    final watch = context.watch<AddToViewModel>();
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2,color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () => context.pop(context),
                        child: const Icon(Icons.close,color: Colors.black,size: 40,)
                    ),
                  ),

                  //content plan name
                  Text('Content Plan Name',style: MyTheme.smallGreyText,),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: watch.planNameController,
                      // textAlign: TextAlign.center,
                      style: MyTheme.largeBlackText,
                      decoration:const InputDecoration(
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Divider(),
                  //subscription free
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subscription fee',style: MyTheme.smallGreyText),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  4.hGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaseButton(
                        onPressed: () {},
                        height: 35,
                        border: true,
                        width: 100,
                        color: !watch.isFree ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          cursorColor: !watch.isFree ? Colors.white : Colors.black,
                          style: !watch.isFree ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,
                          controller: read.moneyController,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.only(bottom: 12),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            hintText: '...',
                            prefixIcon: Icon(CupertinoIcons.money_dollar,color: !watch.isFree ? Colors.white : Colors.black,),
                            hintStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      Text('/',style: Theme.of(context).textTheme.bodyLarge,),

                      BaseButton(
                        border: true,
                        onPressed: () {},
                        height: 35,
                        width: 130,
                        color: !watch.isFree ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              hint: Text(
                                read.selectedPriceType ?? '',
                                style:Theme.of(context).textTheme.bodyLarge,
                              ),
                              selectedItemBuilder: (context) => read.priceTypes.map((item) => DropdownMenuItem(
                                value: item,
                                child: SizedBox(
                                  width: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        item,
                                        style: !watch.isFree ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,
                                      ),
                                      Icon(Icons.keyboard_arrow_down,size: 20,color: !watch.isFree ? Colors.white : Colors.black,)
                                    ],
                                  ),
                                ),
                              )).toList(),
                              isExpanded: false,
                              iconStyleData: const IconStyleData(icon: SizedBox()),
                              items: watch.priceTypes.map((item) => DropdownMenuItem(
                                onTap: () {
                                  read.onTapPriceType(item);
                                },
                                value: item,
                                child: Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:9,vertical: 4),
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: MyTheme.mediumBlackText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList(),
                              value: watch.selectedPriceType,
                              onChanged: (value) => read.onTapPriceType(value!),
                              buttonStyleData:  const ButtonStyleData(
                                padding:EdgeInsets.symmetric(horizontal: 16),
                                height: 35,
                                width: double.infinity,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  maxHeight: 400,
                                  decoration: BoxDecoration(
                                      boxShadow: const [],
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Colors.black,width: 1)
                                  )
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.zero
                              ),
                            ),
                          ),
                        ),
                      ),

                      Text('or',style: Theme.of(context).textTheme.bodyLarge,),
                      BaseButton(
                        border: false,
                        onPressed: () {
                          read.onTapFreeOrPaid(isFree: true);
                        },
                        height: 35,
                        color: read.isFree ? Colors.black : Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Free',
                          style: read.isFree ?
                          MyTheme.mediumWhiteText :
                          MyTheme.mediumBlackText,
                        ),
                      ),
                    ],
                  ),
                  4.hGap,
                  //trial discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trial period discount',style: MyTheme.smallGreyText),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  4.hGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BaseButton(
                        border: true,
                        onPressed: () {},
                        height: 37,
                        width: 230,
                        color: watch.isDiscounted ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 0,),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              hint: Text(
                                read.selectedTrialDaysAndDiscountPercentPeriod ?? '',
                                style:Theme.of(context).textTheme.bodyLarge,
                              ),
                              selectedItemBuilder: (context) => watch.trialDaysAndDiscountPercentPeriod.map((item) => DropdownMenuItem(
                                value: item,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      item,
                                      style: watch.isDiscounted ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,
                                    ),
                                    Icon(Icons.keyboard_arrow_down,size: 20,color: watch.isDiscounted ? Colors.white:Colors.black,),
                                  ],
                                ),
                              )).toList(),
                              isExpanded: false,
                              iconStyleData: const IconStyleData(icon: SizedBox()),
                              items: watch.trialDaysAndDiscountPercentPeriod.map((item) => DropdownMenuItem(
                                onTap: () {
                                  read.onTapTrialPeriodItem(item);
                                },
                                value: item,
                                child: Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:9,vertical: 4),
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: MyTheme.mediumBlackText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList(),
                              value: watch.selectedTrialDaysAndDiscountPercentPeriod,
                              onChanged: (value) => read.onTapTrialPeriodItem(value!),
                              buttonStyleData:  const ButtonStyleData(
                                padding:EdgeInsets.symmetric(horizontal: 16),
                                height: 35,
                                width: double.infinity,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  maxHeight: 400,
                                  decoration: BoxDecoration(
                                      boxShadow: const [],
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(color: Colors.black,width: 1)
                                  )
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.zero
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text('or',style: Theme.of(context).textTheme.bodyLarge,),
                      BaseButton(
                        onPressed: () {
                          read.onTapNoneDiscount();
                          // read.updateNone(true);
                        },
                        border: false,
                        height: 35,
                        color: !watch.isDiscounted ? Colors.black : Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'None',
                          style: !watch.isDiscounted ? MyTheme.mediumWhiteText : MyTheme.mediumBlackText,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  4.hGap,
                  //add baner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add banner',style: MyTheme.smallGreyText),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BaseButton(
                          onPressed: () async {
                            read.pickImage();
                            // var picker = ImagePicker();
                            // XFile? file = await picker.pickImage(source: ImageSource.gallery);
                          },
                          height: 35,
                          // width: 210,
                          border: false,
                          color: Colors.grey.shade100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.photo),
                              5.wGap,
                              Text('Upload',style: Theme.of(context).textTheme.bodyLarge,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  4.hGap,
                  //current status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Status',style: MyTheme.smallGreyText),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseButton(
                        onPressed: () {
                          read.onTapActive(isActive: true);
                        },
                        color: watch.isActive?Colors.black:Colors.grey.shade100,
                        border: false,
                        child: Text('Active',style:watch.isActive?MyTheme.mediumWhiteText:MyTheme.mediumBlackText,),
                      ),
                      20.wGap,
                      BaseButton(
                        onPressed: () {
                          read.onTapActive(isActive: false);
                        },
                        color: watch.isActive?Colors.grey.shade100:Colors.black,
                        border: false,
                        child: Text('Inactive',style: watch.isActive?MyTheme.mediumBlackText:MyTheme.mediumWhiteText),
                      )
                    ],
                  ),
                  const Divider(),
                  4.hGap,
                  //add content
                  Row(
                    children: [
                      Text('Add description',style: MyTheme.smallGreyText),
                      const Spacer(),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  TextField(
                    controller: read.descriptionController,
                    onTapOutside: (event) => context.unFocus,
                    maxLines: 3,
                  ),

                  const Divider(),

                  if (read.isDiscounted)
                  Row(
                    children: [
                      Text('Add discount description',style: MyTheme.smallGreyText),
                      const Spacer(),
                      const Icon(CupertinoIcons.exclamationmark_circle,color: Colors.grey,size: 20,),
                    ],
                  ),
                  if (read.isDiscounted)
                  TextField(
                    controller: read.discountDescriptionController,
                    onTapOutside: (event) => context.unFocus,
                    maxLines: 3,
                  ),


                  Text('Add content',style: MyTheme.smallGreyText),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        read.createContentPlan(context);
                        // read.incrementCount(context);
                      },
                      icon: const Icon(CupertinoIcons.add_circled,size: 70,color: Colors.black,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

