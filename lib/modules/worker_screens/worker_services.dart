import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/add_service.dart';
import 'package:trying_homy/modules/worker_screens/service_details.dart';
import 'package:trying_homy/shared/cubit/cubit.dart';
import 'package:trying_homy/shared/cubit/states.dart';
import '../../layout/worker_layout/worker_main_screen.dart';
import '../../shared/compenents/components.dart';
import '../../shared/styles/colors.dart';

class WorkerServices extends StatefulWidget {
   WorkerServices({super.key});

  @override
  State<WorkerServices> createState() => _WorkerServicesState();
}

class _WorkerServicesState extends State<WorkerServices> {
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

   List<Map<String,dynamic>> workerServices=[];

   bool isLoading = true;


   Future<void> getWorkerData() async   {
     final uid = FirebaseAuth.instance.currentUser!.uid;
     try{
       QuerySnapshot<Map<String, dynamic>> getServicesSnapshot = await FirebaseFirestore.instance
           .collection('services')
           .where('providerId', isEqualTo: uid)
           .get();

       if (getServicesSnapshot.docs.isNotEmpty) {
         for (var doc in getServicesSnapshot.docs) {
           Map<String, dynamic> data = doc.data();
           data['id'] = doc.id;
           workerServices.add(data);
         }
       }

       setState(() {
         isLoading=false;

       });

     }catch(e){
       setState(() {
         isLoading=false;
       });
       print(e.toString());
     }
   }

   @override
  void initState() {
     getWorkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,States>(
        listener: (context, state) {},
      builder: (context, state) {
        MyCubit cubit = MyCubit.get(context);
        return isLoading? const Center(child: CircularProgressIndicator())
            : PopScope(
              canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if(didPop) result;
            moveAndReplace(context, const WorkerMainScreen());
          },
              child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Scaffold(
              appBar: AppBar(
                titleSpacing: 10,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: ()=>moveAndReplace(context, const WorkerMainScreen()),
                        child:  Icon(
                            CupertinoIcons.back,
                            color: Theme.of(context).iconTheme.color
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'الخدمات',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23.sp,
                          color: Theme.of(context).textTheme.bodyLarge!.color
                      ),
                    ),
                  ],
                ),
              ),
              body: GridView.builder(
                itemCount: workerServices.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.w,
                    mainAxisExtent: 255.h,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 20.h
                ),
                shrinkWrap: true,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 10.h),
                itemBuilder: (context, index) {
                  var service = services[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: ()=>move(context,  const ServiceDetails()),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: cubit.isDark?  lightDarkColor: Colors.white,
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
                                    workerServices[index]['serviceImage'],
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
                                      '${workerServices[index]['price']} ﷼ ',
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
                                  workerServices[index]['name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                      color: Theme.of(context).textTheme.bodyLarge!.color
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  workerServices[index]['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: cubit.isDark? darkSubTextColor: Colors.grey
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
              floatingActionButton: FloatingActionButton.extended(
                onPressed: ()=>move(context,  const AddService()),
                backgroundColor: mainColor,
                label: const Text(
                  'إضافة خدمة',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                icon: const Icon(Icons.add_rounded,color: Colors.white,),
              ),
                        ),
                      ),
            );
      },
    );
  }
}
