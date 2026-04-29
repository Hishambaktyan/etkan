import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/compenents/components.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class AddressesManagementScreen extends StatefulWidget {
  const AddressesManagementScreen({super.key});

  @override
  State<AddressesManagementScreen> createState() =>
      _AddressesManagementScreenState();
}

class _AddressesManagementScreenState extends State<AddressesManagementScreen> {
  final List<Map<String, dynamic>> addresses = [
    {
      'title': 'المنزل',
      'area': 'كريتر',
      'street': 'شارع أروى',
      'details': 'بجانب الصيدلية، الدور الثاني',
      'type': 'المنزل',
      'isDefault': true,
    },
    {
      'title': 'العمل',
      'area': 'خور مكسر',
      'street': 'شارع المطار',
      'details': 'مبنى الأعمال، الدور الثالث',
      'type': 'العمل',
      'isDefault': false,
    },
  ];

  final List<String> addressTypes = [
    'المنزل',
    'العمل',
    'أخرى',
  ];

  Widget _buildHeaderCard(AppCubit cubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            mainColor,
            mainColor.withOpacity(0.75),
          ],
        ),
        boxShadow: cubit.isDark
            ? []
            : [
                BoxShadow(
                  color: mainColor.withOpacity(0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 34.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إدارة العناوين',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7.h),
                Text(
                  'أضف وعدّل عناوينك لاستخدامها عند إنشاء طلب خدمة جديد.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AppCubit cubit) {
    int defaultIndex =
        addresses.indexWhere((item) => item['isDefault'] == true);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: cubit.isDark
            ? Border.all(color: const Color(0xFF30363D))
            : Border.all(color: Colors.grey.shade200),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.home_work_outlined,
              color: mainColor,
              size: 23.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عدد العناوين المحفوظة',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  defaultIndex == -1
                      ? 'لا يوجد عنوان افتراضي'
                      : 'العنوان الافتراضي: ${addresses[defaultIndex]['title']}',
                  style: TextStyle(
                    color: cubit.isDark ? darkSubTextColor : Colors.grey,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Text(
              '${addresses.length}',
              style: TextStyle(
                color: mainColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(AppCubit cubit) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.bookmark_border_rounded,
            color: mainColor,
            size: 20.r,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'العناوين المحفوظة',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getAddressIcon(String type) {
    if (type == 'العمل') return Icons.business_center_outlined;
    if (type == 'أخرى') return Icons.location_city_outlined;
    return Icons.home_outlined;
  }

  Widget _buildAddressCard({
    required AppCubit cubit,
    required Map<String, dynamic> address,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: address['isDefault']
              ? mainColor
              : cubit.isDark
                  ? const Color(0xFF30363D)
                  : Colors.grey.shade200,
          width: address['isDefault'] ? 1.3 : 1,
        ),
        boxShadow: cubit.isDark ? [] : shadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(11.r),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  _getAddressIcon(address['type']),
                  color: mainColor,
                  size: 25.r,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            address['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (address['isDefault']) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(
                              'افتراضي',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      address['area'],
                      style: TextStyle(
                        color: cubit.isDark ? darkSubTextColor : Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                color: cubit.isDark ? lightDarkColor : Colors.white,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showAddressSheet(
                      cubit: cubit,
                      index: index,
                      oldAddress: address,
                    );
                  } else if (value == 'default') {
                    _setDefaultAddress(index);
                  } else if (value == 'delete') {
                    _deleteAddress(index);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              color: mainColor, size: 20.r),
                          SizedBox(width: 8.w),
                          const Text('تعديل'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'default',
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.green, size: 20.r),
                          SizedBox(width: 8.w),
                          const Text('تعيين كافتراضي'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: Colors.red, size: 20.r),
                          SizedBox(width: 8.w),
                          const Text(
                            'حذف',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color:
                  cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
              height: 1,
            ),
          ),
          _buildInfoRow(
            cubit: cubit,
            icon: Icons.signpost_outlined,
            title: 'الشارع',
            value: address['street'],
          ),
          SizedBox(height: 10.h),
          _buildInfoRow(
            cubit: cubit,
            icon: Icons.edit_location_alt_outlined,
            title: 'الوصف',
            value: address['details'],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  title: 'تعديل',
                  icon: Icons.edit_outlined,
                  color: mainColor,
                  onTap: () {
                    _showAddressSheet(
                      cubit: cubit,
                      index: index,
                      oldAddress: address,
                    );
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildSmallButton(
                  title: address['isDefault'] ? 'افتراضي' : 'جعله افتراضي',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  onTap: () {
                    _setDefaultAddress(index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required AppCubit cubit,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: cubit.isDark ? darkSubTextColor : Colors.grey,
          size: 18.r,
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 55.w,
          child: Text(
            title,
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
              color: cubit.isDark ? Colors.white : Colors.black87,
              fontSize: 12.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.r),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppCubit cubit) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(25.r),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_outlined,
                color: mainColor,
                size: 55.r,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'لا توجد عناوين محفوظة',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'أضف عنوانك الأول لاستخدامه عند طلب الخدمة',
              style: TextStyle(
                color: cubit.isDark ? darkSubTextColor : Colors.grey,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setDefaultAddress(int index) {
    setState(() {
      for (int i = 0; i < addresses.length; i++) {
        addresses[i]['isDefault'] = false;
      }
      addresses[index]['isDefault'] = true;
    });

    showSnackBar(
      Colors.green,
      'تم تعيين العنوان كافتراضي',
      context,
    );
  }

  void _deleteAddress(int index) {
    bool wasDefault = addresses[index]['isDefault'];

    setState(() {
      addresses.removeAt(index);

      if (wasDefault && addresses.isNotEmpty) {
        addresses[0]['isDefault'] = true;
      }
    });

    showSnackBar(
      Colors.red,
      'تم حذف العنوان',
      context,
    );
  }

  Widget _buildSheetTextField({
    required AppCubit cubit,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: cubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade200,
        ),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            color: cubit.isDark ? darkSubTextColor : Colors.grey,
            fontSize: 12.sp,
          ),
          prefixIcon: Icon(
            icon,
            color: mainColor,
            size: 22.r,
          ),
        ),
      ),
    );
  }

  void _showAddressSheet({
    required AppCubit cubit,
    int? index,
    Map<String, dynamic>? oldAddress,
  }) {
    TextEditingController titleController = TextEditingController(
      text: oldAddress == null ? '' : oldAddress['title'],
    );
    TextEditingController areaController = TextEditingController(
      text: oldAddress == null ? '' : oldAddress['area'],
    );
    TextEditingController streetController = TextEditingController(
      text: oldAddress == null ? '' : oldAddress['street'],
    );
    TextEditingController detailsController = TextEditingController(
      text: oldAddress == null ? '' : oldAddress['details'],
    );

    String selectedType = oldAddress == null ? 'المنزل' : oldAddress['type'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cubit.isDark ? darkBgColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 18.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 45.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: cubit.isDark
                              ? Colors.white24
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              oldAddress == null
                                  ? Icons.add_location_alt_outlined
                                  : Icons.edit_location_alt_outlined,
                              color: mainColor,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            oldAddress == null
                                ? 'إضافة عنوان جديد'
                                : 'تعديل العنوان',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 4.h),
                        margin: EdgeInsets.only(bottom: 14.h),
                        decoration: BoxDecoration(
                          color: cubit.isDark ? lightDarkColor : Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: cubit.isDark
                                ? const Color(0xFF30363D)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedType,
                          borderRadius: BorderRadius.circular(15.r),
                          dropdownColor:
                              cubit.isDark ? lightDarkColor : Colors.white,
                          decoration: InputDecoration(
                            labelText: 'نوع العنوان',
                            labelStyle: TextStyle(
                              color:
                                  cubit.isDark ? darkSubTextColor : Colors.grey,
                              fontSize: 12.sp,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.category_outlined,
                              color: mainColor,
                              size: 22.r,
                            ),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: cubit.isDark ? Colors.white70 : Colors.grey,
                          ),
                          items: addressTypes.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                      ),
                      _buildSheetTextField(
                        cubit: cubit,
                        controller: titleController,
                        label: 'اسم العنوان',
                        icon: Icons.bookmark_border_rounded,
                      ),
                      _buildSheetTextField(
                        cubit: cubit,
                        controller: areaController,
                        label: 'المنطقة',
                        icon: Icons.map_outlined,
                      ),
                      _buildSheetTextField(
                        cubit: cubit,
                        controller: streetController,
                        label: 'الشارع أو الحي',
                        icon: Icons.signpost_outlined,
                      ),
                      _buildSheetTextField(
                        cubit: cubit,
                        controller: detailsController,
                        label: 'تفاصيل إضافية',
                        icon: Icons.edit_location_alt_outlined,
                        maxLines: 2,
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (titleController.text.trim().isEmpty ||
                                areaController.text.trim().isEmpty ||
                                streetController.text.trim().isEmpty) {
                              showSnackBar(
                                Colors.red,
                                'يرجى تعبئة البيانات المطلوبة',
                                context,
                              );
                              return;
                            }

                            setState(() {
                              Map<String, dynamic> newAddress = {
                                'title': titleController.text.trim(),
                                'area': areaController.text.trim(),
                                'street': streetController.text.trim(),
                                'details': detailsController.text.trim(),
                                'type': selectedType,
                                'isDefault':
                                    oldAddress == null && addresses.isEmpty
                                        ? true
                                        : oldAddress?['isDefault'] ?? false,
                              };

                              if (index == null) {
                                addresses.add(newAddress);
                              } else {
                                addresses[index] = newAddress;
                              }
                            });

                            Navigator.pop(context);

                            showSnackBar(
                              Colors.green,
                              oldAddress == null
                                  ? 'تم إضافة العنوان بنجاح'
                                  : 'تم تعديل العنوان بنجاح',
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            oldAddress == null
                                ? 'إضافة العنوان'
                                : 'حفظ التعديل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
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
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'إدارة العناوين',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 100.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(cubit),
                  SizedBox(height: 16.h),
                  _buildSummaryCard(cubit),
                  SizedBox(height: 25.h),
                  _buildSectionTitle(cubit),
                  SizedBox(height: 15.h),
                  addresses.isEmpty
                      ? _buildEmptyState(cubit)
                      : Column(
                          children: List.generate(
                            addresses.length,
                            (index) => _buildAddressCard(
                              cubit: cubit,
                              address: addresses[index],
                              index: index,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                top: 10.h,
                bottom: 20.h,
              ),
              decoration: BoxDecoration(
                color: cubit.isDark ? darkBgColor : Colors.white,
                boxShadow: cubit.isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
              ),
              child: SizedBox(
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddressSheet(cubit: cubit);
                  },
                  icon: Icon(
                    Icons.add_location_alt_outlined,
                    color: Colors.white,
                    size: 21.r,
                  ),
                  label: Text(
                    'إضافة عنوان جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
