import 'package:flutter/material.dart';
import 'package:newsdaily/bloc/tesla_bloc.dart';
import 'package:newsdaily/model/tesla_model.dart';
import 'package:newsdaily/ui/web_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TeslaBloc teslaBloc;
  static String type = "everything";
  var _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    teslaBloc = TeslaBloc();
    teslaBloc.getTesla();
  }

  Future<void> launchURL(String url) async {
    if (await launch(url)) {
      await launch(url,
          forceSafariVC: true, forceWebView: false, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<TeslaNewsModel>(
        stream: teslaBloc.teslaStream,
        builder: (context, snapshot) {
          return ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewContainer(
                              WebViewContainerArguments(
                                  snapshot.data!.articles[index].url,
                                  snapshot.data!.articles[index].title))),
                    );
                  },
                  child: Column(
                    children: [
                      if (index == 0)
                        Container(
                          margin: EdgeInsets.all(5),
                          height: 40,
                          //width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Search....',
                                suffixIcon: HomePageState.type != "everything"
                                    ? IconButton(
                                        onPressed: () {
                                          _controller.clear();
                                          HomePageState.type = "everything";
                                          teslaBloc.getTesla();
                                        },
                                        icon: Icon(Icons.close))
                                    : null,
                                contentPadding: EdgeInsets.all(3)),
                            onChanged: (value) {
                              HomePageState.type = value;
                              teslaBloc.getTesla();
                            },
                          ),
                        ),
                      Card(
                        elevation: 5,
                        child: Container(
                            height: 120,
                            margin: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (snapshot
                                            .data!.articles[index].urlToImage !=
                                        null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        child: Image.network(
                                          snapshot.data!.articles[index]
                                              .urlToImage!,
                                          height: 100,
                                          width: 150,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0)),
                                              child: Image.network(
                                                "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=20&m=922962354&s=170667a&w=0&h=mRTFds0L_Hq63ohdqIdHXMrE32DqOnajt4I0yJ1bBtU=",
                                                height: 100,
                                                width: 150,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        child: Image.network(
                                          "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=20&m=922962354&s=170667a&w=0&h=mRTFds0L_Hq63ohdqIdHXMrE32DqOnajt4I0yJ1bBtU=",
                                          height: 100,
                                          width: 150,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container();
                                          },
                                        ),
                                      ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.articles[index].title,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeAgo(DateTime.parse(snapshot
                                          .data!.articles[index].publishedAt)),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, int) {
                return Container();
              },
              itemCount: snapshot.data?.articles.length ?? 0);
        });
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("News Daily"),
          backgroundColor: Colors.black87,
          centerTitle: true,
        ),
        body: RefreshIndicator(
            child: _buildContent(context),
            color: Colors.black87,
            strokeWidth: 2,
            displacement: 1.0,
            onRefresh: () {
              return Future<void>(() => {
                    teslaBloc.getTesla(),
                  });
            }));
  }
}
