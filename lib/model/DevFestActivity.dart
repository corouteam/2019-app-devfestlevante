import 'package:devfest_levante_2019/model/DevFestMiniSpeaker.dart';

class DevFestActivity {
  String id;
  String title;
  String desc;
  String cover;
  int day;
  DateTime start;
  DateTime end;
  String type;
  List<DevFestMiniSpeaker>  speakersId = List();
  String abstract;
  String location;

  DevFestActivity.generic(this.id, this.type, this.title, this.desc, this.cover, this.location, this.day,
      this.start, this.end, this.abstract);

  DevFestActivity(this.id, this.type, this.title, this.desc, this.cover, this.location, this.day,
      this.start, this.end, this.speakersId, this.abstract);
}
