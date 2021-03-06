import 'package:business_mobile_app/pages/home/offer/football/football_page.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatefulWidget {
  @override
  OfferPage createState() => new OfferPage();
}

class Event {
  Event(this.mWidget, this.mImagePath);
  Widget mWidget;
  String mImagePath;
}

class OfferPage extends State<OfferWidget> {
  static const String Id = "OfferPage";

  List<Event> mEventImagePathList = [
    new Event(
        new FootballPageWidget(), "assets/images/sport_events.png"),
    new Event(new FootballPageWidget(), "assets/images/incentive.png")
  ];

  void fShowEvent(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => mEventImagePathList[index].mWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Image.asset(mEventImagePathList[index].mImagePath),
          onTap: () => fShowEvent(index),
        );
      },
      itemCount: 2,
    );
  }
}
