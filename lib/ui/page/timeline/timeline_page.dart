import 'dart:async';

import 'package:flutter/material.dart';
import 'package:surveymyboatpro/logic/bloc/app_feed_bloc.dart';
import 'package:surveymyboatpro/logic/viewmodel/app_feed_view_model.dart';
import 'package:surveymyboatpro/model/app_feed.dart';
import 'package:surveymyboatpro/model/fetch_process.dart';
import 'package:surveymyboatpro/ui/widgets/api_subscription.dart';
import 'package:surveymyboatpro/ui/widgets/common_dialogs.dart';
import 'package:surveymyboatpro/ui/widgets/common_divider.dart';
import 'package:surveymyboatpro/ui/widgets/common_drawer.dart';
import 'package:surveymyboatpro/utils/uidata.dart';

class TimelinePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TimelinePageState();
  }
}

class TimelinePageState extends State<TimelinePage> {

  static Size? deviceSize;

  AppFeedBloc? _postBloc;
  StreamSubscription<FetchProcess>? _apiStreamSubscription;

  Widget displayWidget = progressWithBackground();
  
  //column1
  Widget profileColumn(BuildContext context, AppFeed post) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: new AssetImage(UIData.imbLogoIcon),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ))
        ],
      );

  //post cards
  Widget postCard(BuildContext context, AppFeed post) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileColumn(context, post),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.content,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  fontFamily: UIData.ralewayFont),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          post.image != null
              ? Image.memory(
                  post.image,
                  fit: BoxFit.cover,
                )
              : Container(),
          post.image != null ? Container() : CommonDivider(),
          //actionColumn(post),
        ],
      ),
    );
  }

  //allposts dropdown
  PreferredSizeWidget bottomBar() => PreferredSize(
      preferredSize: Size(double.infinity, 50.0),
      child: Container(
          color: Colors.black,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "All Posts",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          )));

  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        elevation: 2.0,
        title: Text("Feed"),
        forceElevated: true,
        pinned: true,
        floating: true,
        bottom: bottomBar(),
      );

  Widget bodyList(List<AppFeed> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: postCard(context, posts[index]),
          );
        }, childCount: posts.length),
      );

  void _refreshData() {
    _postBloc?.getAppFeeds(new AppFeedViewModel());
    _postBloc?.appFeeds.listen((appFeedList) {
      setState(() => displayWidget = _commonScaffold(appFeedList.elements!));
    });
  }

  Widget _commonScaffold(List<AppFeed> appFeeds) {
    return Scaffold(
      drawer: CommonDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          appBar(),
          bodyList(appFeeds),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    { deviceSize = MediaQuery.of(context).size; }
    return displayWidget;
  }

  @override
  initState() {
    super.initState();
    _postBloc = AppFeedBloc();
    _apiStreamSubscription =
        apiCallSubscription(_postBloc!.apiResult, context, widget: widget);
    _refreshData();
  }

  @override
  void dispose() {
    _apiStreamSubscription?.cancel();
    _postBloc?.dispose();
    super.dispose();
  }
}
