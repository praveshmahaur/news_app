import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:top_news/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/news_channal_headlines_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, bbcsport, reuters, cnn, abcNews}

class _HomeScreenState extends State<HomeScreen> {
  FilterList? selectedMenu;
  final format = DateFormat('MMMM d, yyyy');

  String name = 'bbc-news';
  NewsViewModel newsViewModel= NewsViewModel();



  @override
  Widget build(BuildContext context) {
    final height= MediaQuery.sizeOf(context). height*1;
    final width= MediaQuery.sizeOf(context). width*1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){

          },
          icon: Image.asset("images/category_icon.png",
            height: 20,
            width: 20,
          ),
        ),
        centerTitle: true,
        title: Text("News",style: GoogleFonts.poppins(
          fontSize: 20,fontWeight: FontWeight.w700,
        ),),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item){


                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.bbcsport.name == item.name){
                  name = 'bbc-sport';
                }


                setState(() {

                 selectedMenu = item;
                 newsViewModel.fetchNewsChannalHeadlinesApi();
                });


              } ,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews ,
                    child: Text("BBC News"),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.aryNews ,
                  child: Text("Ary News"),
                ),
                PopupMenuItem<FilterList>(
                  value: FilterList.bbcsport ,
                  child: Text("BBC sport"),
                ),

              ]
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height* .5,
            width: width,
            child: FutureBuilder<NewsChannalHeadlinesModel>(
              future:newsViewModel.fetchNewsChannalHeadlinesApi(),
              builder: (BuildContext context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ) ,
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length ,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){

                      DateTime dateTime= DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height* 0.6,
                                width: width* 0.9,
                                padding: EdgeInsets.symmetric(
                                    horizontal: height *0.02 ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(child: spinkit2,),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline,
                                    color: Colors.red,),

                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5 ,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ) ,
                                  child:Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(15),
                                    height: height * 0.2,
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(snapshot.data!.articles![index].title.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),
                                          ) ,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600,
                                                color: Colors.lightBlue),
                                              ),
                                              Text(format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ) ,
                                  ) ,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
              },

            ),
          )
        ],
      ),
    );
  }

}

const spinkit2=SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);