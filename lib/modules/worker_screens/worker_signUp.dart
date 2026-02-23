import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trying_homy/layout/worker_layout/worker_main_screen.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/login_screen.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';
import 'package:path/path.dart' as path;

class WorkerSignup extends StatefulWidget {
   const WorkerSignup({super.key});

  @override
  State<WorkerSignup> createState() => _WorkerSignupState();
}

class _WorkerSignupState extends State<WorkerSignup> {
  String? selectedDept;
  var workerAgeController = TextEditingController();
  var workerNameController = TextEditingController();
  var workerAddController = TextEditingController();
  var workerPhoneController = TextEditingController();
  var workerPasswordController = TextEditingController();
  var workerPriceController = TextEditingController();
  var workerExpController = TextEditingController();
  bool isPassword = true;
  var formKey_workerSignUp=  GlobalKey<FormState>();
  String suffixIcon = 'assets/eye.svg';
  File? selectedIdImage;
  String? selectedIdImageName;
  final ImagePicker idPicker = ImagePicker();
  Future<void> choosePic() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);


      String imageName = path.basename(image.path);

      setState(() {
        selectedIdImage = imageFile;  
        selectedIdImageName = imageName; 
      });

      print("اسم الصورة: $imageName");
    }
  }
  Future<void> takePic() async {
    final XFile? image = await idPicker.pickImage(
      source: ImageSource.camera, 
      imageQuality: 80, 
    );

    if (image != null) {
      setState(() {
        selectedIdImage = File(image.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      mainColor.withOpacity(0.9),
                      const Color(0xFF0F0F1E),
                    ],
                    stops: const [
                      0.0,
                      0.8,
                    ]
                )
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50.h,
                    left: -50.w,
                    child: CircleAvatar(
                      radius: 100.r,
                      backgroundColor: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  Positioned(
                    top: 80.h,
                    right: -60.w,
                    child: Container(
                      width: 250.r,
                      height: 250.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF00F2FF).withOpacity(0.5),
                            const Color(0xFF00F2FF).withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200.h,
                    left: -40.w,
                    child: Container(
                      width: 200.r,
                      height: 200.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            mainColor.withOpacity(0.4),
                            mainColor.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), // تنعيم الألوان لتصبح مثل الضوء
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(top: 60.h),
                      child: Text(
                        'إنشاء حساب\nفني جديد',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 600.h,
                width: double.infinity,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 50.h,
                        child: defaultTextFormfeild(
                            text: 'الأسم الكامل',
                            prefixIcon: 'assets/acc.svg',
                            errorMes: 'يجب كتابة الأسم',
                            controller: workerNameController,
                            type: TextInputType.text
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        height: 50.h,
                        child: defaultTextFormfeild(
                          text: 'العنوان',
                          prefixIcon: 'assets/loc.svg',
                          errorMes: 'العنوان يجب ان لا يكون فارغ',
                          controller: workerAddController,
                          type: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                      Container(
                        height: 50.h,
                        child: defaultTextFormfeild(
                          text: 'رقم الهاتف',
                          prefixIcon: 'assets/phone.svg',
                          errorMes: 'رقم الهاتق يجب ان لا يكون فارغ',
                          controller: workerPhoneController,
                          type: TextInputType.phone,
                        ),
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                      Container(
                        height: 50.h,
                        child: defaultTextFormfeild(
                            text: 'كلمة المرور',
                            prefixIcon: 'assets/lock.svg',
                            errorMes: 'كلمة المرور يجب ان لا تكون فارغ',
                            controller: workerPasswordController,
                            type: TextInputType.visiblePassword,
                            isPassword: isPassword,
                            isSuffixIcon: true,
                            suffixIcon: suffixIcon,
                            suffixPressed: (){
                              isPassword =!isPassword;
                              setState(() {
                                suffixIcon = isPassword? 'assets/eye.svg' : 'assets/eye-slash.svg';
                              });
                            }
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        isExpanded: false,
                        alignment: AlignmentDirectional.centerStart,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                'assets/work.svg',
                                width: 12.w,
                                height:12.h,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            fillColor: Colors.grey.withOpacity(0.06),
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r), // زوايا أكثر نعومة
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(fontSize: 10.sp),
                        ),
                        hint:  Text(
                          'اختر القسم',
                          style: TextStyle(
                              fontSize: 12.sp
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        value: selectedDept,
                        items: const [
                          DropdownMenuItem(
                            value: 'كهرباء',
                            child: Align(alignment: Alignment.topRight, child: Text('كهرباء')),
                          ),
                          DropdownMenuItem(
                            value: 'سباكة',
                            child: Align(alignment: Alignment.topRight, child: Text('سباكة')),
                          ),
                          DropdownMenuItem(
                            value: 'الماء',
                            child: Align(alignment: Alignment.topRight, child: Text('الماء')),
                          ),
                          DropdownMenuItem(
                            value: 'التكييف',
                            child: Align(alignment: Alignment.topRight, child: Text('التكييف')),
                          ),
                          DropdownMenuItem(
                            value: 'البناء',
                            child: Align(alignment: Alignment.topRight, child: Text('البناء')),
                          ),
                          DropdownMenuItem(
                            value: 'الحدادة',
                            child: Align(alignment: Alignment.topRight, child: Text('الحدادة')),
                          ),
                          DropdownMenuItem(
                            value: 'النجارة',
                            child: Align(alignment: Alignment.topRight, child: Text('النجارة')),
                          ),
                          DropdownMenuItem(
                            value: 'الدهان',
                            child: Align(alignment: Alignment.topRight, child: Text('الدهان')),
                          ),
                          DropdownMenuItem(
                            value: 'أخرى',
                            child: Align(alignment: Alignment.topRight, child: Text('أخرى')),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedDept = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار القسم';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.grey.withOpacity(0.1)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selectedIdImage!=null?Icons.done_rounded:CupertinoIcons.circle,
                                size: 17,
                                color: Colors.grey.shade600,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(top: 5.h),
                                child: SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    selectedIdImage!=null?'$selectedIdImageName':'ارفق صورة الهوية',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade600
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: ()=>showModalBottomSheet(
                          context: context,
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: BottomSheet(
                              onClosing: () {},
                              builder:(context) => Container(
                                height: 250.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.r),
                                    color: Colors.white
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w,vertical: 20.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'اختار طريقة لتحميل صورة الهوية',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 30.h
                                      ),
                                      InkWell(
                                        onTap: () {
                                          takePic();
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/camera.svg',
                                              width: 25.w,
                                              height: 25.h,
                                              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 15.w),
                                            Text(
                                              'التقاط صورة',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: 25.h
                                      ),
                                      InkWell(
                                        onTap: () {
                                          choosePic();
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/image.svg',
                                              width: 25.w,
                                              height: 25.h,
                                              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 15.w),
                                            Text(
                                              'اختيار من المعرض',
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: 25.h
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedIdImage = null;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/delete.svg',
                                              width: 25.w,
                                              height: 25.h,
                                              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 15.w),
                                            Text(
                                              'حذف الصورة',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      defualtButton(
                          onPressed: ()=>moveAndReplace(context, const WorkerMainScreen()),
                          text: 'التالي',
                        height: 50.h
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                          defaultTextButton(
                              onPressed: ()=>move(context, const LoginScreen()),
                              text: 'سجل دخول'
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
