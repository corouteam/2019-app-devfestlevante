
import 'dart:async';

import 'package:devfest_levante_2019/model/DevFestUser.dart';
import 'package:devfest_levante_2019/repository/SpeakersRepository.dart';
import 'package:devfest_levante_2019/repository/UserRepository.dart';
import 'package:devfest_levante_2019/ui/NotificationsPage.dart';
import 'package:devfest_levante_2019/ui/SplashScreenPage.dart';
import 'package:devfest_levante_2019/ui/info/AboutPage.dart';
import 'package:devfest_levante_2019/ui/info/InfoPage.dart';
import 'package:devfest_levante_2019/ui/schedule/FavouriteSchedulePage.dart';
import 'package:devfest_levante_2019/ui/schedule/SchedulePage.dart';
import 'package:devfest_levante_2019/utils/LoadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return new MaterialApp(
        title: 'DevFest Levante 2018',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            fontFamily: "Lato"),

        // Before showing the Scaffold, we need the profile image for the appbar
        // So we build a Future with Firebase user request as future parameter
        home: FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),

          // The lambda in the builder will be run each time we have updated data from Firebase
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // Check if we're done downloading the user info
            if (snapshot.hasData) {
              // Now we can save user data in a variable
              FirebaseUser user = snapshot.data;

              return HomePageScaffold(user);
            } else {
              // Firebase has not returned data yet. Show loading screen
              // TODO: Maybe replace this with a loading dialog
              return Scaffold(body: Center(child: Text('Loading...')));
            }
          },
        ));
  }
}

class HomePageScaffold extends StatefulWidget {
  final FirebaseUser user;

  const HomePageScaffold(this.user);

  @override
  HomeScaffoldState createState() => new HomeScaffoldState(user);
}

class HomeScaffoldState extends State<HomePageScaffold> {
  FirebaseUser user;
  DevFestUser devFestUser;

  bool isReady;

  int tabPosition = 0;
  var currentPage;
  List<Widget> pages;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  HomeScaffoldState(this.user);

  @override
  void initState() {
    super.initState();

    isReady = false;

    setUpMessaging();

    SpeakersRepository.getSpeakers().then((speakers) {
      SpeakersRepository speakerRepo = SpeakersRepository.fromSpeakers(speakers);

      setState(() {
        pages = [SchedulePage(speakerRepo), FavouriteSchedulePage(user.uid, speakerRepo), AboutPage()];
        currentPage = pages[0];
        isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: LoadingWidget(),
      );
    }

    final Container navBar =
    Container(
      // WORKAROUND for material shadow: https://github.com/flutter/flutter/issues/27585
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6)]),
      child: BottomNavigationBar(
        currentIndex: tabPosition,
        onTap: (int pressedTab) {
          setState(() {
            tabPosition = pressedTab;
            currentPage = pages[pressedTab];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              title: Text(
                "Programma",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              title: Text(
                "Preferiti",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              title: Text(
                "Info",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ]),);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            NotificationsPage()));
              },
              icon: Icon(Icons.notifications,
              color: Colors.black87,),
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0.0,
          // Take user data
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Log out?"),
                        content: Text(
                            "Tutte le sesioni salvate e le preferenze rimarranno comunque sincronizzate con il tuo account."),
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              child: Text("Non ora"),
                              textColor: Colors.blueAccent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text("Log out"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SplashScreenPage()));
                              },
                            ),
                          )
                        ],
                      );
                    });
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(user.photoUrl)))),
              ),
            ),
          ),
          title: Text(
            "DevFest Levante",
            style: TextStyle(color: Colors.black),
          ),
        ),
        bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                primaryColor: Colors.blueAccent,
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.black54))),
            child: navBar),
        body: currentPage);
  }

  void setUpMessaging() {
    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("on Launch called");
      return null;
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
      return null;
    }, onMessage: (Map<String, dynamic> msg) {
      print("onMessage called");
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'devfest_levante', 'DevFest Levante', 'DevFest Levante',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(0,
          msg["notification"]["title"],
          msg["notification"]["body"],
          platformChannelSpecifics);

      print("onMessageee ${msg.toString()}");

      return null;
    });

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings) {
      print('IOS Settings Registed');
    });

    firebaseMessaging.getToken().then((token) async {
      UserRepository repo = UserRepository(user.uid);
      var devFestUser = DevFestUser();
      devFestUser.notificationToken = token;
      await repo.addFcmToken(devFestUser);
    });

    firebaseMessaging.subscribeToTopic("devfest_levante_2019");

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var androidLocalNotifications = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSLocalNotifications = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(androidLocalNotifications, iOSLocalNotifications);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }
}
