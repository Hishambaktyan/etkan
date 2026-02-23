import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../modules/user_screens/booking_details_screen.dart';
import '../../main.dart';
import '../../modules/user_screens/worker_details.dart';
import '../styles/colors.dart';
const List<BoxShadow> shadow =  [
  BoxShadow (
    color: Colors.black12,
    spreadRadius: 1.0,
    blurRadius: 7.0,
    offset: Offset(2, 5),
  ),
];
 List<BoxShadow> shadow2 =  [
  BoxShadow(
    color:mainColor.withOpacity(0.1),
    blurRadius: 3,
    spreadRadius: 2,
  ),
];
const String reyalSymbol = '\uFDFC';
Widget dashedDivider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // حساب عرض الشاشة المتاح للتقسيم
        const dashWidth = 5.0; // طول الشرطة الواحدة
        const dashSpace = 3.0; // المسافة بين الشرطات
        final dashCount = (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1, // سمك الخط
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade300),
              ),
            );
          }),
        );
      },
    ),
  );
}
/////////////////////////////////////////////
Widget defualtButton({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
})
=> Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadiusDirectional.circular(12.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Text(
      text!,
      style: TextStyle(
          fontSize:textSize.sp,
          color: Colors.white
      ),
    ),
  ),
);
////////////////////////////////////////////
Widget defualtButtonWithIcon({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
  required Widget icon
})
=> Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadiusDirectional.circular(12.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(
          width: 7.w,
        ),
        Text(
          text!,
          style: TextStyle(
              fontSize: textSize.sp,
              color: Colors.white
          ),
        ),
      ],
    ),
  ),
);
////////////////////////////////////////////
Widget defualtOutlinedButton({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 15,
})
=> Container(
  height: height,
  width: double.infinity,
  decoration: BoxDecoration(
    color: bgColor,
    border: Border.all(
      color: border
    ),
    borderRadius: BorderRadiusDirectional.circular(10.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Text(
      text!,
      style: TextStyle(
          fontSize: fontSize.sp,
          color: textColor
      ),
    ),
  ),
);
////////////////////////////////////////////
Widget defualtOutlinedButtonWithIcon({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 17,
  required Widget icon
})
=> Container(
  height: height,
  width: double.infinity,
  decoration: BoxDecoration(
    color: bgColor,
    border: Border.all(
        color: border
    ),
    borderRadius: BorderRadiusDirectional.circular(10.r),
  ),
  child: MaterialButton(
    onPressed: () => onPressed!(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(
          width: 7.w,
        ),
        Text(
          text!,
          style: TextStyle(
              fontSize: fontSize.sp,
              color: textColor
          ),
        ),
      ],
    ),
  ),
);
////////////////////////////////////////////
Widget defaultTextFormfeild(
    {
      required String? text,
      required String? prefixIcon,
      required String? errorMes,
      required TextEditingController? controller,
      bool isPassword = false,
      bool isSuffixIcon = false,
      String? suffixIcon,
      Function? suffixPressed,
      required TextInputType? type,
      double? fontSize,
    }
    )
=>TextFormField(
  style: TextStyle(
    fontSize: 12.sp
  ),
  keyboardType: type,
  textDirection: TextDirection.rtl,
  validator: (value) {
    if(value == null || value.isEmpty){
      return errorMes;
    }
    return null;
  },
  controller: controller,
  obscureText: isPassword,
  decoration:InputDecoration(
    filled: true,
    fillColor: Colors.grey.withOpacity(0.06),
    labelText: text,
    labelStyle: TextStyle(
      fontSize: 12.sp
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(prefixIcon!,width: 12.w,height:12.h,color: Colors.grey.shade600,),
    ),
    suffixIcon: isSuffixIcon? IconButton(
          onPressed: (){
            suffixPressed!();
          },
          icon: SvgPicture.asset(suffixIcon!,width:22.w,height:22.h,color: Colors.grey.shade600,),
      highlightColor: Colors.transparent,
      ) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(
        color: mainColor
    )
),
    errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(
        color: Colors.red
    )
),

  ),
);
/////////////////////////////////////////////
Widget defaultTextButton({
  required Function onPressed,
  required String text,
  bool isUpperCase =true,
  Color color = mainColor,
  bool isLined = true
})
=>TextButton(
    onPressed: (){
      onPressed();
    },
    child: Text(
      isUpperCase?text.toUpperCase():text,
      style:TextStyle(
          color: color,
          decoration: isLined?TextDecoration.underline:null,
        decorationColor: mainColor,
      ),
    )
);

Widget buildWorkerItem(
    String name,
    int  price,
    double rating,
    bool isbusy,
    String image,
    context
    )
=> InkWell(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  child: Container(
    width: double.infinity,
    height: 130.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadiusDirectional.circular(15.r),
      boxShadow: shadow
    ),
    child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w,start:10.w,top:10.h,bottom: 10.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                fit: BoxFit.cover,
                width: 100.w,
                height: 120.h,
                image,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 170.w,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$ ابتدائا من: ',
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          '$price ريال',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  isbusy?'مشغول':'متوفر',
                  style: TextStyle(
                      color: isbusy?Colors.red:Colors.green,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.navigate_next_rounded,
              size: 35,
              color: Colors.grey,
            ),

          ],
        )
    ),
  ),
  onTap: (){
    move(context, Worker_details());
  },
);

Widget buildBookingItem(
    String name,
    int  price,
    double rating,
    bool isbusy,
    String image,
    context
    )
=> InkWell(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  child: Container(
    width: double.infinity,
    height: 100.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadiusDirectional.circular(15.r),
      boxShadow: shadow
    ),
    child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w,start:10.w,top:10.h,bottom: 10.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.network(
                fit: BoxFit.cover,
                width: 80.w,
                height: 90.h,
                image,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'رقم الحجز: ',
                      style: TextStyle(
                          fontSize: 11.sp
                      ),
                    ),
                    Text(
                      '43546',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.sp
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الفني: ',
                      style: TextStyle(
                          fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(
                      width: 130.w,
                      child: Text(
                        '$name',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    Text(
                      'موعد الحجز: ',
                      style: TextStyle(
                          fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      '15-10-2025  4:12 م',
                      style: TextStyle(
                          fontSize: 10.sp,
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
    ),
  ),
  onTap: (){
    move(context, BookingDetailsScreen());
  },
);

class CategoryBuilder extends StatelessWidget {
  final String imagePath;       // مسار الصورة
  final String label;           // النص
  final double iconSize;        // حجم الصورة داخل الـ CircleAvatar
  final double textSize;        // حجم النص
  final double spacing;         // المسافة بين الأيقونة والنص

  const CategoryBuilder({
    Key? key,
    required this.imagePath,
    required this.label,
    this.iconSize = 40,
    this.textSize = 13,
    this.spacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 65.w,
          height: 65.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: shadow
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              imagePath,
            ),
          ),
        ),
        SizedBox(height: spacing.h),
        Text(
          label,
          style: TextStyle(fontSize: textSize.sp),
        ),
      ],
    );
  }
}



