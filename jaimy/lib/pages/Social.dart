import 'package:JaiMy/models/makha.dart';
import 'package:JaiMy/models/metta.dart';
import 'package:JaiMy/models/online.dart';
import 'package:JaiMy/pages/Profile.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Metta.dart';



List<String> th_Social = [
  "ผู้ใช้ล่าสุด",
  "ห้องรวม",
  "ห้องแผ่เมตตา",
  "ตื่นอยู่",
  "(ผู้นั่งสมาธิมากกว่า 1 ชั่วโมง)",
  "กำลังตื่น",
  "(ผู้นั่งสมาธิมากกว่า 30 นาที)",
  "เพิ่งตื่น",
  "(ผู้นั่งสมาธิน้อยกว่า 30 นาที)"
];


List<String> en_Social = [
  "Recent users",
  "All room",
  "Giving love room",
  "awaken",
  "(People meditate for more than 1 hour.)",
  "awakening",
  "(Person meditated for more than 30 minutes.)",
  "just awaken",
  "(Person meditated for less than 30 minutes.)"
];





class Social extends StatefulWidget{
  Social({Key key, this.analytics, this.observer, this.online, this.tomakha, this.data, this.text_social, this.myuser}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final List<Online> online;
  final List<Makha> tomakha;
  final data;
  final text_social;
  final User myuser;
  @override
  _SocialState createState() => _SocialState(analytics, observer, online, tomakha, data,DateTime.now().timeZoneName == "+07"  ? th_Social : en_Social , myuser);
}


class _SocialState extends State<Social> {
  _SocialState(this.analytics, this.observer, this.online, this.tomakha, this.data, this.text_social, this.myuser);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final List<Online> online;
  final List<Makha> tomakha;
  List<Makha> makha= [];
  final data;
  bool isPlaynow = true;
  List<Metta> mettas= [];
  final text_social;
  final User myuser;
  double position = 0.0;
  double sensitivityFactor = 20.0;
  bool loading = false;


  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "$n";
  }
  void initState() {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
    });
    setState(() {
      makha = tomakha;
    });
    Allmetta().then((value) => setState((){ mettas = value; }));

  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Social',
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


  String twoHour(int n) {
    String minute = twoDigits(n  % 60);
    String hour = twoDigits(n  ~/ 60 % 60);
    if (n < 60) return "$minute นาที";
    return "$hour:$minute ชม.";
  }
  String today = DateFormat.E().format(DateTime.now());



  Future<List<Metta>> Allmetta() async {
    //List<Online> onlines = [];
    final mettas = <Metta>[];
    Dio dio = new Dio();
    var response = await dio.get('https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/getmetta');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // String data = utf8.decode(response.bodyBytes);
      print(response.data);
      for (var i = 0; i < response.data.length; i++) {
        mettas.add(Metta(
          id: response.data[i]['_id'],
          name: response.data[i]['name'],
          profile: response.data[i]['profile'],
          sex: response.data[i]['sex'],
          intDay: num.tryParse(response.data[i]['intDay']),
          intMonth: num.tryParse(response.data[i]['intMonth']),
          day:  response.data[i]['day'],
          month:  response.data[i]['month'],
          time: response.data[i]['time'],
          metta: response.data[i]['metta'] != null ? response.data[i]['metta'] : "...",
        )
        );
      }
      return mettas;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  _onUpdateScroll(ScrollMetrics metrics) {
    if (metrics.pixels - position < sensitivityFactor) {
       print('Axis Scroll Direction : Up');
       Allmakha();
       setState(() {
         loading = true;
         position = metrics.pixels;
       });
    }

    print("Scroll Update${metrics.maxScrollExtent} ----${metrics
        .pixels}   ---- ${metrics.viewportDimension} ---- ${metrics
        .outOfRange}  ----${metrics.extentInside} ------${metrics.axisDirection
        .index}");
  }



Allmakha() async {
    //List<Online> onlines = [];
    final makhas = <Makha>[];
    Dio dio = new Dio();
    var response = await dio.get('https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/getmakha');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // String data = utf8.decode(response.bodyBytes);
      //print(response.data);
      for (var i = 0; i < response.data.length; i++) {
        makhas.add(Makha(
            id: response.data[i]['_id'],
            name: response.data[i]['name'],
            profile: response.data[i]['profile'],
            sex: response.data[i]['sex'],
            intDay: num.tryParse(response.data[i]['intDay']),
            intMonth: num.tryParse(response.data[i]['intMonth']),
            rankMonth: num.tryParse(response.data[i]['rankMonth']),
            rankDay: num.tryParse(response.data[i]['rankDay']),
            day:  response.data[i]['day'],
            month:  response.data[i]['month'],
            time: response.data[i]['time'],
            detail: response.data[i]['detail'] != null ? response.data[i]['detail'] : "...",
            intJai:response.data[i]['intJai'] != null ? num.tryParse(response.data[i]['intJai']):0,
            userId: response.data[i]['userId'],
            tokenId: response.data[i]['tokenId']
        )
        );
      }


      setState(() {
        makha = makhas;
        loading = false;
      });


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }


  @override
  Widget build(BuildContext context) {

  //  List<Online> NoNames = online.where((i) => i.name != "ตั้งชื่อของคุณ" && i.name != "New").toList();
    List<Makha> Level1 = makha.where((i) => i.intDay <= 30 && i.day == today).toList();
    List<Makha> Level2 = makha.where((i) => i.intDay <= 60 && i.intDay > 30 && i.day == today).toList();
    List<Makha> Level3 = makha.where((i) => i.intDay > 60 && i.day == today).toList();


    return Scaffold(
    /*     appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor:const Color(0xff1c2637),
        //title: Text(title),
       leading: new Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.close),
                iconSize:35,
                onPressed: () {
                  try {
                    Navigator.pop(context); //close the popup
                  } catch (e) {}
                },
              );
            }),
        brightness: Brightness.dark,
      ),*/

      backgroundColor: const Color(0xffFFFFFF),
      body: Stack(
        children: <Widget>[


          Positioned(
              top: 0,
              child:  Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    /*   color: HexColor(session['topicBg']),
                image: DecorationImage(
                  image: NetworkImage(session['topicPhoto']),
                  fit: BoxFit.fitWidth,
                  alignment:  Alignment.topCenter,
                )*/
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left:0, top:35, right:0),
                      child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            child: Icon(Icons.arrow_back_ios,color: Colors.black54),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                    ]
                                ),




                                Container(
                                  padding: EdgeInsets.only(left: 20,bottom: 20),
                                  child: Text(
                                    '${text_social[0]}',
                                    textScaleFactor: 1.8,
                                    style: TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),

                                Container(
                                  height: 100.0,
                                  child: new ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:online.map((item) =>
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>  ProfilePage(
                                                    analytics: analytics,
                                                    observer: observer,
                                                    user: User(
                                                      name: item.name,
                                                      profile: item.profile,
                                                      sex: item.sex,
                                                      intMinute: item.intMinute
                                                    ),
                                                  detail: item.detail,
                                                  intJai: item.intJai,
                                                  time: item.time,
                                                  userId: item.userId,
                                                  tokenId: item.tokenId,
                                                  myuser: myuser,
                                                ),
                                              ),
                                            );
                                          },

                                          child: Container(
                                            width: 70,
                                            margin: EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 65.0,
                                                  height: 65.0,
                                                  padding: EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                    color: const Color(0xffffffff),
                                                    border: Border.all(width: 2.0, color: const Color(0xff64dfdf)),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.06),
                                                            spreadRadius: 1,
                                                            blurRadius: 2,
                                                            offset: Offset(0, 1), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: item.profile != "NewProfile"  ? item.profile != "" ? NetworkImage(item.profile) : AssetImage("assets/sex/${item.sex}.png" ): AssetImage("assets/sex/${item.sex}.png")
                                                      ))
                                                  ),
                                                ),
                                                SizedBox(height: 7,),
                                                Text(
                                                  '${(item.name != "ตั้งชื่อของคุณ" && item.name != "New") ? item.name : "ผู้ใช้ใหม่"}',
                                                  textScaleFactor: 1.2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        )

                                    ).toList().cast<Widget>(),
                                  ),),



                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child:Row (
                                        children:[

                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                            margin: EdgeInsets.only(left: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(17.0),
                                              color: const Color(0xff415880),
                                            ),
                                            child: Text(
                                              '${text_social[1]}',
                                              textScaleFactor: 1.6,
                                              style: TextStyle(
                                                color: const Color(0xffffffff),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),



                                         if(DateTime.now().timeZoneName == "+07") mettas.length != 0 ? InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>  MettaPage(mettas: mettas,data: data,),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                              margin: EdgeInsets.only(left: 15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(17.0),
                                                color: const Color(0xff25344E),
                                              ),
                                              child: Text(
                                                '${text_social[2]}',
                                                textScaleFactor: 1.6,
                                                style: TextStyle(
                                                  color: const Color(0xffffffff),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ) : Container(),



                                        ]
                                    )
                                ),





                                Column(
                                  children: [

                                    Container(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height-262,  
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child:   NotificationListener<ScrollNotification>(
                                            onNotification: (scrollNotification) {
                                              if (scrollNotification is ScrollStartNotification) {
                                                //_onStartScroll(scrollNotification.metrics);
                                              } else if (scrollNotification is ScrollUpdateNotification) {
                                                _onUpdateScroll(scrollNotification.metrics);
                                              } else if (scrollNotification is ScrollEndNotification) {
                                                //_onEndScroll(scrollNotification.metrics);
                                              }
                                            },
                                            child:  SingleChildScrollView(

                                            child:Column(
                                              children: [
                                                if(loading) Container(height: 60,width: 60 ,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.black26,),),),
                                                SizedBox(height: 30,),
                                                if(Level3.length != 0) Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  height:(Level3.length < 4 ? 1.0 : ((Level3.length/4))) * 160,
                                                  //color:Colors.white24,
                                                  child:  Column(
                                                    children: [
                                                      SizedBox(height: 0,),
                                                      Text("${text_social[3]}",style: TextStyle(color:Colors.black87),textScaleFactor: 1.8,),
                                                      Text("${text_social[4]}",style: TextStyle(color:Colors.black54),textScaleFactor: 1.2,),
                                                      Wrap(
                                                        spacing: 10,
                                                        children: Level3.map((item) =>

                                                            InkWell(
                                                                onTap: (){
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>  ProfilePage(
                                                                        analytics: analytics,
                                                                        observer: observer,
                                                                        user: User(
                                                                            name: item.name,
                                                                            profile: item.profile,
                                                                            sex: item.sex,
                                                                            intMinute: item.intMonth
                                                                        ),
                                                                        detail: item.detail,
                                                                        intJai: item.intJai,
                                                                        time:num.tryParse(item.time),
                                                                        userId: item.userId,
                                                                        tokenId: item.tokenId,
                                                                        myuser: myuser,
                                                                      ),
                                                                    ),
                                                                  );
                                                                 // showPopupUser(context, showUserMakha(name: item.name,profile: item.profile,sex: item.sex,minute: item.intDay , minuteMonth: item.intMonth, time:num.tryParse(item.time)), 'บันทึกการนั่ง');
                                                                },
                                                                child: Container(
                                                                  width:100,
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          height: 70,
                                                                          width:70,
                                                                          padding: EdgeInsets.all(checkOnTime(num.tryParse(item.time)) ? 5.0 : 0),
                                                                          decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            color: Colors.white,
                                                                            border: Border.all(width: checkOnTime(num.tryParse(item.time)) ? 2.5 : 0, color: const Color(0xff64dfdf)),
                                                                          ),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: item.profile == 'NewProfile'  ? NetworkImage(item.sex) : item.profile != ''  ? NetworkImage(item.profile) : NetworkImage(item.sex)
                                                                                )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text("${item.name.length >= 15? item.name.substring(0,15) + "..." : item.name}",textScaleFactor: 1.2,style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                                                        Text("${twoHour(item.intDay)}",textScaleFactor: 1.0,style:TextStyle(color:Colors.black54,fontWeight: FontWeight.bold))
                                                                      ],
                                                                    )
                                                                )
                                                            )

                                                        ).toList().cast<Widget>(),
                                                      ),
                                                    ],
                                                  ),

                                                ),

                                                if(Level2.length != 0) Container(
                                                  //width: 40,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  height: (Level2.length < 4 ? 1.0 : ((Level2.length/4))) * 180,
                                                  //color:Colors.black38,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 20,),
                                                      Text("${text_social[5]}",style: TextStyle(color:Colors.black87),textScaleFactor: 1.8,),
                                                      Text("${text_social[6]}",style: TextStyle(color:Colors.black54),textScaleFactor: 1.2,),
                                                      Wrap(
                                                        spacing: 10,
                                                        children: Level2.map((item) =>

                                                            InkWell(
                                                                onTap: (){
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>  ProfilePage(
                                                                        analytics: analytics,
                                                                        observer: observer,
                                                                        user: User(
                                                                            name: item.name,
                                                                            profile: item.profile,
                                                                            sex: item.sex,
                                                                            intMinute: item.intMonth,
                                                                        ),
                                                                        detail: item.detail,
                                                                        intJai: item.intJai,
                                                                          time:num.tryParse(item.time),
                                                                        userId: item.userId,
                                                                        tokenId: item.tokenId,
                                                                        myuser: myuser,

                                                                      ),
                                                                    ),
                                                                  );
                                                                 // showPopupUser(context, showUserMakha(name: item.name,profile: item.profile,sex: item.sex,minute: item.intDay , minuteMonth: item.intMonth, time:num.tryParse(item.time)), 'บันทึกการนั่ง');
                                                                },
                                                                child: Container(
                                                                  width: 90,
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          height:65,
                                                                          width: 65,
                                                                          padding: EdgeInsets.all(checkOnTime(num.tryParse(item.time)) ? 5.0 : 0),
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.white,
                                                                              border: Border.all(width: checkOnTime(num.tryParse(item.time)) ? 2.5 : 0, color: const Color(0xff64dfdf)),
                                                                          ),
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                shape: BoxShape.circle,
                                                                                image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: item.profile == 'NewProfile'  ? NetworkImage(item.sex) : item.profile != ''  ? NetworkImage(item.profile) : NetworkImage(item.sex)
                                                                                )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text("${item.name.length >= 15? item.name.substring(0,15) + "..." : item.name}",textScaleFactor: 1.2,style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                                                        Text("${twoHour(item.intDay)}",textScaleFactor: 1.0,style:TextStyle(color:Colors.black54,fontWeight: FontWeight.bold))
                                                                      ],
                                                                    )
                                                                )
                                                            )

                                                        ).toList().cast<Widget>(),
                                                      ),
                                                    ],
                                                  )
                                                  ,

                                                ),
                                                Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    height:
                                                    (Level1.length < 5 ? 1.0 : ((Level1.length/5))) * 160,
                                                    //color:Colors.black38,
                                                    //child: Text("${Level1[0].intDay}"
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 20,),
                                                        Text("${text_social[7]}",style: TextStyle(color:Colors.black87),textScaleFactor: 1.8,),
                                                        Text("${text_social[8]}",style: TextStyle(color:Colors.black54),textScaleFactor: 1.2,),
                                                        Wrap(
                                                            spacing: 10,
                                                          children: Level1.map((item) =>

                                                              InkWell(
                                                                  onTap: (){
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>  ProfilePage(
                                                                          analytics: analytics,
                                                                          observer: observer,
                                                                          user: User(
                                                                              name: item.name,
                                                                              profile: item.profile,
                                                                              sex: item.sex,
                                                                              intMinute: item.intMonth
                                                                          ),
                                                                          detail: item.detail,
                                                                          intJai: item.intJai,
                                                                            time:num.tryParse(item.time),
                                                                          userId: item.userId,
                                                                          tokenId: item.tokenId,
                                                                          myuser: myuser,
                                                                        ),
                                                                      ),
                                                                    );
                                                                    //showPopupUser(context, showUserMakha(name: item.name,profile: item.profile,sex: item.sex,minute: item.intDay , minuteMonth: item.intMonth, time:num.tryParse(item.time)), 'บันทึกการนั่ง');
                                                                  },
                                                                  child: Container(
                                                                      width: 80,
                                                                      padding: EdgeInsets.all(10),
                                                                      child: Column(
                                                                        children: [
                                                                          Container(
                                                                            width: 55.0,
                                                                            height: 55.0,
                                                                            padding: EdgeInsets.all(checkOnTime(num.tryParse(item.time)) ? 3.0 : 0),
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                color: Colors.white,
                                                                                border: Border.all(width: checkOnTime(num.tryParse(item.time)) ? 2.0 : 0, color: const Color(0xff64dfdf)),
                                                                            ),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                  shape: BoxShape.circle,
                                                                                  image: DecorationImage(
                                                                                      fit: BoxFit.cover,
                                                                                      image: item.profile == 'NewProfile'  ? NetworkImage(item.sex) : item.profile != ''  ? NetworkImage(item.profile) : NetworkImage(item.sex)
                                                                                  )
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text("${item.name.length >= 15? item.name.substring(0,15) + "..." : item.name}",textScaleFactor: 1.2,style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                                                                          Text("${twoHour(item.intDay)}",textScaleFactor: 1.0,style:TextStyle(color:Colors.black54,fontWeight: FontWeight.bold))
                                                                        ],
                                                                      )
                                                                  )
                                                              )

                                                          ).toList().cast<Widget>(),
                                                        ),
                                                      ],
                                                    )

                                                )
                                              ],
                                            )
                                        )))
                                  ],
                                )















                              ]
                          )
                      )
                  )
          ),



          saveSitting(statusPlay: true),


          PositionPlaying(
            isPlayNow: isPlaynow,
            isOpen: (isPlaynow){
              setState(() {
                this.isPlaynow = false;
              });
            },
          ),



