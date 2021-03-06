import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:devfest_levante_2019/repository/SpeakersRepository.dart';
import 'package:devfest_levante_2019/utils/ColorUtils.dart';
import 'package:devfest_levante_2019/utils/DevFestTabTextTheme.dart';
import 'package:devfest_levante_2019/ui/schedule/SingleSchedulePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SchedulePage extends StatelessWidget {
  SpeakersRepository speakersRepo;

  SchedulePage(this.speakersRepo);

  @override
  Widget build(BuildContext context) {
    var day = new DateTime.now().day;
    var index = day - 24;

    return DefaultTabController(
      initialIndex: index > 0 ? index : 0,
      length: 7,
      child: Column(
        children: <Widget>[
          TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: ColorUtils.hexToColor("#676767"),
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Colors.blueAccent,
              tabBarIndicatorSize: TabBarIndicatorSize.tab
            ),
            isScrollable: true,
            tabs: [
              Tab(child: DevFestTabTextTheme("Aug 24")),
              Tab(child: DevFestTabTextTheme("Aug 25")),
              Tab(child: DevFestTabTextTheme("Aug 26")),
              Tab(child: DevFestTabTextTheme("Aug 27")),
              Tab(child: DevFestTabTextTheme("Aug 28")),
              Tab(child: DevFestTabTextTheme("Aug 29")),
              Tab(child: DevFestTabTextTheme("Aug 30")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleSchedulePage(24, speakersRepo),
                SingleSchedulePage(25, speakersRepo),
                SingleSchedulePage(26, speakersRepo),
                SingleSchedulePage(27, speakersRepo),
                SingleSchedulePage(28, speakersRepo),
                SingleSchedulePage(29, speakersRepo),
                SingleSchedulePage(30, speakersRepo),
              ],
            ),
          )
        ],
      ),
    );
  }
}
