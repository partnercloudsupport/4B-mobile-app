import 'dart:async';
import 'package:flutter/material.dart';

import 'offer/offer_page.dart';
import 'welcome/welcome_page.dart';
import 'about_us/about_us_page.dart';
import 'login/login_page.dart';
import 'contact/contact_page.dart';

import '../trips/trips_page.dart';
import '../trips/map/map_page.dart';
import '../trips/schedule/schedule_page.dart';
import '../trips/news/news_page.dart';
import '../trips/about_country/about_country_page.dart';
import '../trips/visited_places/visited_places_page.dart';
import '../trips/important_info/important_info_page.dart';
import '../trips/contact/contact_page.dart';

HomePage gHomePage = new HomePage();
Color gGoldColor = Color(0xffffd700);

class MenuItem extends StatelessWidget {
  MenuItem(this.mId, this.mTitle, this.mPage, this.mVisibleWhenLogged);
  final String mId;
  final String mTitle;
  final Widget mPage;
  final bool mVisibleWhenLogged;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
            title: new Text(mTitle,
                style: new TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
            onTap: () {
              gHomePage.fChangePage(mId);
              Navigator.pop(context);
            }));
  }
}

class HomePageWidget extends StatefulWidget {
  @override
  HomePage createState() => gHomePage;
}

class HomePage extends State<HomePageWidget> {
  Map<String, MenuItem> mPageWidgetsMapAll = new Map<String, MenuItem>();
  Map<String, MenuItem> mPageWidgetsMapVisible = new Map<String, MenuItem>();
  bool mIsLogged = false;
  String mTitle;
  Widget mHomePageBody;

  @override
  void initState() {
    print("HomePage:initState");
    super.initState();

    mPageWidgetsMapAll[WelcomePage.Id] = new MenuItem(
        WelcomePage.Id, "4Business Team", new WelcomePageWidget(), false);
    mPageWidgetsMapAll[AboutUsPage.Id] =
        new MenuItem(AboutUsPage.Id, "O 4Business", new AboutUsWidget(), false);
    mPageWidgetsMapAll[OfferPage.Id] =
        new MenuItem(OfferPage.Id, "Oferta", new OfferWidget(), false);

    mPageWidgetsMapAll[TripsPage.Id] = new MenuItem(TripsPage.Id,
        "Drogi uczestniku, witamy w aplikacji!", new TripsWidget(), true);
    mPageWidgetsMapAll[AboutCountryPage.Id] = new MenuItem(
        AboutCountryPage.Id, "O kraju", new AboutCountryWidget(), true);
    mPageWidgetsMapAll[VisitedPlacesPage.Id] = new MenuItem(
        VisitedPlacesPage.Id,
        "Odwiedzane miejsca",
        new VisitedPlacesWidget(),
        true);
    mPageWidgetsMapAll[SchedulePage.Id] = new MenuItem(
        SchedulePage.Id, "Agenda wyjazdu", new ScheduleWidget(), true);
    mPageWidgetsMapAll[ImporatantInfoPage.Id] = new MenuItem(
        ImporatantInfoPage.Id,
        "Ważne informacje przed wyjazdem",
        new ImporatantInfoWidget(),
        true);
    mPageWidgetsMapAll[NewsPage.Id] =
        new MenuItem(NewsPage.Id, "Aktualności", new NewsWidget(), true);
    mPageWidgetsMapAll[MapPage.Id] =
        new MenuItem(MapPage.Id, "Mapa", new MapWidget(), true);
// ToDo: Implement better way to order MenuItems
    mPageWidgetsMapAll[MainContactPage.Id] = new MenuItem(
        MainContactPage.Id, "Kontakt", new MainContactWidget(), false);
    mPageWidgetsMapAll[LoginPage.Id] =
        new MenuItem(LoginPage.Id, "Zaloguj się", new LoginWidget(), false);
    mPageWidgetsMapAll[TripContactPage.Id] = new MenuItem(
        TripContactPage.Id, "Kontakt", new TripContactWidget(), true);

    fSetPage(WelcomePage.Id);
  }

  @override
  void dispose() {
    print("HomePage:dispose");
    super.dispose();
  }

  static Future<Null> fShowAlert(
      BuildContext context, String aTitle, String aBody) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(aTitle),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[new Text(aBody)],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext aContext) {
    print("HomePage:build:mIsLogged=" + mIsLogged.toString());
    mPageWidgetsMapVisible.clear();
    // ToDo: Refactor this
    mPageWidgetsMapAll.forEach((id, menuItem) {
      if (mIsLogged == menuItem.mVisibleWhenLogged &&
          mPageWidgetsMapAll[id].mId != WelcomePage.Id &&
          mPageWidgetsMapAll[id].mId != TripsPage.Id) {
        mPageWidgetsMapVisible[id] = menuItem;
      }
    });

    PreferredSizeWidget appBar;
    if (mTitle == mPageWidgetsMapAll[WelcomePage.Id].mTitle) {
      appBar = new PreferredSize(
          preferredSize: Size.fromHeight(150.0), // here the desired height
          child: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage("assets/images/app_bar_image.png"),
              fit: BoxFit.cover,
            )),
            child: AppBar(
              title: new Text(mTitle, style: new TextStyle(color: gGoldColor)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ));
    } else {
      appBar = new AppBar(
          title: new Text(mTitle, style: new TextStyle(color: gGoldColor)));
    }

    return new Scaffold(
        appBar: appBar,
        drawer: new Drawer(
          child: new ListView(
              padding: new EdgeInsets.fromLTRB(15.0, 50.0, 50.0, 0.0),
              children: mPageWidgetsMapVisible.values.toList()),
        ),
        body: mHomePageBody);
  }

  void fSetPage(String aId) {
    mTitle = mPageWidgetsMapAll[aId].mTitle;
    mHomePageBody = mPageWidgetsMapAll[aId].mPage;
  }

  void fChangePage(String aId) {
    print("HomePage:fChangePage:aId=" + aId);
    fSetPage(aId);
    setState(() {});
  }

  void fOnLoginSuccess() {
    print("HomePage:fOnLoginSuccess");
    mIsLogged = true;
    fShowAlert(context, "Sukces!", "Zalogowano pomyślnie!");
    fChangePage(TripsPage.Id);
  }
}
