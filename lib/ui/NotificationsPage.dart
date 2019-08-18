import 'package:devfest_levante_2019/model/DevFestNotification.dart';
import 'package:devfest_levante_2019/repository/NotificationsRepository.dart';
import 'package:devfest_levante_2019/utils/DateTimeHelper.dart';
import 'package:devfest_levante_2019/utils/LoadingWidget.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      centerTitle: true,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        color: Colors.black54,
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      // Take user data
      title: Text(
        "Notifications",
        style: TextStyle(color: Colors.black),
      ),
    ),
      body: StreamBuilder(
        stream: NotificationsRepository.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text("No new notification!"),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                DevFestNotification notification = snapshot.data[i];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.notifications_none,
                    color: Colors.white,),
                    backgroundColor: Colors.black45,
                  ),
                  title: Text(notification.body),
                  subtitle: Text(DateTimeHelper.formatToHumanReadableDifference(
                      notification.timestamp)),
                );
              },
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }
}
