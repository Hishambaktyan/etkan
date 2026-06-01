import 'dart:convert';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trying_homy/shared/cubits/admin_cubit/admin_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:trying_homy/shared/cubits/auth_cubit/auth_cubit.dart';
import 'package:trying_homy/shared/cubits/bloc_observer.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_cubit.dart';
import 'package:trying_homy/shared/cubits/location_cubit/location_cubit.dart';
import 'package:trying_homy/shared/cubits/notification_cubit/notification_cubit.dart';
import 'package:trying_homy/shared/cubits/user_cubit/user_cubit.dart';
import 'package:trying_homy/shared/cubits/worker_cubit/worker_cubit.dart';
import 'package:trying_homy/shared/networks/local/cache_helper.dart';
import 'package:trying_homy/shared/styles/styles.dart';
import 'firebase_options.dart';
import 'layout/user_layout/user_main_screen.dart';
import 'layout/worker_layout/worker_main_screen.dart';
import 'modules/admin_screens/admin_home_screen.dart';
import 'modules/on_boarding.dart';
import 'modules/the_chat.dart';

void move(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
  );
}

void moveAndReplace(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
    (route) => false,
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

Map<String, dynamic>? pendingNotificationData;

const AndroidNotificationChannel highImportanceChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

Future<void> initLocalNotifications({bool requestPermission = true}) async {
  const androidSettings =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const settings = InitializationSettings(
    android: androidSettings,
  );

  await localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Local notification clicked while app running/background');
      print('Payload: ${response.payload}');

      if (response.payload == null || response.payload!.isEmpty) return;

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(response.payload!));

      final context = navigatorKey.currentContext;

      if (context != null) {
        NotificationCubit.get(context).handleNotificationData(data);
      } else {
        pendingNotificationData = data;
      }
    },
  );

  if (requestPermission) {
    final NotificationAppLaunchDetails? launchDetails =
        await localNotifications.getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails!.notificationResponse?.payload;

      print('App launched from local notification');
      print('Launch payload: $payload');

      if (payload != null && payload.isNotEmpty) {
        pendingNotificationData =
            Map<String, dynamic>.from(jsonDecode(payload));

        print('pendingNotificationData saved: $pendingNotificationData');
      }
    }
  }

  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(highImportanceChannel);

  if (requestPermission) {
    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}

Future<void> showLocalNotification(RemoteMessage message) async {
  final data = message.data;

  final String type = data['type']?.toString() ?? '';
  final String relatedId = data['relatedId']?.toString() ?? '';

  if (type == 'new_message' && TheChat.currentChatId == relatedId) {
    print('تم تجاهل إشعار الرسالة لأن المستخدم داخل نفس الدردشة');
    return;
  }

  final title = data['title']?.toString() ?? 'إشعار جديد';
  final body = data['body']?.toString() ?? '';

  await localNotifications.show(
    DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        highImportanceChannel.id,
        highImportanceChannel.name,
        channelDescription: highImportanceChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
      ),
    ),
    payload: jsonEncode(data),
  );
}

