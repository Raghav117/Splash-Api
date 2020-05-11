import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';


//!    ***********************  Main Function ***********************************
void main() => runApp(
  MaterialApp(
    title: "Splash Api",
    debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));


//!    ***********************  Class MyApp ***********************************

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController2 = new ScrollController();

  var now = new DateTime.now();
  int count,count2;
  List data,data2;
  bool loading,loading2;
  List image,image2;
  int x,x2;
  
  int page,page2;
  @override
  void initState() {
    loading = true;
    loading2 = true;
    count2=0;
    count=0;
    x=1;
    x2=1;
    data = new List();
    data2 = new List();
    page=1;
    page2=1;
    super.initState();
    this.getjsondata();
    this.getjsondata2();


    _scrollController.addListener(() {      //!      Scroll Controller listner for first List View
      if(count!=0){
        if(_scrollController.position.pixels.toInt()~/count!=x-1){
          x=_scrollController.position.pixels.toInt()~/count + 1;
          setState(() {});
        }
      }
      
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if (count==0)
        {
          count=_scrollController.position.pixels.toInt();
          ++x;
        }
        ++page;
        getjsondata();
      }
    });


    _scrollController2.addListener(() {    //!      Scroll Controller listner for Second List View
      if(count2!=0){
        if(_scrollController2.position.pixels.toInt()~/count2!=x2-1){
          x2=_scrollController2.position.pixels.toInt()~/count2 + 1;
          setState(() {});
        }
      }
      
      if(_scrollController2.position.pixels == _scrollController2.position.maxScrollExtent){
        if (count2==0)
        {
          count2=_scrollController2.position.pixels.toInt();
          ++x2;
        }
        ++page2;
        getjsondata2();
      }
    });
  }

  //!   *******************   Fetching Data from Splash API for collection Pattern and Textures  *******************
  Future<String> getjsondata() async {
    try {
      var response = await http.get(
          'https://api.unsplash.com/collections/175083/photos?client_id=2y0SIID4GZHZ11KCpmSSdPi_giQg_MsZTIs_UHLITOI&page=$page');
      setState(() {
        image = json.decode(response.body);
        loading=false;
        
        for (var i in image){
          data.add(i);
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return 'success';
  }

  //!   *******************   Fetching Data from Splash API for collection The Writer's Collection  *******************


Future<String> getjsondata2() async {

    try {
      var response = await http.get(
          'https://api.unsplash.com/collections/159602/photos?client_id=it1PXzVQRnxgz8v8hazcst7G9rNfXk1qiS8FgHTTMMk&page=$page2');
        image2 = json.decode(response.body);
        loading2 = false;

      setState(() {

        for (var i in image2){
          data2.add(i);
        }
      });
    } catch (e) {}
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
              child: Scaffold(

            appBar: AppBar(
              title: Text("Splash Api"),
              centerTitle: true,
              backgroundColor: Colors.brown,
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text("Patterns and Textures"),
                  ),
                  Tab(
                    child: Text("The Writer's Collection"),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              
              children: [
                loading == false?Stack(
                  children: [
                    Container(
                      
                      child: new ListView.builder(
                        controller: _scrollController,

                    itemCount: data == null ? 0 : data.length~/2,

                    itemBuilder: (BuildContext context, int index) {

                      
                      return 
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Image.network(
                                  data[2*index]['urls']['small'],
                                  fit: BoxFit.cover,

                                  width: MediaQuery.of(context).size.width/2-8,
                                  height: MediaQuery.of(context).size.height/4,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width/2-8,
                                  child: AutoSizeText(
                                    data[2*index]['user']['name'].toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    maxFontSize: 12,

                                    maxLines: 1,
                                    ),

                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Image.network(
                                  data[2*index+1]['urls']['small'],
                                  fit: BoxFit.cover,

                                  width: MediaQuery.of(context).size.width/2-8,
                                  height: MediaQuery.of(context).size.height/4,

                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width/2-8,
                                  child: AutoSizeText(
                                    data[2*index+1]['user']['name'].toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    maxFontSize: 12,

                                    maxLines: 1,
                                    ),

                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                      
                    },
              ),
 
                    ),
                    Align(
                      child: ClipOval(
                        child: Container(
                          width: 30,
                          height: 30,
                          color: Colors.blue,
                          child: Center(
                            child: Text(x.toString(),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      
                      alignment: Alignment.bottomCenter,
                      )
                  ],
                ):Center(child: CircularProgressIndicator(),),
                
                
                loading2==false?Stack(
                  children: [
                    Container(
                      child: new ListView.builder(
                        controller: _scrollController2,

                    itemCount: data2 == null ? 0 : data2.length~/2,

                    itemBuilder: (BuildContext context, int index) {


                      
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    data2[2*index]['urls']['small'],
                                    fit: BoxFit.cover,

                                    width: MediaQuery.of(context).size.width/2-8,
                                    height: MediaQuery.of(context).size.height/4,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width/2-8,
                                    child: AutoSizeText(
                                      data2[2*index]['user']['name'].toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxFontSize: 12,

                                      maxLines: 1,
                                      ),

                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    data2[2*index+1]['urls']['small'],
                                    fit: BoxFit.cover,

                                    width: MediaQuery.of(context).size.width/2-8,
                                    height: MediaQuery.of(context).size.height/4,

                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width/2-8,
                                    child: AutoSizeText(
                                      data2[2*index+1]['user']['name'].toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxFontSize: 12,

                                      maxLines: 1,
                                      ),

                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                      );
                      
                    },
              ),
 
                    ),
                    Align(
                      child: ClipOval(
                        child: Container(
                          width: 30,
                          height: 30,
                          color: Colors.blue,
                          child: Center(
                            child: Text(x2.toString(),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      
                      alignment: Alignment.bottomCenter,
                      )
                  ],
                ):Container(child: CircularProgressIndicator(),),

              ],           )
              ),
      
    );
  }
}
