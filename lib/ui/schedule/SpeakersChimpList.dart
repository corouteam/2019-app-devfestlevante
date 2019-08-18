import 'package:devfest_levante_2019/model/DevFestSpeaker.dart';
import 'package:flutter/material.dart';

class SpeakersChimpList extends StatelessWidget {
  List<DevFestSpeaker> speakers;
  String animId;
  
  SpeakersChimpList(this.speakers, this.animId);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        itemCount: speakers.length,
        itemBuilder: (ctx, index) {
          var speaker = speakers[index];

          return Container(
            alignment: Alignment.bottomLeft,
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(speaker.name),
              avatar: CircleAvatar(backgroundImage: NetworkImage(speaker.pic)),
            ),
          );
    });
  }
}
