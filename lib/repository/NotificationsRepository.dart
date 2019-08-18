import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante_2019/model/DevFestNotification.dart';

class NotificationsRepository {
  static Stream<List<DevFestNotification>> getNotifications() {
    return Firestore.instance
        .collection('appNotifications')
        .orderBy("timestamp",
        descending: true)
        .snapshots()
        .map((snapshot) => (_parseFaq(snapshot)));
  }

  static List<DevFestNotification> _parseFaq(QuerySnapshot snapshot) {
    List<DevFestNotification> notifications = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      notifications.add(DevFestNotification(
          document["message"],
          DateTime.fromMillisecondsSinceEpoch(document["timestamp"])));
    }

    return notifications;
  }
}
