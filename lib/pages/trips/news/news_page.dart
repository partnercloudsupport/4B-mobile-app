import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/firebase_data.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/tile_info.dart';

final List<TileInfo> gNewsList = new List<TileInfo>();

void fGetNewsFromMemory() {
  String newsJson = gPrefs.getString(gNewsDatabaseKey);
  if (newsJson != null) {
    gNewsList.addAll(json.decode(newsJson).map<TileInfo>((newsInfo) {
      return new TileInfo(
          newsInfo['mId'], "news_info", newsInfo['mTitle'], newsInfo['mBody']);
    }).toList());
  }
}

void fAddNewsToList(aNewsId, aNewsInfo) {
  int newsId = fGetDatabaseId(aNewsId, 3);
  print("FirebaseData:fAddNewsToList");
  TileInfo newsInfo =
      new TileInfo(newsId, "news_info", aNewsInfo["title"], aNewsInfo["body"]);
  newsInfo.fLog();
  gNewsList.add(newsInfo);
}

class NewsWidget extends StatefulWidget {
  @override
  NewsPage createState() => new NewsPage();
}

class NewsPage extends State<NewsWidget> {
  static const String Id = "NewsPageWidget";
  static const String ImpId = "ImpNewsPageWidget"; // Temporary

  StreamSubscription<bool> mNewsStreamSubscription;

  @override
  void initState() {
    print("NewsPage:initState");
    super.initState();
    mNewsStreamSubscription = fGetStream(gNewsDatabaseKey).listen((aNewsInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("NewsPage:dispose");
    super.dispose();
    mNewsStreamSubscription.cancel();
    fCloseStream(gNewsDatabaseKey);
  }

  @override
  Widget build(BuildContext context) {
    print("NewsPage:build:gNewsList.length=" + gNewsList.length.toString());
    gNewsList.sort((firstNews, secondNews) {
      if (firstNews.mId > secondNews.mId) {
        return 1;
      } else {
        return -1;
      }
    });

    return new Scaffold(
        body: new ListView.builder(
            itemCount: gNewsList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                child: new ListTile(
                  title: new Text(gNewsList[index].mTitle,
                      style: new TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  subtitle: new Text(gNewsList[index].mBody),
                ),
              );
            }));
  }
}
