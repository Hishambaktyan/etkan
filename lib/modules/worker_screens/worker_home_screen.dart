import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/service_details.dart';
import 'package:trying_homy/modules/worker_screens/worker_services.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../../shared/styles/colors.dart';


class WorkerHomeScreen extends StatefulWidget {
   WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final List<Map<String, dynamic>> info = [
    {
      'title': 'كل الحجوزات',
      'value': '53',
      'icon': 'assets/receipt.svg',
    },
    {
      'title': 'الحجوزات المكتملة',
      'value': '13',
      'icon': 'assets/all.svg',
    },
    {
      'title': 'كل الخدمات',
      'value': '23',
      'icon': 'assets/tool.svg',
    },
    {
      'title': 'التقييم',
      'value': '2.7',
      'icon': 'assets/star.svg',
    },
  ];

     List<Map<String, dynamic>> services = [
       {
         'name': 'تركيب حوض حمام',
         'price': '12000',
         'description': 'خدمة احترافية لتركيب جميع أنواع أحواض الحمامات مع التوصيلات المائية والصرف، نضمن لك عدم وجود تسريبات وشكل جمالي متناسق.',
         'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
       },
       {
         'name': 'تصليح دينامو ماء',
         'price': '8000',
         'description': 'فحص وتصليح موتور المياه (الدينامو)، تغيير قطع الغيار التالفة بأخرى أصلية، وضمان قوة ضخ المياه وسلاسة العمل.',
         'image': 'https://i.pinimg.com/736x/d2/89/9f/d2899f239623e6cb64f1854b469af5b5.jpg',
       },
       {
         'name': 'صيانة سباكة كاملة',
         'price': '50000',
         'description': 'فحص شامل لجميع تمديدات السباكة في المنزل، معالجة الرطوبة، الكشف عن التسريبات، وتجديد المحابس والوصلات المتهالكة.',
         'image': 'https://i.pinimg.com/736x/6d/66/af/6d66af4d10a9a7d19d1df880b0ce3b23.jpg',
       },
       {
         'name': 'تركيب فلتر مياه 7 مراحل',
         'price': '7000',
         'description': 'تركيب احترافي لفلتر المياه بجميع مراحله، توصيل الصنابير، واختبار جودة المياه لضمان الحصول على مياه نقية وصحية.',
         'image': 'https://i.pinimg.com/1200x/9b/9c/93/9b9c93ac5db55031a32139e972ee6da6.jpg',
       },
     ];

   String? workerName;

   String? workerDept;

   bool isLoading = true;

   Future<void> getWorkerData() async  {
     final uid = FirebaseAuth.instance.currentUser!.uid;
     try{
       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
           .collection('users')
           .doc(uid)
           .get();

       if (snapshot.exists && snapshot.data() != null) {
         workerName = snapshot.data()!['name'];
         workerDept = snapshot.data()!['specialization'];
         setState(() {
           isLoading=false;
         });
         print(workerName);
         print(workerDept);
       }

     }catch(e){
       setState(() {
         isLoading=false;
       });
       print(e.toString());
     }
   }