/*
          Transform.translate(
            offset: Offset(158.0, 270.0),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                border: Border.all(width: 3.0, color: const Color(0xffa5c3f7)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(169.0, 336.0),
            child: Text(
              'Kaeka',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(168.0, 225.0),
            child: Text(
              'ตื่นอยู่',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 362.0),
            child: Container(
              width: 375.0,
              height: 304.0,
              decoration: BoxDecoration(
                color: const Color(0x1a000000),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(113.0, 249.0),
            child: Text(
              '(ผู้นั่งสมาธิมากกว่า 1 ชั่วโมง)',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(160.0, 371.0),
            child: Text(
              'กำลังตื่น',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(114.0, 395.0),
            child: Text(
              '(ผู้นั่งสมาธิมากกว่า 30 นาที)',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(160.0, 426.0),
            child: Container(
              width: 55.0,
              height: 55.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                border: Border.all(width: 3.0, color: const Color(0xffa5c3f7)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(169.0, 487.0),
            child: Text(
              'Kaeka',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(165.0, 534.0),
            child: Text(
              'เพิ่งตื่น',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(113.0, 558.0),
            child: Text(
              '(ผู้นั่งสมาธิน้อยกว่า 30 นาที)',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(165.0, 589.0),
            child: Container(
              width: 45.0,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                border: Border.all(width: 3.0, color: const Color(0xffa5c3f7)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(172.0, 640.0),
            child: Text(
              'Kaeka',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),


 */
        ],
      ),
    );
  }


  bool checkOnTime(int time){
    DateTime justNow = DateTime.now().subtract(Duration(minutes: 60));
    DateTime localDateTime = DateTime.fromMillisecondsSinceEpoch(time);
    if (!localDateTime.difference(justNow).isNegative) {
      return true;
    } else {
      return false;
    }
  }


}





