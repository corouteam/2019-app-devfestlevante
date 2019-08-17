
import 'package:devfest_levante_2019/model/DevFestActivity.dart';
import 'package:devfest_levante_2019/model/DevFestSpeaker.dart';
import 'package:devfest_levante_2019/model/DevFestUser.dart';
import 'package:devfest_levante_2019/repository/SpeakersRepository.dart';
import 'package:devfest_levante_2019/repository/UserRepository.dart';
import 'package:devfest_levante_2019/ui/schedule/SpeakersList.dart';
import 'package:devfest_levante_2019/utils/DateTimeHelper.dart';
import 'package:devfest_levante_2019/utils/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

String speakerName = "";
SpeakersRepository speakersRepo;

class TalkPage extends StatelessWidget {
  final DevFestActivity talk;
  final String userUid;

  TalkPage(this.talk, this.userUid, SpeakersRepository repo) {
    speakersRepo = repo;
  }

  UserRepository userRepo;

  share(){
      String speakerString = "";
      if (speakerName != "") {
        speakerString = "con $speakerName";
      }
      Share.share('${talk.title} $speakerString alla #DevFestLev18');

  }

  @override
  Widget build(BuildContext context) {
    userRepo = UserRepository(userUid);
    speakerName = "";
    return Scaffold(
        body: SingleChildScrollView(child: ActivityChipWidget(talk)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.share,), onPressed: share),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
          stream: userRepo.getUser(),
          builder: (context, data) {
            if (data.hasData) {
              DevFestUser devFestUser = data.data;
              var bookmarks;
              bookmarks = devFestUser.bookmarks;

              if (bookmarks == null) {
                bookmarks = List<String>();
              }

              if (bookmarks.contains(talk.id)) {
                return BookmarkWidget(userRepo, talk, devFestUser, true);
              } else {
                return BookmarkWidget(userRepo, talk, devFestUser, false);
              }
            } else {
              return LoadingWidget();
            }
          }),

    );
  }
}

class BookmarkWidget extends StatefulWidget {
  DevFestActivity talk;
  UserRepository userRepo;
  DevFestUser user;
  bool isBookmark;

  BookmarkWidget(this.userRepo, this.talk, this.user, this.isBookmark);

  @override
  _BookmarkWidgetState createState() => _BookmarkWidgetState(this.userRepo, this.talk, this.user, this.isBookmark);
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  UserRepository userRepo;
  DevFestActivity talk;
  DevFestUser user;
  bool isBookmark;

  _BookmarkWidgetState(this.userRepo, this.talk, this.user, this.isBookmark);

  @override
  Widget build(BuildContext context) {
    if (isBookmark) {
      return FloatingActionButton(
        onPressed: () {
        _bookmark(userRepo, talk, false);
        setState(() {
          isBookmark = false;
        });
        },
      child: Icon(Icons.favorite),);
    } else {
      return FloatingActionButton(
        onPressed: () {
        _bookmark(userRepo, talk, true);
        setState(() {
          isBookmark = true;
        });
        },
        child: Icon(Icons.favorite_border),);    }
  }
}


class TalkCoverWidget extends StatelessWidget {
  DevFestActivity activity;

  TalkCoverWidget(this.activity);

  @override
  Widget build(BuildContext context) {
    if (activity.cover != null) {
      return FadeInImage.assetNetwork(
          fit: BoxFit.fitWidth,
          placeholder: 'assets/talk_generic.jpg',
          image: activity.cover);
    } else {
      return Image(
        fit: BoxFit.fitWidth,
        image: AssetImage('assets/talk_generic.jpg'),
      );
    }
  }
}

abstract class GenericScheduleWidget extends StatelessWidget {
  final DevFestActivity activity;
  const GenericScheduleWidget(this.activity);
}

class ActivityChipWidget extends GenericScheduleWidget {
  ActivityChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            TalkCoverWidget(activity),
            SafeArea(
                child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white70,
              ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Text(
                  activity.title,
                  textScaleFactor: 2.0,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                DateTimeHelper.formatTalkDateTimeStart(activity.start) + " - "+ DateTimeHelper.formatTalkTimeEnd(activity.end),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                activity.location,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 28.0,
              ),
              AbstractWidget(activity),
              DescriptionWidget(activity),
              SizedBox(
                height: 48.0,
              ),
              SpeakerChipWidget(activity),
            ],
          ),
        ),
      ],
    );
  }
}

class SpeakerChipWidget extends GenericScheduleWidget {
  SpeakerChipWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    if (activity.type != "activity") {
      return SpeakersList(speakersRepo.getSpeakersById(activity.speakersId));
    } else {
      return Container();
    }
  }
}

class DescriptionWidget extends GenericScheduleWidget {
  DescriptionWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return ((activity.desc != null)
        ? Text(
            activity.desc,
            textAlign: TextAlign.justify,
          )
        : Container());
  }
}

class AbstractWidget extends GenericScheduleWidget {
  AbstractWidget(DevFestActivity activity) : super(activity);

  @override
  Widget build(BuildContext context) {
    return ((activity.abstract != null)
        ? Text(
            activity.abstract,
            textAlign: TextAlign.justify,
          )
        : Container());
  }
}

_bookmark(UserRepository userRepo, DevFestActivity talk, bool willAdd) {
  if (willAdd) {
    userRepo.addBookmark(talk.id);
  } else {
    userRepo.removeBookmark(talk.id);
  }
}