Widget startWidget = const OnBoardingScreen();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DartPluginRegistrant.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initLocalNotifications(requestPermission: false);

  print('رسالة وصلت في الخلفية: ${message.messageId}');
  print('Data: ${message.data}');

  await showLocalNotification(message);
}

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initLocalNotifications(requestPermission: true);

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolen(key: 'isDark');
  bool isLoggedIn = CacheHelper.getBoolen(key: 'isLoggedIn') ?? false;
  String role = CacheHelper.getData(key: 'role') ?? '';

  if (isLoggedIn) {
    if (role == 'user') {
      startWidget = const UserMainScreen();
    } else if (role == 'provider') {
      startWidget = const WorkerMainScreen();
    } else if (role == 'admin') {
      startWidget = const AdminHomeScreen();
    } else {
      startWidget = const OnBoardingScreen();
    }
  } else {
    startWidget = const OnBoardingScreen();
  }

  runApp(MyApp(isDark: isDark,));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  const MyApp({super.key, this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (context) => AppCubit()
            ..changeTheme(fromShared: isDark)
            ..getAllUsers(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
        BlocProvider<WorkerCubit>(
            create: (context) => WorkerCubit()..getWorkerData()),
        BlocProvider<AdminCubit>(
          create: (context) => AdminCubit()
            ..getAdminData()
            ..startListening(),
        ),
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit()..initFirebaseMessaging(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<AppCubit, AppStates>(
            builder: (context, state) {
              var appCubit = AppCubit.get(context);
              return MaterialApp(
                  navigatorKey: navigatorKey,
                  themeMode: appCubit.isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  debugShowCheckedModeBanner: false,
                  home: startWidget);
            },
          );
        },
      ),
    );
  }
}
/*import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:trying_homy/modules/images_view.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_cubit.dart';
import 'package:trying_homy/shared/cubits/app_cubit/app_states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_cubit.dart';
import 'package:trying_homy/shared/cubits/chat_cubit/chat_states.dart';
import '../main.dart';
import '../shared/compenents/components.dart';
import '../shared/styles/colors.dart';

class TheChat extends StatefulWidget {
  final String chatId;
  final String otherUsername;
  final String otherUserImage;
  final String otherUserId;
  final String myId;
  static String? currentChatId;
  final String requestId;
  const TheChat(
      {super.key,
      required this.otherUsername,
      required this.otherUserImage,
      required this.otherUserId,
      required this.myId,
      required this.chatId,
      required this.requestId});

  @override
  State<TheChat> createState() => _TheChatState();
}

class _TheChatState extends State<TheChat> {
  Stream<QuerySnapshot>? stream;

  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  FocusNode messageFocus = FocusNode();

  bool showScrollToBottomButton = false;

  Timer? typingTimer;
  bool isCurrentlyTyping = false;

  void setTypingStatus(bool typing) {
    if (isCurrentlyTyping == typing) return;

    isCurrentlyTyping = typing;

    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'typingStatus.${widget.myId}': typing,
    }).catchError((error) {
      print("Error updating typing status: $error");
    });
  }

  void clearTypingStatus() {
    typingTimer?.cancel();
    typingTimer = null;
    isCurrentlyTyping = false;

    FirebaseFirestore.instance.collection('chats').doc(widget.chatId).update({
      'typingStatus.${widget.myId}': false,
    }).catchError((error) {
      print("Error clearing typing status: $error");
    });
  }

  String? uploadingImageUrl;

  Future<void> pickAndSendImage({
    required ChatCubit chatCubit,
    required String chatId,
    required String receiverId,
    required String senderId,
  })
  async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedImage == null) return;
      if (!mounted) return;

      String? rText = replyMessage != null ? replyMessage!['text'] : null;

      String? rName = replyMessage != null
          ? (replyMessage!['senderId'] == senderId
              ? 'أنت'
              : widget.otherUsername)
          : null;

      setState(() {
        replyMessage = null;
        chatCubit.isTyping = false;
        uploadingImagePath = pickedImage.path;
      });

      clearTypingStatus();

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return;
        scrollToBottom();
      });

      final String imageUrl =
          await chatCubit.uploadImageToCloudinary(pickedImage.path);

      if (!mounted) return;

      await chatCubit.sendImageMessage(
        requestId: widget.requestId,
        chatId: chatId,
        receiverId: receiverId,
        senderId: senderId,
        imageUrl: imageUrl,
        replyText: rText,
        replyName: rName,
      );

      if (!mounted) return;

      setState(() {
        uploadingImageUrl = imageUrl;
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!mounted) return;
        scrollToBottom();
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        uploadingImagePath = null;
      });

      showSnackBar(
        Colors.red,
        'حدث خطأ أثناء إرسال الصورة',
        context,
      );
    }
  }

  Map<String, dynamic>? replyMessage;

  void onReply(Map<String, dynamic> message) {
    HapticFeedback.lightImpact();
    setState(() {
      replyMessage = message;
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      if (messageFocus.canRequestFocus) {
        messageFocus.requestFocus();
      }
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  String? uploadingImagePath;

  late ChatCubit chatCubit;

  @override
  void initState() {
    super.initState();

    chatCubit = context.read<ChatCubit>();

    chatCubit.resetUnreadCount(widget.chatId, widget.myId);

    scrollController.addListener(() {
      if (scrollController.position.pixels > 100) {
        if (!showScrollToBottomButton) {
          setState(() => showScrollToBottomButton = true);
        }
      } else {
        if (showScrollToBottomButton) {
          setState(() => showScrollToBottomButton = false);
        }
      }
    });

    stream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    chatCubit.markAsSeen(widget.chatId, widget.myId);
    TheChat.currentChatId = widget.chatId;
  }

  @override
  void dispose() {
    chatCubit.markAsSeen(widget.chatId, widget.myId);
    clearTypingStatus();
    typingTimer?.cancel();
    messageFocus.dispose();
    scrollController.dispose();
    TheChat.currentChatId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String otherUserImage = widget.otherUserImage;
    String otherUsername = widget.otherUsername;
    String otherUserId = widget.otherUserId;
    String myId = widget.myId;
    String requestId = widget.requestId;
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return BlocBuilder<ChatCubit, ChatStates>(
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            ChatCubit chatCubit = ChatCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  titleSpacing: 0,
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  title: Row(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => move(
                            context, ImageViewerPage(imageUrl: otherUserImage)),
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: otherUserImage.isNotEmpty
                              ? NetworkImage(otherUserImage)
                              : null,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          child: otherUserImage.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 22.r,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(otherUsername,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color)),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ))
                  ],
                ),
                body: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'حدث خطأ ما...):',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'حدث خطأ في تحميل الرسائل',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;
                    if (uploadingImageUrl != null &&
                        uploadingImagePath != null) {
                      final bool imageArrived = docs.any((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['type'] == 'image' &&
                            data['imageUrl'] == uploadingImageUrl;
                      });

                      if (imageArrived) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          setState(() {
                            uploadingImagePath = null;
                            uploadingImageUrl = null;
                          });

                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (!mounted) return;
                            scrollToBottom();
                          });
                        });
                      }
                    }

                    for (var doc in docs) {
                      var data = doc.data() as Map<String, dynamic>;
                      if (data['receiverId'] == widget.myId &&
                          data['messageStatus'] != 'seen') {
                        chatCubit.markAsSeen(widget.chatId, widget.myId);
                        break;
                      }
                    }
                    return Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: docs.isEmpty && uploadingImagePath == null
                                  ? Center(
                                      child: Text(
                                        'ابدأ المحادثة الآن',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      padding: EdgeInsetsDirectional.only(
                                          bottom: 10.h),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        if (uploadingImagePath != null &&
                                            index == 0) {
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                              vertical: 7.h,
                                              horizontal: 7.w,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        5.r),
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.75,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: appCubit.isDark
                                                      ? Colors.blue.shade800
                                                      : Colors.blue.shade700,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.r),
                                                    topRight:
                                                        Radius.circular(15.r),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            0),
                                                    bottomRight:
                                                        Radius.circular(15.r),
                                                  ),
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      child: Image.file(
                                                        File(
                                                            uploadingImagePath!),
                                                        width: 200.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 45.r,
                                                      height: 45.r,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.45),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.r),
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final realIndex =
                                            uploadingImagePath != null
                                                ? index - 1
                                                : index;

                                        var doc = docs[realIndex];
                                        var chatData =
                                            doc.data() as Map<String, dynamic>;
                                        bool isMe = chatData['senderId'] == myId
                                            ? true
                                            : false;
                                        return SwipeableMessage(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.symmetric(
                                                    vertical: 7.h,
                                                    horizontal: 7.w),
                                            child: Align(
                                              alignment: isMe
                                                  ? AlignmentDirectional
                                                      .centerEnd
                                                  : AlignmentDirectional
                                                      .centerStart,
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 10.w,
                                                        end: 10.w,
                                                        top: 8.h,
                                                        bottom: 2.h),
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75),
                                                decoration: BoxDecoration(
                                                  color: isMe
                                                      ? appCubit.isDark
                                                          ? Colors.blue.shade800
                                                          : Colors.blue.shade700
                                                      : appCubit.isDark
                                                          ? const Color(
                                                              0xFF1C2128)
                                                          : Colors.blue
                                                              .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.r),
                                                    topRight:
                                                        Radius.circular(15.r),
                                                    bottomLeft: isMe
                                                        ? const Radius.circular(
                                                            0)
                                                        : Radius.circular(15.r),
                                                    bottomRight: isMe
                                                        ? Radius.circular(15.r)
                                                        : const Radius.circular(
                                                            0),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: isMe
                                                      ? CrossAxisAlignment.end
                                                      : CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    if (chatData['replyText'] !=
                                                        null)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 5.h),
                                                        padding:
                                                            EdgeInsets.all(8.r),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          border: Border(
                                                            right: BorderSide(
                                                              color: isMe
                                                                  ? Colors
                                                                      .white70
                                                                  : mainColor,
                                                              width: 3.w,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              chatData[
                                                                      'replyName'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                color: isMe
                                                                    ? Colors
                                                                        .white
                                                                    : mainColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              chatData[
                                                                  'replyText'],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: isMe
                                                                    ? Colors
                                                                        .white70
                                                                    : Colors
                                                                        .grey
                                                                        .shade700,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    if (chatData['type'] ==
                                                        'image')
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () => move(
                                                                context,
                                                                ImageViewerPage(
                                                                    imageUrl:
                                                                        chatData['imageUrl'] ??
                                                                            '')),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.r),
                                                              child:
                                                                  Image.network(
                                                                chatData[
                                                                        'imageUrl'] ??
                                                                    '',
                                                                width: 200.w,
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return Container(
                                                                    width:
                                                                        200.w,
                                                                    height:
                                                                        160.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        const CircularProgressIndicator(),
                                                                  );
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Container(
                                                                    width:
                                                                        200.w,
                                                                    height:
                                                                        120.h,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.2),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .broken_image),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                        ],
                                                      )
                                                    else
                                                      Text(
                                                        chatData['text'] ?? '',
                                                        style: TextStyle(
                                                          color: isMe
                                                              ? Colors.white
                                                              : appCubit.isDark
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.9)
                                                                  : Colors
                                                                      .black,
                                                          fontSize: 13.sp,
                                                        ),
                                                      ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment: isMe
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          chatData['timestamp'] ==
                                                                  null
                                                              ? ''
                                                              : timeFormatStatusTime(
                                                                  chatData[
                                                                      'timestamp']),
                                                          style: TextStyle(
                                                              color: isMe
                                                                  ? Colors.green
                                                                      .shade100
                                                                  : Colors.grey,
                                                              fontSize: 8.sp),
                                                        ),
                                                        SizedBox(width: 3.w),
                                                        isMe
                                                            ? chatCubit
                                                                .buildMessageStatus(
                                                                chatData[
                                                                        'messageStatus'] ??
                                                                    'sent',
                                                                isMe,
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          onReply: () {
                                            onReply(chatData);
                                          },
                                        );
                                      },
                                      itemCount: docs.length +
                                          (uploadingImagePath != null ? 1 : 0)),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(widget.chatId)
                                  .snapshots(),
                              builder: (context, typingSnapshot) {
                                if (typingSnapshot.hasData &&
                                    typingSnapshot.data!.exists) {
                                  var data = typingSnapshot.data!.data()
                                      as Map<String, dynamic>;
                                  var typingMap = data['typingStatus']
                                      as Map<String, dynamic>?;
                                  bool isOtherTyping =
                                      typingMap?[widget.otherUserId] ?? false;

                                  if (isOtherTyping) {
                                    return AnimatedOpacity(
                                      opacity: isOtherTyping ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              start: 7.w),
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(
                                              horizontal: 3, vertical: 8),
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          decoration: BoxDecoration(
                                            color: appCubit.isDark
                                                ? lightDarkColor
                                                : Colors.blue.withOpacity(0.3),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.r),
                                              topRight: Radius.circular(15.r),
                                              bottomLeft: Radius.circular(15.r),
                                              bottomRight:
                                                  const Radius.circular(0),
                                            ),
                                          ),
                                          child: SpinKitThreeBounce(
                                            color: appCubit.isDark
                                                ? Colors.grey.shade300
                                                : Colors.grey,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return const SizedBox();
                              },
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(widget.requestId)
                                  .snapshots(),
                              builder: (context, requestSnapshot) {
                                if (requestSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }

                                if (!requestSnapshot.hasData ||
                                    !requestSnapshot.data!.exists) {
                                  return const SizedBox();
                                }

                                final requestData = requestSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                final String requestStatus =
                                    requestData['status']?.toString() ?? '';

                                final bool canSendMessage =
                                    requestStatus == 'مقبول' ||
                                        requestStatus == 'في الطريق';

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!canSendMessage)
                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsetsDirectional.symmetric(
                                            horizontal: 13.w),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.w),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.orange.withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          requestStatus == 'مكتمل'
                                              ? 'تم إغلاق المحادثة بعد اكتمال الحجز'
                                              : 'المحادثة متاحة بعد قبول الحجز',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange.shade800,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    Opacity(
                                      opacity: canSendMessage ? 1.0 : 0.45,
                                      child: AbsorbPointer(
                                        absorbing: !canSendMessage,
                                        child: Container(
                                          color: Colors.transparent,
                                          width: double.infinity,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                              start: 13.w,
                                              end: 13.w,
                                              bottom: 13.h,
                                              top: 5.h,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      color: appCubit.isDark
                                                          ? const Color(
                                                              0xFF161B22)
                                                          : Colors.grey
                                                              .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17.r),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (replyMessage !=
                                                            null)
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.r),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5.r),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: appCubit
                                                                      .isDark
                                                                  ? Colors.black
                                                                      .withOpacity(
                                                                          0.3)
                                                                  : Colors.white
                                                                      .withOpacity(
                                                                          0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.r),
                                                              border: Border(
                                                                right:
                                                                    BorderSide(
                                                                  color:
                                                                      mainColor,
                                                                  width: 4.w,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        replyMessage!['senderId'] ==
                                                                                myId
                                                                            ? 'أنت'
                                                                            : otherUsername,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              mainColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              12.sp,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        replyMessage!['text'] ??
                                                                            '',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              11.sp,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      replyMessage =
                                                                          null;
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 18.r,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        TextFormField(
                                                          key: const ValueKey('chat_message_input'),
                                                          controller:
                                                              chatCubit.message,
                                                          focusNode:
                                                              messageFocus,
                                                          enabled:
                                                              canSendMessage,
                                                          style: TextStyle(
                                                              fontSize: 12.sp),
                                                          minLines: 1,
                                                          maxLines: 5,
                                                          onChanged: (value) {
                                                            final bool typingNow = value.trim().isNotEmpty;

                                                            chatCubit.isTyping = typingNow;

                                                            typingTimer?.cancel();

                                                            if (typingNow) {
                                                              setTypingStatus(true);

                                                              typingTimer = Timer(
                                                                const Duration(seconds: 1),
                                                                    () {
                                                                  if (!mounted) return;
                                                                  setTypingStatus(false);
                                                                },
                                                              );
                                                            } else {
                                                              setTypingStatus(false);
                                                            }
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsetsDirectional
                                                                    .symmetric(
                                                              horizontal: 15.w,
                                                              vertical: 10.h,
                                                            ),
                                                            hintText: canSendMessage
                                                                ? 'اكتب رسالة...'
                                                                : 'المحادثة للقراءة فقط',
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 13.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                            suffixIcon: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    pickAndSendImage(
                                                                      chatCubit:
                                                                          chatCubit,
                                                                      chatId: widget
                                                                          .chatId,
                                                                      receiverId:
                                                                          otherUserId,
                                                                      senderId:
                                                                          myId,
                                                                    );
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/image.svg',
                                                                    height:
                                                                        23.h,
                                                                    width: 23.h,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        10.w),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Transform.scale(
                                                  scale: 0.9,
                                                  child: FloatingActionButton(
                                                    onPressed: () async {
                                                      if (chatCubit.message.text
                                                          .trim()
                                                          .isEmpty) {
                                                        return;
                                                      }

                                                      String? rText =
                                                          replyMessage != null
                                                              ? replyMessage![
                                                                  'text']
                                                              : null;

                                                      String? rName = replyMessage !=
                                                              null
                                                          ? (replyMessage![
                                                                      'senderId'] ==
                                                                  myId
                                                              ? 'أنت'
                                                              : widget
                                                                  .otherUsername)
                                                          : null;

                                                      setState(() {
                                                        replyMessage = null;
                                                        chatCubit.isTyping =
                                                            false;
                                                      });

                                                      clearTypingStatus();

                                                      await chatCubit
                                                          .sendMessage(
                                                        widget.chatId,
                                                        otherUserId,
                                                        myId,
                                                        requestId,
                                                        rText,
                                                        rName,
                                                      );

                                                      Future.delayed(
                                                        const Duration(
                                                            milliseconds: 50),
                                                        () {
                                                          if (!mounted) return;
                                                          scrollToBottom();
                                                        },
                                                      );
                                                    },
                                                    elevation: 0,
                                                    shape: const CircleBorder(),
                                                    backgroundColor: mainColor,
                                                    splashColor:
                                                        Colors.transparent,
                                                    child: Transform.rotate(
                                                      angle: 0.4,
                                                      child: Icon(
                                                        Icons.send_rounded,
                                                        color: Colors.white,
                                                        size: 25.h,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: showScrollToBottomButton ? 1.0 : 0.0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: showScrollToBottomButton ? 1.0 : 0.0,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  bottom: 100.h, end: 10.w),
                              child: FloatingActionButton.small(
                                heroTag: 'scroll_down',
                                backgroundColor: appCubit.isDark
                                    ? const Color(0xFF161B22)
                                    : Colors.white,
                                elevation: 4,
                                shape: const CircleBorder(),
                                onPressed: () => scrollToBottom(),
                                child: SvgPicture.asset(
                                  'assets/down.svg',
                                  width: 23.w,
                                  height: 23.h,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SwipeableMessage extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;

  const SwipeableMessage(
      {super.key, required this.child, required this.onReply});

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage> {
  double _offset = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _offset += details.delta.dx;
          if (_offset.abs() > 70) _offset = _offset.sign * 70;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_offset.abs() >= 50) {
          widget.onReply();
        }
        setState(() => _offset = 0.0);
      },
      onHorizontalDragCancel: () {
        setState(() {
          _offset = 0.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack, //  (Bounce)
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Stack(
          alignment: _offset > 0 ? Alignment.centerLeft : Alignment.centerRight,
          children: [
            if (_offset.abs() > 10)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.reply,
                  color:
                      mainColor.withOpacity((_offset.abs() / 70).clamp(0, 1)),
                  size: 25,
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}
*/