import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AdminProviderMangament extends StatefulWidget {
  const AdminProviderMangament({super.key});

  @override
  State<AdminProviderMangament> createState() => _AdminProviderMangamentState();
}

class _AdminProviderMangamentState extends State<AdminProviderMangament> {
  final List<Map<String, String>> providers = [
    {
      'name': 'أحمد محمد',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'خالد علي',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'محمد سالم',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'علي حسن',
      'image': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'name': 'عمر عبدالله',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
    {
      'name': 'سارة أحمد',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'name': 'فاطمة خالد',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'name': 'مريم علي',
      'image': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'نورة سالم',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
    {
      'name': 'هند محمد',
      'image': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)
            ),
            title: Text(
              'إدارة الفنيّون',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
            actions: [
              IconButton(
                  onPressed: (){},
                  icon:  Icon(Icons.add_rounded,color: Colors.white,size: 30.w,)
              ),
              SizedBox(width: 5.w,),
            ],
          ),
          body: BlocBuilder<AppCubit,AppStates>(
            builder: (context, state) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 10.w,
                  mainAxisExtent: 255
                ),
                padding:  EdgeInsetsDirectional.symmetric(horizontal: 10.w,vertical: 20.h),
                itemCount: providers.length,
                itemBuilder:(context, index) {
                  final user = providers[index];
                  return Container(
                    decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(20.r)),
                          child: Image.network(
                            user['image']!,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 110,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20.r)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.all(15.w),
                          child: Column(
                            children: [
                              Text(
                                user['name']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              Text(
                                'كهربائي',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: IconButton(
                                        onPressed: (){},
                                        icon: SvgPicture.asset(
                                          'assets/whats.svg',
                                          color: mainColor,
                                        )
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20.r,
                                    child: IconButton(
                                        onPressed: (){},
                                        icon: SvgPicture.asset(
                                          'assets/phone.svg',
                                          color: mainColor,
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
    );
  }
}