   @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
       getWorkerData();
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyCubit cubit = MyCubit.get(context);
    return BlocConsumer<MyCubit,States>(
      listener: (context, state) {},
      builder: (context, state) {
        return isLoading? const Center(child: CircularProgressIndicator())
        : Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 340.h,
                    child: Stack(
                      children: [
                        Container(
                          height: 270.h,
                          padding: EdgeInsetsDirectional.only(start: 15.w,end: 15.w,top: 35.h),
                          decoration:  BoxDecoration(
                            gradient:  cubit.amAvailable?LinearGradient(
                                colors: [
                                  mainColor,
                                  mainColor.withOpacity(0.7),
                                  Colors.green.shade300.withOpacity(0.5),
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [
                                  0.0,
                                  0.85,
                                  0.95,
                                  1.0
                                ]
                            )
                                :LinearGradient(
                                colors: [
                                  Colors.grey.shade500.withOpacity(0.5),
                                  Colors.grey.shade700.withOpacity(0.5),
                                  Colors.grey.shade300.withOpacity(0.5),
                                  Colors.white,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [
                                  0.0,
                                  0.85,
                                  0.95,
                                  1.0
                                ]
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 23.r,
                                    backgroundColor: Colors.white,
                                    foregroundImage: const NetworkImage('https://i.pinimg.com/1200x/b8/82/83/b882836fa749f501aefa935d19e19977.jpg'),
                                  ),
                                  SizedBox(
                                      width: 10.w
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          workerName ?? '',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.white, height: 1.2),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          workerDept ?? '',
                                          style: const TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){},
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white30),
                                          ),
                                          child: SvgPicture.asset('assets/not.svg', width: 23.w, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 180.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(150.r)),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.1),
                                          ],
                                        ),
                                        border: const BorderDirectional(
                                          top: BorderSide(
                                              color: Colors.white
                                          ),

                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(bottom: 20.h),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '0 \uFDFC',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28.sp,
                                              height: 1
                                          ),
                                        ),
                                        Text(
                                          'إجمالي الأرباح',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.sp,
                                              height: 1
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 115.h,
                            child: ListView.builder(
                              padding: EdgeInsetsDirectional.only(end: 10.w,start: 10.w,bottom: 10.w),
                              scrollDirection: Axis.horizontal,
                              itemCount: info.length,
                              itemBuilder: (context, index) {
                                var data = info[index];
                                return Container(
                                  margin: EdgeInsetsDirectional.only(end: index==3?0:10.w),
                                  width: 170.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: shadow
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -10,
                                        left: -10,
                                        child: SvgPicture.asset(
                                          data['icon'],
                                          color: mainColor.withOpacity(0.2),
                                          width: 53.w,
                                          height: 53.h,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 20.sp
                                                  ),
                                                ),
                                                const Spacer(),
                                                CircleAvatar(
                                                  backgroundColor: Colors.green.withOpacity(0.1),
                                                  radius: 23.r,
                                                  child: SvgPicture.asset(
                                                    data['icon'],
                                                    color: mainColor,
                                                    width: 23.w,
                                                    height: 23.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              data['title'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                  height: 1
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 120.h,
                    width: double.infinity,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: cubit.amAvailable?LinearGradient(
                          colors: [
                            mainColor,
                            mainColor.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [
                            0.0,
                            0.85,
                          ]
                      )
                          :LinearGradient(
                          colors: [
                            Colors.grey.shade500.withOpacity(0.5),
                            Colors.grey.shade700.withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [
                            0.0,
                            0.85,
                          ]
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (cubit.amAvailable ? mainColor : Colors.grey).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.h,vertical: 10.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              'assets/power.svg',
                              width: 28.w,
                              height: 28.h,
                              color: cubit.amAvailable?mainColor:Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'حالة الأتصال',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp
                                ),
                              ),
                              Text(
                                cubit.amAvailable? 'انت الآن متصل': 'انت الآن غير متصل',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: cubit.amAvailable,
                              activeColor: Colors.white,
                              onChanged: (value) => cubit.changeAvailability(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Text(
                          'الخدمات الحالية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        const Spacer(),
                        defaultTextButton(
                            onPressed: ()=>move(context, WorkerServices()),
                            text: 'عرض الكل',
                            isLined: false
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    itemCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 10.h),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.w,
                        mainAxisExtent: 240.h,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h
                    ),
                    itemBuilder: (context, index) {
                      var service = services[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: ()=>move(context, const ServiceDetails()),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: Colors.white,
                              boxShadow: shadow
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 125.h,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:BorderRadiusDirectional.only(topStart: Radius.circular(12.r),topEnd:Radius.circular(12.r)),
                                      child: Image.network(
                                        service['image'],
                                        height: 110.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 110.h,
                                          decoration: BoxDecoration(
                                              borderRadius:BorderRadiusDirectional.only(topStart: Radius.circular(12.r),topEnd:Radius.circular(12.r)),
                                              color: Colors.grey.shade100
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.wifi_off_rounded,
                                              size: 50,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: Container(
                                        height: 27.h,
                                        width: 100.w,
                                        padding: EdgeInsetsDirectional.only(top: 3.h),
                                        alignment: Alignment.center,
                                        margin: EdgeInsetsDirectional.only(end: 10.w),
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            border: Border.all(
                                                color: Colors.white
                                            ),
                                            borderRadius: BorderRadius.circular(30.r)
                                        ),
                                        child: Text(
                                          '${service['price']} ﷼ ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.only(start: 10.w,top: 10.h),
                                        child: CircleAvatar(
                                            radius: 18.r,
                                            backgroundColor: Colors.white,
                                            child: SvgPicture.asset(
                                              'assets/power.svg',
                                              color: cubit.isServicesActive?Colors.green:Colors.grey,
                                              width: 22.w,
                                              height: 22.h,
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 5.h),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(5, (i) => Icon(
                                        Icons.star_rounded,
                                        size: 16.r,
                                        color: i < 4 ? Colors.orange : Colors.grey.shade300,
                                      )),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      service['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      service['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        colors: [
                          mainColor,
                          mainColor.withOpacity(0.7)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          bottom: -30,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.r),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'وسع نطاق عملك',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 5.h
                                    ),
                                    Text(
                                      'أضف خدمات جديدة الآن وابدأ باستقبال المزيد من الطلبات',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 15.h
                                    ),
                                    ElevatedButton(
                                      onPressed: ()=>move(context, WorkerServices()),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: mainColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                          'إضافة خدمة جديدة'
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.add_business_rounded,
                                size: 70.r,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}