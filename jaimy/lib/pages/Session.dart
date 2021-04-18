import 'dart:async';

import 'package:JaiMy/models/sessionHistory.dart';
import 'package:JaiMy/models/sessionMakha.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
class Session extends StatefulWidget{
  Session({Key key, this.analytics, this.observer, this.data}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final data;
  @override
  _SessionState createState() => _SessionState(analytics, observer, data);
}


class _SessionState extends State<Session> {
  _SessionState(this.analytics, this.observer, this.data);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final data;
  String userId = "";
  int intDay = 0;
  String savedDay = "";
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  bool isPlaynow = false;
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  static DataApr DatabaseApr = DataApr();
  bool _visible = true;
  bool autoPlay = true;
  Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            setState(() {
              _visible = false;
            });
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void initState()  {
    super.initState();
    startTimer();
    Future(() {
      _sendAnalyticsEvent();
      _startMakha(context);
    });
    AudiosVal(data['audios']).then((value) => setState((){audioss = value;}) );
    print(data.toString());
    setState(() {
      audios = data['audios'];
      session = data;
    });
  }


  Map session =  {
  "id":9,
  "categoryId":4,
  "lessonId":5,
  "topicName": "ปล่อยใจจากงาน",
  "topicDetail": "ปล่อยวางใจให้พ้นจากความเครียดกังวลงานต่างๆ",
  "topicPhoto": "https://i.ibb.co/Jsz6m98/09.png",
  "topicTime": 1616745238,
  "topicCount": 7,
  "topicView": 0,
  "topicColor": "#FFFFFF",
  "topicBg": "#459280",
  };
  var audios =[];
  List<Audio> audioss = [];

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Session',
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

