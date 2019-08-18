import 'package:devfest_levante_2019/utils/UrlHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Center(child: Text("DevFest Levante 2019 Official App", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)),
          Padding(
            padding: const EdgeInsets.only(top:16.0),
            child: Center(child: Text("Made with ♥ in Flutter by")),
          ),
          Center(child: Text("Corouteam", style: TextStyle(fontSize: 20.0),)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: PersonWidget("The\nOpenSourcer", "https://avatars0.githubusercontent.com/u/5623301?s=460&v=4")),
                Expanded(child: PersonWidget("The\nMacBook Slayer", "https://scontent-mxp1-1.xx.fbcdn.net/v/t1.0-9/18485429_10208858388241944_3886175293398476643_n.jpg?_nc_cat=107&_nc_oc=AQlwRl-o2xa4tHXNyXZYvAfCam1j1UmkAOkTMmqocgLVIFvzGkBbVd_xhwsa_9DznIY&_nc_ht=scontent-mxp1-1.xx&oh=c8d47209f29d5fc372486b7809a05a97&oe=5DD5BE10")),
                Expanded(child: PersonWidget("GIT worst\nNightmare", "https://scontent-mxp1-1.xx.fbcdn.net/v/t1.0-9/26815441_1539794166116027_3328025931532357730_n.jpg?_nc_cat=107&_nc_oc=AQnBk0x0mJ--ZSYWpblp97DgHoXbM5vKf_0Q09BbfCRS0Oaj1Hg9ZgK3LcJaxLtP5tI&_nc_ht=scontent-mxp1-1.xx&oh=5ffaab3d2a655f93158e842cc65b4178&oe=5DDEFC33")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: <Widget>[
                Text("with the help of some friends at"),
                Text("GDG Bari", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: PersonWidget("The\nFirebaser", "https://media.licdn.com/dms/image/C5603AQHwO78I_1dy6A/profile-displayphoto-shrink_200_200/0?e=1567036800&v=beta&t=lTqUX0uih45-1gllEmbzyjTr36BeVF558gDM18NGz1Q"),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("https://devfestlevante.eu/faq/"),
            title: Text("FAQ", style: TextStyle(color: Colors.blueAccent),),
            subtitle: Text("Find more about DevFest Levante"),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("https://github.com/corouteam/2019-app-devfestlevante"),
            title: Text("Source Code", style: TextStyle(color: Colors.blueAccent),),
            subtitle: Text("Available on GitHub"),
          ),
          ListTile(
            onTap: () =>
                showLicensePage(
                    context: context,
                    applicationName: "DevFest Levante 2019",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "Copyright 2019 © Corouteam"),
            title: Text("Open Source Licences", style: TextStyle(color: Colors.blueAccent),),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("http://devfestlevante.eu"),
            title: Text("Official Website", style: TextStyle(color: Colors.blueAccent),),
          ),
          ListTile(
            onTap: () => UrlHelper.launchURL("https://www.facebook.com/GDGBari/"),
            title: Text("Contact us", style: TextStyle(color: Colors.blueAccent),),
          ),
        ],
      ),
    );
  }

  void showLicensePage({
    @required BuildContext context,
    String applicationName,
    String applicationVersion,
    Widget applicationIcon,
    String applicationLegalese
  }) {
    assert(context != null);
    Navigator.push(context, new MaterialPageRoute<void>(
        builder: (BuildContext context) => new LicensePage(
            applicationName: applicationName,
            applicationVersion: applicationVersion,
            applicationLegalese: applicationLegalese
        )
    ));
  }
}

class PersonWidget extends StatelessWidget {
  final String url;
  final String desc;

  const PersonWidget(this.desc, this.url);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        CircleAvatar(
            backgroundImage: NetworkImage(url),
        radius: 50.0,),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(desc, textAlign: TextAlign.center),
        ),
      ],
    );
  }

}