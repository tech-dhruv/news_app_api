import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_news_app/models/news_channel_headlines_model.dart';
import 'package:my_news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              'images/category_icon.png',
              width: 30,
            )),
        title: Text(
          "News",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }
              if (FilterList.independent.name == item.name) {
                name = 'independent';
              }
              if (FilterList.reuters.name == item.name) {
                name = '';
              }
              if (FilterList.cnn.name == item.name) {
                name = 'cnn';
              }
              if (FilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }

              setState(() {});
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews, child: Text("BBC News")),
              const PopupMenuItem<FilterList>(
                  value: FilterList.aryNews, child: Text("Ary News")),
              const PopupMenuItem<FilterList>(
                  value: FilterList.independent, child: Text("Independent")),
              const PopupMenuItem<FilterList>(
                  value: FilterList.reuters, child: Text("Reuters")),
              const PopupMenuItem<FilterList>(
                  value: FilterList.cnn, child: Text("CNN")),
              const PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera, child: Text("Al Jazeera"))
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlineApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        SpinKitSpinningLines(size: 50, color: Colors.black54),
                  );
                } else if (snapshot.data == null) {
                  return Center(
                    child: Text("No Data in Sources"),
                  );
                } else {
                  return ListView.builder(
                    //padding: EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                height: height * 0.5,
                                width: width * .9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * .01),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(child: spinKit2),
                                    errorWidget: (context, url, error) => Icon(
                                        Icons.error_outline,
                                        color: Colors.red),
                                  ),
                                )),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.bottomCenter,
                                  height: height * .22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: width * 0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              format
                                                  .format(dateTime)
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  static const spinKit2 = SpinKitCircle(
    color: Colors.amber,
    size: 50,
  );
}
