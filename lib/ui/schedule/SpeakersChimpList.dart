import 'package:devfest_levante_2019/model/DevFestSpeaker.dart';
import 'package:flutter/material.dart';

class SpeakersChimpList extends StatelessWidget {
  List<DevFestSpeaker> speakers;
  String animId;
  
  SpeakersChimpList(this.speakers, this.animId);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: speakers.length,
        itemBuilder: (ctx, index) {
          var speaker = speakers[index];

          return Chip(
            backgroundColor: Colors.white,
            label: Text(speaker.name),
            avatar: CircleAvatar(backgroundImage: NetworkImage(speaker.pic)),
          );
    });
  }
}
