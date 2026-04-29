import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AdminBookingsManagement extends StatefulWidget {
  const AdminBookingsManagement({super.key});

  @override
  State<AdminBookingsManagement> createState() => _AdminBookingsManagementState();
}

class _AdminBookingsManagementState extends State<AdminBookingsManagement> {
  String selectedStatus = 'الكل';

  final List<String> statusFilters = [
    'الكل',
    'قيد الانتظار',
    'مقبول',
    'في الطريق',
    'مكتمل',
    'مرفوض',
    'ملغي',
  ];

  List<Map<String, dynamic>> getDummyBookings() {
    return [
      {
        'title': 'تصليح مكيف سبليت',
        'status': 'مكتمل',
        'price': '150',
        'address': 'شارع الستين، صنعاء',
        'scheduledAt': DateTime.now(),
        'image': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=500',
        'providerName': 'أحمد محمد',
        'clientName': 'عبد الله عبد الفتاح',
      },
      {
        'title': 'إصلاح تسريب مياه',
        'status': 'مقبول',
        'price': '80',
        'address': 'حي المنصورة، عدن',
        'scheduledAt': DateTime.now().add(const Duration(days: 1)),
        'image': 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=500',
        'providerName': 'خالد علي',
        'clientName': 'عبد الله عبد الفتاح',
      },
      {
        'title': 'تركيب لمبات وإنارة',
        'status': 'قيد الانتظار',
        'price': '60',
        'address': 'شارع التحرير، تعز',
        'scheduledAt': DateTime.now().add(const Duration(days: 2)),
        'image': 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?w=500',
        'providerName': 'محمد سالم',
        'clientName': 'عبد الله عبد الفتاح',
      },
      {
        'title': 'صيانة غسالة ملابس',
        'status': 'في الطريق',
        'price': '120',
        'address': 'حي السلام، المكلا',
        'scheduledAt': DateTime.now().add(const Duration(hours: 5)),
        'image': 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500',
        'providerName': 'علي حسن',
        'clientName': 'عبد الله عبد الفتاح',
      },
      {
        'title': 'دهان غرفة نوم',
        'status': 'مرفوض',
        'price': '200',
        'address': 'شارع جمال، إب',
        'scheduledAt': DateTime.now().subtract(const Duration(days: 1)),
        'image': 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=500',
        'providerName': 'عمر عبدالله',
        'clientName': 'عبد الله عبد الفتاح',
      },
      {
        'title': 'تنظيف منزل كامل',
        'status': 'ملغي',
        'price': '100',
        'address': 'حي الجامعة، حضرموت',
        'scheduledAt': DateTime.now().subtract(const Duration(days: 2)),
        'image': 'https://images.unsplash.com/photo-1581578017421-70472e0f1c15?w=500',
        'providerName': 'سالم أحمد',
        'clientName': 'عبد الله عبد الفتاح',
      },
    ];
  }

  Widget buildDetailRow(String label, String value, String iconPath, dynamic cubit) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color: cubit.isDark ? mainColor.withOpacity(0.2) : mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SvgPicture.asset(
            iconPath,
            width: 22.w,
            height: 22.h,
            color: mainColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.grey,
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: cubit.isDark ? darkSubTextColor : Colors.black87,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);

        List<Map<String, dynamic>> bookings = selectedStatus == 'الكل'
            ? getDummyBookings()
            : getDummyBookings()
                .where((booking) => booking['status'] == selectedStatus)
                .toList();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              leading: IconButton(
                onPressed: ()=>Navigator.pop(context),
                 icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)
                 ),
              title: Text(
                'إدارة الحجوزات',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                ),
              actions: [
                IconButton(
                onPressed: (){},
                 icon: Icon(Icons.add_rounded,size: 30.w,color: Colors.white,)
                 ),
              
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsetsDirectional.only(top: 20.h),
                child: Column(
                  children: [
                   SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsetsDirectional.only(start: 10.w),
                        itemCount: statusFilters.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: index == 6 ? 0 : 15.w,
                            ),
                            child: ChoiceChip(
                              backgroundColor: appCubit.isDark
                                  ? const Color(0xFF161B22)
                                  : Colors.grey.shade100,
                              selectedColor: appCubit.isDark
                                  ? mainColor.withOpacity(0.15)
                                  : mainColor.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                side: BorderSide(
                                  color: appCubit.isDark
                                      ? (selectedStatus == statusFilters[index]
                                          ? mainColor
                                          : const Color(0xFF30363D))
                                      : Colors.transparent,
                                ),
                              ),
                              label: Text(statusFilters[index]),
                              selected: selectedStatus == statusFilters[index],
                              onSelected: (value) {
                                setState(() {
                                  selectedStatus = statusFilters[index];
                                });
                              },
                              labelStyle: TextStyle(
                                color: appCubit.isDark
                                    ? (selectedStatus == statusFilters[index]
                                        ? mainColor
                                        : const Color(0xFFC9D1D9))
                                    : Colors.black,
                                fontSize: 12.sp,
                                fontWeight: selectedStatus == statusFilters[index]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              showCheckmark: false,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(start: 20.w,end: 20.w,top: 5.h,),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        var booking = bookings[index];
                
                        Color statusColor;
                        String status = booking['status'];
                
                        switch (status) {
                          case 'مكتمل':
                            statusColor = Colors.green;
                            break;
                          case 'مقبول':
                          case 'في الطريق':
                            statusColor = Colors.blueAccent;
                            break;
                          case 'مرفوض':
                          case 'ملغي':
                            statusColor = Colors.redAccent;
                            break;
                          default:
                            statusColor = Colors.orangeAccent;
                        }
                        return Padding(
                          padding: EdgeInsetsDirectional.only(bottom: 20.h),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: (){},
                            child: Container(
                              padding: const EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.r),
                                        child: Image.network(
                                          booking['image'] ?? '',
                                          width: 80.w,
                                          height: 80.h,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80.w,
                                            height: 80.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    booking['title'],
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  height: 30.h,
                                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w),
                                                  decoration: BoxDecoration(
                                                    color: statusColor.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(6.r),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      status,
                                                      style: TextStyle(
                                                        color: statusColor,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              '${booking['price']} $reyalSymbol',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      children: [
                                        buildDetailRow(
                                          'العنوان:',
                                          booking['address'],
                                          'assets/loc.svg',
                                          appCubit,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: dashedDivider(Colors.grey),
                                        ),
                                        buildDetailRow(
                                          'التاريخ والوقت:',
                                          booking['scheduledAt'].toString(),
                                          'assets/timer.svg',
                                          appCubit,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: dashedDivider(Colors.grey),
                                        ),
                                        buildDetailRow(
                                          'المستخدم:',
                                          booking['providerName'],
                                          'assets/acc.svg',
                                          appCubit,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: dashedDivider(Colors.grey),
                                        ),
                                        buildDetailRow(
                                          'الفني:',
                                          booking['clientName'],
                                          'assets/providers.svg',
                                          appCubit,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}