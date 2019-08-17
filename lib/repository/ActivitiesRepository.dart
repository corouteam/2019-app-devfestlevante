import 'dart:async';
import 'dart:collection';

import 'package:devfest_levante_2019/model/DevFestActivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest_levante_2019/model/DevFestMiniSpeaker.dart';
import 'package:devfest_levante_2019/model/DevFestUser.dart';

class ActivitiesRepository {
  static Stream<List<DevFestActivity>> getActivities() {
    return Firestore.instance
        .collection('sessions')
        .snapshots()
        .map((snapshot) => (activityMapper(snapshot)));
  }

  static Stream<List<DevFestActivity>> getActivitiesByDay(int day) {
    return Firestore.instance
        .collection('sessions')
        .orderBy("startsAt")
        .where("day", isEqualTo: day)
        .snapshots()
        .map((snapshot) => (activityMapper(snapshot)));
  }

  static getFavouriteActivities(List<dynamic> favourites) {
    return Firestore.instance
        .collection('sessions')
        .orderBy("startsAt")
        .snapshots()
        .map((snapshot) => (favouriteActivityMapper(snapshot, favourites)));
  }

  static List<DevFestActivity> favouriteActivityMapper(QuerySnapshot snapshot, List<dynamic> favourites) {
    List<DevFestActivity> activities = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      var parsedActivity = activityParser(document);

      if (favourites.contains(parsedActivity.id)) {
        activities.add(parsedActivity);
      }
    }
    return activities;
  }

  static List<DevFestActivity> activityMapper(QuerySnapshot snapshot) {
    List<DevFestActivity> activities = [];

    for (int i = 0; i < snapshot.documents.length; i++) {
      DocumentSnapshot document = snapshot.documents[i];
      activities.add(activityParser(document));

    }

    return activities;
  }

  static DevFestActivity activityParser(DocumentSnapshot document){
    int startsAt = document["startsAt"];
    int endsAt = document["endsAt"];
    var speakers = List<DevFestMiniSpeaker>();

    List<dynamic> speakersMap = document["speakers"];

    for (var speaker in speakersMap) {
      speakers.add(DevFestMiniSpeaker(speaker["id"], speaker["name"]));
    }

      return DevFestActivity(
          document["id"],
          "talk",
          document["title"],
          document["description"],
          "cover",
          "location",
          document["day"],
          DateTime.fromMillisecondsSinceEpoch(startsAt),
          DateTime.fromMillisecondsSinceEpoch(endsAt),
          speakers,
      "abstract");
    }
}
