import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trying_homy/shared/styles/colors.dart';

class TheChat extends StatefulWidget {
  final String pfp;
  final String name;
  const TheChat({super.key, required this.pfp, required this.name});

  @override
  State<TheChat> createState() => _TheChatState();
}
class _TheChatState extends State<TheChat> {
  TextEditingController message = TextEditingController();
  bool isWriting = false;
  final List<Map<String, dynamic>> messages = [
    {
      'text': 'السلام عليكم، كيف حالك يا هندسة؟',
      'isMe': true,
      'time': '١٠:٠٠ ص',
      'status': 'delivered',
    },
    {
      'text': 'وعليكم السلام يا هلا، الحمدلله بخير ونعمة. كيف أقدر أخدمك؟',
      'isMe': false,
      'time': '١٠:٠٢ ص',
      'status': 'delivered',
    },
    {
      'text': 'لو سمحت عندي استفسار بخصوص الحوض اللي ركبناه الأسبوع الماضي',
      'isMe': true,
      'time': '١٠:٠٥ ص',
      'status': 'delivered',
    },
    {
      'text': 'تفضل، هل في أي مشكلة ظهرت؟',
      'isMe': false,
      'time': '١٠:٠٦ ص',
      'status': 'delivered',
    },
    // رسائل متتالية من العميل
    {
      'text': 'لا أبداً، التركيب ممتاز جداً ومافي أي تسريب',
      'isMe': true,
      'time': '١٠:٠٧ ص',
      'status': 'delivered',
    },
    {
      'text': 'بس كنت اشتي أسأل عن نوع المنظفات المناسبة للرخام عشان ما يبهت لونه مع الوقت',
      'isMe': true,
      'time': '١٠:٠٧ ص',
      'status': 'delivered',
    },
    {
      'text': 'وهل في مادة عازلة تنصحني أرشها فوقه؟',
      'isMe': true,
      'time': '١٠:٠٨ ص',
      'status': 'delivered',
    },
    // ردود متتالية منك
    {
      'text': 'سؤال مهم جداً.. بالنسبة للرخام، أهم شيء تبتعد عن الأحماض والليمون والكلور المركز',
      'isMe': false,
      'time': '١٠:١٠ ص',
      'status': 'delivered',
    },
    {
      'text': 'أفضل شيء تستخدم صابون سائل متعادل مع موية دافئة فقط',
      'isMe': false,
      'time': '١٠:١٠ ص',
      'status': 'delivered',
    },
    {
      'text': 'وبالنسبة للعازل، نعم في مادة "نانو" ممتازة جداً تحميه من البقع والسوائل، إذا تحب أجيبها معي الزيارة الجاية',
      'isMe': false,
      'time': '١٠:١١ ص',
      'status': 'delivered',
    },
    // رسائل جديدة لم تقرأ بعد
    {
      'text': 'يا ريت والله، متى تقدر تمر علي؟',
      'isMe': true,
      'time': '١٠:١٥ ص',
      'status': 'delivered',
    },
    {
      'text': 'عشان نخلص موضوع العازل مرة واحدة قبل ما يجي الوالد',
      'isMe': true,
      'time': '١٠:١٥ ص',
      'status': 'delivered',
    },
    {
      'text': 'تمام، بشوف الجدول وأرد عليك الخبر بعد قليل إن شاء الله 👍',
      'isMe': false,
      'time': '١٠:١٧ ص',
      'status': 'sent',
    },
  ];
  Widget buildMessageStatus(String status, bool isMe) {
    if (status == 'sent') {
      return SvgPicture.asset(
          'assets/check.svg',
        width: 15.w,
        height: 15.h,
        color: isMe? Colors.green.shade100 :Colors.grey
      );
    } else if (status == 'delivered') {
      return SvgPicture.asset(
          'assets/checks.svg',
          width: 15.w,
          height: 15.h,
          color: isMe? Colors.green.shade100 :Colors.grey
      );
    }
    return const SizedBox.shrink();
  }
  final ScrollController scrollController = ScrollController();
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }
  FocusNode messageFocus = FocusNode();
  bool showScrollToBottomButton = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
    messageFocus.addListener(() {
      if (messageFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 50), () {
          scrollToBottom();
        });
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels < scrollController.position.maxScrollExtent - 100) {
        if (!showScrollToBottomButton) {
          setState(() {
            showScrollToBottomButton = true;
          });
        }
      } else {
        if (showScrollToBottomButton) {
          setState(() {
            showScrollToBottomButton = false;
          });
        }
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String pfp = widget.pfp;
    String name = widget.name;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.back),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(pfp),
                radius: 20.r,
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                width: 170.w,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
          ],
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsetsDirectional.only(bottom: 20.h),
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        bool isMe = message['isMe'];
                        return Padding(
                          padding: EdgeInsetsDirectional.symmetric(vertical: 7.h,horizontal: 7.w),
                          child: Align(
                            alignment: isMe? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart ,
                            child: Container(
                              padding: const EdgeInsetsDirectional.all(15),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              decoration: BoxDecoration(
                                color: isMe?Colors.green.shade400 : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.r),
                                  topRight: Radius.circular(15.r),
                                  bottomLeft: isMe ? const Radius.circular(0) : Radius.circular(15.r) ,
                                  bottomRight: isMe ? Radius.circular(15.r) : const Radius.circular(0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['text'],
                                    style: TextStyle(
                                        color: isMe?Colors.white : Colors.black,
                                        fontSize: 12.sp
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min, // ليأخذ الصف مساحة محتواه فقط
                                    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['time'],
                                        style: TextStyle(
                                            color: isMe?Colors.green.shade100:Colors.grey,
                                            fontSize: 11.sp
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      isMe? buildMessageStatus(message['status'], isMe):const SizedBox(),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: messages.length
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 13.w,end: 13.w, bottom: 13.h,top: 5.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w, vertical: 5.h),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(17.r)),
                            child: TextFormField(
                              controller: message,
                              focusNode: messageFocus,
                              style: TextStyle(
                                fontSize: 12.sp
                              ),
                              minLines: 1,
                              maxLines: 5,
                              onChanged: (value) {
                                setState(() {
                                  isWriting = value.isNotEmpty;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: 'ارسل رسالة...',
                                hintStyle:
                                TextStyle(fontSize: 13.sp, color: Colors.grey),
                                border: InputBorder.none,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    !isWriting
                                        ? InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: SvgPicture.asset(
                                        'assets/camera.svg',
                                        height: 23.h,
                                        width: 23.h,
                                        color: Colors.grey,
                                      ),
                                    )
                                        :const SizedBox(),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: SvgPicture.asset(
                                        'assets/clip.svg',
                                        height: 23.h,
                                        width: 23.h,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        FloatingActionButton(
                          onPressed: (){
                            if(message.text.isNotEmpty){
                              final now = DateTime.now();
                              final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
                              final minute = now.minute.toString().padLeft(2, '0');
                              final period = now.hour >= 12 ? 'م' : 'ص';
                              final timeString = '$hour:$minute $period';
                              setState(() {
                                messages.add({
                                  'text': message.text,
                                  'isMe': true,
                                  'time': timeString,
                                  'status': 'sent',
                                });
                                message.clear();
                                scrollToBottom();
                              });
                            }
                          },
                          elevation: 0,
                          shape: const CircleBorder(),
                          backgroundColor: mainColor,
                          splashColor: Colors.transparent,
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 25.h,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedScale(duration: const Duration(milliseconds: 200),
              scale: showScrollToBottomButton ? 1.0 : 0.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: showScrollToBottomButton ? 1.0 : 0.0,
                child: Padding(
                  padding:  EdgeInsetsDirectional.only(bottom: 100.h,end: 10.w),
                  child: FloatingActionButton.small(
                    heroTag: 'scroll_down',
                    backgroundColor: Colors.white,
                      elevation: 4,
                      shape: const CircleBorder(),
                      onPressed: ()=>scrollToBottom(),
                    child: SvgPicture.asset(
                        'assets/down.svg',
                      width: 23.w,
                      height: 23.h,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
