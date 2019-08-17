import 'package:devfest_levante_2019/model/DevFestSpeaker.dart';
import 'package:flutter/material.dart';

class SpeakersList extends StatelessWidget {
  List<DevFestSpeaker> speakers;
  String animId;
  
  SpeakersList(this.speakers);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: speakers.length,
        itemBuilder: (ctx, index) {
          var speaker = speakers[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " SPEAKER",
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(speaker.pic),
                    minRadius: 35.0,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          speaker.tagline != "" ? speaker.name+", "+speaker.tagline: speaker.name,
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.w500),

                        ),

                        SizedBox(
                          height: 8.0,
                        ),
                        CommunityChip(speaker),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                speaker.bio,
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 64.0,
              ),
            ],
          );
    });
  }
}

class CommunityChip extends StatelessWidget {
  DevFestSpeaker speaker;
  CommunityChip(this.speaker);

  @override
  Widget build(BuildContext context) {
    return ((speaker.tagline != "")
        ? Chip(
      label: Text(
        speaker.tagline,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurpleAccent,
    )
        : Container());
  }
}