  Future<void> _startMakha(context) async {

    await FlutterSession().get("makha").then((val) async {

      print("start2");
      dynamic user = await datebaseHelper.getUser(1);
      if(val == 0 || val == null){

        //showPopupIntro(context, loginPage(), 'แนะนำการใช้');
        //print("start3");
        print(user.name);
        SessionMakha myData = SessionMakha(
          id:new DateTime.now().millisecondsSinceEpoch.toString(),
          name: user.name,
          profile: user.profile,
          sex:user.sex == "man" ? "https://i.ibb.co/SX5HyLH/man.png" : "https://i.ibb.co/K0QsLdB/woman.png" ,
          rankMonth: 0,
          rankDay: 0,
          intMonth: 0,
          intDay: 0,
          day: "",
          month: "",
        );
        await FlutterSession().set('makha', myData);
        setState(() {
          userId = myData.id;
          intDay = 0;
        });
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        dynamic data =  val;
        print(data['id']);
        print(data['name']);
        print(data['profile']);
        setState(() {
          userId = data['id'];
          intDay = data['intDay'];
          savedDay = data['day'];
        });
      }

    }) .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });
  }



  Future<List<Audio>> AudiosVal(data) async {
    final Audios = <Audio>[];
    for (var i = 0; i < data.length; i++) {
      Audios.add(
          Audio.network(
            data[i]['url'],
            metas: Metas(
              id: data[i]['id'].toString(),
              title: data[i]['title'],
              artist: data[i]['artist'],
              album:  data[i]['description'],
              // image: MetasImage.network("https://www.google.com")
              image: MetasImage.network(
                  data[i]['artwork']),
            ),
          )
      );
    }
    return Audios;
  }

  Audio toAudio(data){
    return  Audio.network(
      data['url'],
      metas: Metas(
        id: data['id'].toString(),
        title: data['title'],
        artist: data['artist'],
        album:  data['description'],
        // image: MetasImage.network("https://www.google.com")
        image: MetasImage.network(
            data['artwork']),
      ),
    );
  }

  makePostHistory(item,topicId,topicName) async {
    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/historys';

    var responsenew = await Dio().post(uri,
      data: {
        //  '_id': '5f7c88bb6191610555985122',
        'userId': '5f7c88bb619${userId}',
        //'_id': widget.sessionData.id,
        'url': item.path,
        'title': item.metas.title,
        'artist': item.metas.artist,
        "artwork":item.metas.image.path,
        'description': item.metas.album,
        'time': new DateTime.now().millisecondsSinceEpoch,
        'day': DateFormat.E().format(DateTime.now()),
        'intDay': savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(item.metas.album)+intDay : item.metas.album,
        'topicId': topicId,
        'topicName': topicName,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    print(responsenew.toString());

  }




  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(session['topicBg']),
      body: Stack(
        children: <Widget>[





          Positioned(
            top: 0,
            child:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: HexColor(session['topicBg']),
                  image: DecorationImage(
                    image: NetworkImage(session['topicPhoto']),
                    fit: BoxFit.fitWidth,
                    alignment:  Alignment.topCenter,
                  )
              ),
              child: Padding(
                  padding: EdgeInsets.only(left:0, top:35, right:0),
                  child: SingleChildScrollView(
                    //crossAxisAlignment:CrossAxisAlignment.start,
                      child:Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Icon(Icons.arrow_back_ios,color: HexColor(session['topicColor']),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Spacer()
                                  ],
                                ),


                                SizedBox(height: MediaQuery.of(context).size.width/10,),
                                Container(
                                  width:  MediaQuery.of(context).size.width,
                                  //height: MediaQuery.of(context).size.width/3.5,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [ HexColor(session['topicBg']).withOpacity(0.0), HexColor(session['topicBg'])])),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start ,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: MediaQuery.of(context).size.width/15),
                                          child: Column(
                                           // crossAxisAlignment: CrossAxisAlignment.start ,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: MediaQuery.of(context).size.width/10,width: MediaQuery.of(context).size.width,),
                                              Text(session['topicName'],style: TextStyle(fontWeight: FontWeight.bold,color:HexColor(session['topicColor'])),textScaleFactor: 2.0,),
                                              Text(session['topicDetail'],style: TextStyle( color:HexColor(session['topicColor']).withOpacity(0.8)),textScaleFactor: 1.6,),
                                              SizedBox(height: 5,),
                                              Text("",style: TextStyle(color:Colors.white.withOpacity(0.8)),textScaleFactor: 1.0,),
                                            ],
                                          ),
                                        ),
                                      ]
                                  ),
                                ),

                                Container(
                                  //height: 25,
                                  color: HexColor(session['topicBg'])
                                  ,child: Column(
                                        //alignment: WrapAlignment.center,
                                        children:   [
                                          for (int i = 0; i < audioss.length; i++)
                                              InkWell(
                                                onTap: (){
                                                  SessionHistory save = SessionHistory(
                                                      id:audioss[i].metas.id,
                                                      url: audioss[i].path,
                                                      title:audioss[i].metas.title,
                                                      artist:audioss[i].metas.artist,
                                                      artwork:audioss[i].metas.image.path,
                                                      description: audioss[i].metas.album,
                                                      time: new DateTime.now().millisecondsSinceEpoch,
                                                      day: DateFormat.E().format(DateTime.now()),
                                                      intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(audioss[i].metas.album)+intDay : num.tryParse(audioss[i].metas.album),
                                                      topicId: 0,
                                                      topicName: session['topicName']
                                                  );
                                                  FlutterSession().set('history', save);
                                                  makePostHistory(audioss[i],audioss[i].metas.id,session['topicName']);
                                                  _assetsAudioPlayer.open(
                                                    autoPlay ? Playlist(audios: audioss.sublist(audioss.indexOf(audioss[i]))) : audioss[i],
                                                    autoStart: true,
                                                    showNotification: true,
                                                    playInBackground: PlayInBackground.enabled,
                                                    //    phoneCallStrategy: PhoneCallStrategy.none,
                                                    headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                                                    notificationSettings: NotificationSettings(
                                                      seekBarEnabled: true,
                                                      stopEnabled: true,
                                                      customStopAction: (player){
                                                        player.stop();
                                                      },
                                                      prevEnabled: false,
                                                      customNextAction: (player) {
                                                        player.next();
                                                      },
                                                      customPrevAction: (player){
                                                        player.previous();
                                                      },
                                                      customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
                                                      customPauseIcon: AndroidResDrawable(name:"ic_pause_custom"),
                                                      customPlayIcon: AndroidResDrawable(name:"ic_play_custom"),
                                                    ),
                                                  );
                                                  //playing = item;
                                                  isPlaynow = true;
                                                  //audios = snapshot.data;
                                                  setState(() { });


                                                  DatabaseApr.saveMusic(
                                                      hisSound(
                                                          audioss[i].metas.id,
                                                          audioss[i].path,
                                                          audioss[i].metas.title,
                                                          audioss[i].metas.artist,
                                                          audioss[i].metas.image.path,
                                                          audioss[i].metas.album,
                                                          new DateTime.now().millisecondsSinceEpoch,
                                                          session['topicName']
                                                      )
                                                  );
                                                },
                                                child: Container(

                                                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 46.0,
                                                        height: 46.0,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(19.0),
                                                          color: const Color(0xffffffff),
                                                          image: DecorationImage(
                                                            image: NetworkImage(audioss[i].metas.image.path),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),

                                                      ),
                                                      SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              width:MediaQuery.of(context).size.width-140,
                                                              child:Text(
                                                                "${audioss[i].metas.title}",
                                                                textScaleFactor: 1.6,
                                                                style: TextStyle(
                                                                  color: HexColor(session['topicColor']),
                                                                  fontWeight: FontWeight.w700,
                                                                ),
                                                                softWrap: true,
                                                                //overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                              )),
                                                          Text(
                                                            '${audioss[i].metas.artist} - ${audioss[i].metas.album} min',
                                                            textScaleFactor: 1.4,
                                                            style: TextStyle(
                                                              color: HexColor(session['topicColor']).withOpacity(0.8),
                                                            ),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ],
                                      )

                                ),

                              ],
                            ),
                            SizedBox(height: 100,)
                          ]
                      )
                  )
              ),
            ),
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



          Positioned(
              top: 70,
              left: ((MediaQuery.of(context).size.width-200)/2),
              child:InkWell(
                  onTap: (){
                    setState(() {
                      autoPlay = !autoPlay;
                    });
                  },
                  child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Container(
                        width:200,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child:Column(
                            children:[
                              Text("การเล่นอัตโนมัติ${autoPlay ? "เปิดอยู่" : "ปิดอยู่"}",textScaleFactor: 1.8,),
                              Text("“คลิกที่นี่เพื่อ${autoPlay ?"ปิด":"เปิด"}”",textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold),)
                            ]
                        ),
                      )
                  )
              )
          )

        ],
      ),
    );
  }
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}