import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/main.dart';
import 'package:trying_homy/modules/worker_screens/worker_order_details.dart';
import 'package:trying_homy/shared/styles/colors.dart';
import '../../shared/compenents/components.dart';

class WorkerBookingScreen extends StatefulWidget {
  const WorkerBookingScreen({super.key});

  @override
  State<WorkerBookingScreen> createState() => _WorkerBookingScreenState();
}

class _WorkerBookingScreenState extends State<WorkerBookingScreen> {

  Widget buildDetailRow(String label, String value, String iconPath) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r)
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
                color: Colors.grey,
                fontSize: 12.sp
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ],
    );
  }
  List<Map<String, dynamic>> bookingsData = [
    {
      'id': 101,
      'status': 'مقبول',
      'title': 'تركيب حوض حمام مودرن',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '12,000 ريال',
      'address': 'عدن - المنصورة - ريمي',
      'dateTime': '18/2/2026 - 9:00 ص',
      'clientName': 'عبد المجيد محمد',
    },
    {
      'id': 102,
      'status': 'قيد الانتظار',
      'title': 'صيانة تكييف سبليت',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '8,500 ريال',
      'address': 'عدن - المعلا - الشارع الرئيسي',
      'dateTime': '18/2/2026 - 11:30 ص',
      'clientName': 'سالم ناصر',
    },
    {
      'id': 103,
      'status': 'مكتمل',
      'title': 'تسليك مجاري المطبخ',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '5,000 ريال',
      'address': 'عدن - كريتر - حي القطيع',
      'dateTime': '17/2/2026 - 4:00 م',
      'clientName': 'أحمد صبري',
    },
    {
      'id': 104,
      'status': 'مرفوض',
      'title': 'تركيب فلتر مياه 7 مراحل',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '15,000 ريال',
      'address': 'عدن - خور مكسر - حي السفارات',
      'dateTime': '16/2/2026 - 10:00 ص',
      'clientName': 'ليلى عبدالله',
    },
    {
      'id': 105,
      'status': 'في الطريق',
      'title': 'تغيير خلاطات مغاسل',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '7,000 ريال',
      'address': 'عدن - الشيخ عثمان - الممدارة',
      'dateTime': '19/2/2026 - 8:30 ص',
      'clientName': 'صالح محسن',
    },
    {
      'id': 106,
      'status': 'ملغي',
      'title': 'فحص تسريبات مياه تحت البلاط',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '20,000 ريال',
      'address': 'عدن - إنماء - المرحلة الثالثة',
      'dateTime': '20/2/2026 - 1:00 م',
      'clientName': 'مروان ياسين',
    },
    {
      'id': 107,
      'status': 'مكتمل',
      'title': 'تركيب سخان كهربائي',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '9,000 ريال',
      'address': 'عدن - دار سعد - حي الغربية',
      'dateTime': '15/2/2026 - 3:45 م',
      'clientName': 'عوض عمر',
    },
    {
      'id': 108,
      'status': 'مقبول',
      'title': 'عزل أسطح ضد الرطوبة',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '45,000 ريال',
      'address': 'عدن - البريقة - حي كود النمر',
      'dateTime': '21/2/2026 - 7:00 ص',
      'clientName': 'فؤاد خليل',
    },
    {
      'id': 109,
      'status': 'في الطريق',
      'title': 'صيانة مضخة مياه (دينمو)',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '6,500 ريال',
      'address': 'عدن - التواهي - حي القلوعة',
      'dateTime': '14/2/2026 - 12:00 م',
      'clientName': 'سمير علي',
    },
    {
      'id': 110,
      'status': 'قيد الانتظار',
      'title': 'تمديد شبكة مياه جديدة',
      'image': 'https://i.pinimg.com/1200x/8a/ad/ab/8aadabe22db683b98c994d8557962e42.jpg',
      'price': '55,000 ريال',
      'address': 'عدن - الشعب - حي الرباط',
      'dateTime': '22/2/2026 - 10:30 ص',
      'clientName': 'جمال مهدي',
    },
  ];
  List<String> statusFilters = ['الكل', 'قيد الانتظار', 'مقبول','في الطريق','مكتمل','مرفوض','ملغي'];
  String selectedStatus = 'الكل';


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = selectedStatus == 'الكل'
        ? bookingsData
        : bookingsData.where((item) => item['status'] == selectedStatus).toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'الحجوزات',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.sp,
              color: Colors.black
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      SvgPicture.asset('assets/not.svg'),
                      if (true)
                        CircleAvatar(
                          radius: 4.r,
                          backgroundColor: Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsetsDirectional.only(start: 10.w),
              itemCount: statusFilters.length,
              itemBuilder: (context, index) {
                return  Padding(
                  padding:  EdgeInsetsDirectional.only(
                      end:index==6?0: 15.w,
                  ),
                  child: ChoiceChip(
                    backgroundColor: Colors.grey.shade100,
                      selectedColor: mainColor.withOpacity(0.2),
                      label: Text(
                        statusFilters[index],
                      ),
                    selected: selectedStatus == statusFilters[index],
                    onSelected: (value){
                      setState(() {
                        selectedStatus = statusFilters[index];
                      });
                    },
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),


                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: ListView.builder(
                padding:  EdgeInsetsDirectional.only(start: 20.w,end: 20.w,top: 5.h,bottom: 20.h),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var booking = filteredList[index];
                  Color statusColor;
                  switch (booking['status']) {
                    case 'مكتمل': statusColor = Colors.green; break;
                    case 'مقبول': statusColor = Colors.blueAccent; break;
                    case 'في الطريق': statusColor = Colors.blueAccent; break;
                    case 'مرفوض': statusColor = Colors.redAccent; break;
                    case 'ملغي': statusColor = Colors.redAccent; break;
                    default: statusColor = Colors.orangeAccent;
                  }
                  return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: ()=>move(context,const WorkerOrderDetails()),
                    child: Padding(
                      padding:EdgeInsetsDirectional.only(bottom:index==9?0 : 20.h),
                      child: Container(
                        padding: EdgeInsetsDirectional.only(start: 10.w,end:10.w,top: 10.h,bottom: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: shadow
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.network(
                                    booking['image'],
                                    width: 90.w,
                                    height: 90.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 90.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          color: Colors.grey.shade100
                                      ),
                                      child: const Icon(Icons.wifi_off_rounded,size: 40,color: Colors.grey,),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: 10.w
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          booking['status']=='قيد الانتظار'?SizedBox(
                                     width: 100.w,
                                    child: Text(
                                      booking['title'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          height: 1.2
                                      ),
                                    ),
                                  )
                                              :booking['status']=='في الطريق'?SizedBox(
                                            width: 110.w,
                                            child: Text(
                                              booking['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  height: 1.2
                                              ),
                                            ),
                                          )
                                              :SizedBox(
                                            width: 130.w,
                                            child: Text(
                                              booking['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  height: 1.2
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 30.h,
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  booking['status'],
                                                  style: TextStyle(
                                                    color: statusColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11.sp,
                                                    height: 1.5
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 7.h
                                      ),
                                      Text(
                                      'رقم الطلب: ${booking['id']}',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.grey,
                                          height: 1
                                        ),
                                      ),
                                      SizedBox(
                                          height: 7.h
                                      ),
                                      Text(
                                        booking['price'],
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color:mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 10.h
                            ),
                            Container(
                              padding: const EdgeInsetsDirectional.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  buildDetailRow('العنوان:', booking['address'],'assets/loc.svg'),
                                   Padding(
                                     padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                     child: dashedDivider(),
                                   ),
                                  buildDetailRow('التاريخ والوقت:', booking['dateTime'],'assets/timer.svg'),
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
                                    child: dashedDivider(),
                                  ),
                                  buildDetailRow('العميل:', booking['clientName'],'assets/acc.svg'),
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
          ),
        ],
      ),
    );
  }
}