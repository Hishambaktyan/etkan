import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createNewChat({
  required String myId,
  required String otherId,
  required String myName,
  required String myImage,
  required String otherName,
  required String otherImage,
})
async {
  final chatId = FirebaseFirestore.instance.collection('chats').doc().id;

  await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
    'users': [myId, otherId],

    'lastMessage': '',
    'lastSenderId': '',
    'lastUpdate': FieldValue.serverTimestamp(),
    'isLastMessagesRead': true,

    'typingStatus': {
      myId: false,
      otherId: false,
    },

    'unreadCount': {
      myId: 0,
      otherId: 0,
    },

    'userInfo': {
      myId: {
        'name': myName,
        'image': myImage,
      },
      otherId: {
        'name': otherName,
        'image': otherImage,
      },
    },
  });
}


