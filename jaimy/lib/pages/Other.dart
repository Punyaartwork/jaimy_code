import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/DownScreen.dart';
import 'package:JaiMy/screens/HomePage.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'History.dart';

class Other extends StatefulWidget{
  Other({Key key, this.analytics, this.observer, this.text_profile }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final text_profile;
  @override
  _OtherState createState() => _OtherState(analytics, observer, text_profile);
}


class _OtherState extends State<Other> {
  _OtherState(this.analytics, this.observer, this.text_profile );

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final text_profile;

  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
    });

  }

  bool isPlaynow = true;

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Other',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    print('@@@@@@@@@@@@logEvent succeeded@@@@@@@@@@@@@@@@@@@@@');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color(0xff1c2637),
        bottomOpacity: 0.0,
        elevation: 0.0,
        //title: Text(title),
        /*leading: new Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.close),
            iconSize:35,
            onPressed: () {
              try {
                Navigator.pop(context); //close the popup
              } catch (e) {}
            },
          );
        }),*/
        brightness: Brightness.dark,
      ),
      backgroundColor: const Color(0xffeeeeee),
      body: Stack(
    children: <Widget>[

    Positioned(
    top: 0,
    child:  Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child:SingleChildScrollView(
        child:Column(
        children: <Widget>[
          SizedBox(height: 40,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikeMusic(),
                ),
              );
            },
            child:Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width:80,
                  alignment: Alignment.center,
                  child: Icon(Icons.favorite,size: 30,color: Color(0xcc1c2637),),
                )
                ,
                Container(
                  width: MediaQuery.of(context).size.width-80,
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 0.5, color:  Colors.black12),
                      bottom: BorderSide(width: 0.5, color:  Colors.black12),
                    ),
                   ) ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${text_profile[10]}",textScaleFactor: 2.2,),
                      Icon(Icons.arrow_forward_ios,size: 20,color: Colors.black12,),
                    ],
                  ),
                )
              ],
            ),
          )),

          InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownScreen(),
                  ),
                );
              },
              child:Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width:80,
                      alignment: Alignment.center,
                      child: Icon(Icons.save,size: 30,color: Color(0xcc1c2637),),
                    )
                    ,
                    Container(
                      width: MediaQuery.of(context).size.width-80,
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color:  Colors.black12),
                          bottom: BorderSide(width: 0.5, color:  Colors.black12),
                        ),
                      ) ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${text_profile[11]}",textScaleFactor: 2.2,),
                          Icon(Icons.arrow_forward_ios,size: 20,color: Colors.black12,),
                        ],
                      ),
                    )
                  ],
                ),
              )),


          InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(),
                  ),
                );
              },
              child:Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      width:80,
                      alignment: Alignment.center,
                      child: Icon(Icons.history,size: 30,color: Color(0xcc1c2637),),
                    )
                    ,
                    Container(
                      width: MediaQuery.of(context).size.width-80,
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5, color:  Colors.black12),
                          bottom: BorderSide(width: 0.5, color:  Colors.black12),
                        ),
                      ) ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${text_profile[12]}",textScaleFactor: 2.2,),
                          Icon(Icons.arrow_forward_ios,size: 20,color: Colors.black12,),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    ))),





      saveSitting(statusPlay: true),



      PositionPlaying(
        isPlayNow: isPlaynow,
        isOpen: (isPlaynow){
          setState(() {
            this.isPlaynow = false;
          });
        },
      )




    ]
      ));
  }
}
