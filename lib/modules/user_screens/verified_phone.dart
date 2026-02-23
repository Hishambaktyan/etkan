import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import '../../layout/user_layout/user_main_screen.dart';
import '../../main.dart';
import '../../shared/styles/colors.dart';

class Verified_phone extends StatefulWidget {
  const Verified_phone({super.key});

  @override
  State<Verified_phone> createState() => _State();
}

class _State extends State<Verified_phone> {
  var formKey = GlobalKey<FormState>();
  final int length = 4;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  String phone = '770770858';
  @override
  void initState() {
    super.initState();
    controllers = List.generate(length, (_) => TextEditingController());
    focusNodes = List.generate(length, (_) => FocusNode());
  }
  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor:Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التحقق من رقم الهاتف',
                    style: TextStyle(
                      fontSize: 23.0.sp,
                      fontWeight: FontWeight.bold,
            
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/SVGs/v.svg',
                        width: 100.w,
                        height: 100.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'لقد أرسلنا رمز التحقق إلى رقم هاتفك  +967 7XX XXX XXX في الواتساب. الرجاء إدخال الرمز المكون من 4 أرقام للتحقق من حسابك',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight:FontWeight.bold ,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SizedBox(
                          height: 60.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                child: Container(
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color:mainColor.withOpacity(0.1)
                                  ),
                                  child: TextFormField(
                                    controller: controllers[index],
                                    focusNode: focusNodes[index],
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold
                                    ),
                                    showCursor: false,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        counterText: ''
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && index < length - 1) {
                                        // انتقل تلقائي للمربع التالي
                                        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                                      }
                                      if (value.isEmpty && index > 0) {
                                        // العودة للمربع السابق عند الحذف
                                        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            itemCount: 4,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                        child: Text(
                          'لم استلم رمز التحقق',
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline,
                              decorationColor: mainColor
                          ),
                        ),
                        onTap: (){},
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      defualtButton(
                        onPressed: (){
                          //if(formKey.currentState!.validate()){
                          move(context, const UserMainScreen());
                          //}
                        },
                        text: 'التالي',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
