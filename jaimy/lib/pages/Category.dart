import 'dart:convert';

import 'package:JaiMy/models/sessionHistory.dart';
import 'package:JaiMy/models/sessionMakha.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';

class Category extends StatefulWidget{
  Category({Key key, this.analytics, this.observer, this.data}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final data;
  @override
  _CategoryState createState() => _CategoryState(analytics, observer, data);
}


class _CategoryState extends State<Category> {
  _CategoryState(this.analytics, this.observer, this.data);
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final data;
  bool isPlaynow = false;
  dynamic category;
  String userId = "";
  int intDay = 0;
  String savedDay = "";
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  static DataApr DatabaseApr = DataApr();



  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
      _startMakha(context);
    });
    //print(data['categoryTheme']);
    setState(() {
      categoryTheme = data['categoryTheme'];
      categoryNews = data['categoryNews'];
      showTopic = data['showTopic'];
      showSession = data['showSession'];
    });
  }

  Map categoryTheme = {
    "background":"#70BBAA",
    "frontground":"#65A899",
    "tilte":"#6D9F9A",
    "button":"#5C8B86"
  };
  Map categoryNews = {
    "image":"https://images.pexels.com/photos/5841842/pexels-photo-5841842.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "title":"พื้นฐานการหยุดใจ",
    "detail":"  พื้นฐานการหยุดใจ ~ หยุดแรก นี่จะยากสักนิด ก็ไม่ใช่ยากมาก..",
    "audio":{
      "id": 135,
      "url": "https://di4y0jq908exx.cloudfront.net/soundnew/T4ID135.mp3",
      "title": "นำใจมาที่ฐานที่ 7",
      "artist": "ง่ายแต่ลึก",
      "artwork": "https://sv1.picz.in.th/images/2020/06/04/qlSlZb.png",
      "description":"1"
    }
  };
  Map showTopic={"id":0};
  var showSession=[];
  var categorys=[];




  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Category',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    print('@@@@@@@@@@@@Category succeeded@@@@@@@@@@@@@@@@@@@@@');
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
        'url': item['url'],
        'title': item['title'],
        'artist': item['artist'],
        "artwork":item['artwork'],
        'description': item['description'],
        'time': new DateTime.now().millisecondsSinceEpoch,
        'day': DateFormat.E().format(DateTime.now()),
        'intDay': savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(item['description'])+intDay : item['description'],
        'topicId': topicId,
        'topicName': topicName,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    print(responsenew.toString());

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(categoryTheme['background']),
      body:Stack(
    children: <Widget>[


    Positioned(
    child: SingleChildScrollView(
        child:Column(
        children: <Widget>[
          Container(
            width:MediaQuery.of(context).size.width,
            height: 250.0,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              image: DecorationImage(
                image: NetworkImage(categoryNews['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    SizedBox(width: 15,),
                    InkWell(
                      onTap:(){
                        Navigator.pop(context); //close the popup
                      },
                      child: Icon(Icons.arrow_back,color: Colors.white,size: 40,),
                    ),
                    Spacer()
                  ],
                ),
                Spacer(),Spacer(),Spacer(),Spacer(),
                InkWell(
                  onTap: (){
                    SessionHistory save = SessionHistory(
                        id:categoryNews['audio']['id'].toString(),
                        url: categoryNews['audio']['url'],
                        title:categoryNews['audio']['title'],
                        artist:categoryNews['audio']['artist'],
                        artwork:categoryNews['audio']['artwork'],
                        description:categoryNews['audio']['description'],
                        time: new DateTime.now().millisecondsSinceEpoch,
                        day: DateFormat.E().format(DateTime.now()),
                        intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(categoryNews['audio']['description'])+intDay : num.tryParse(categoryNews['audio']['description']),
                        topicId: 0,
                        topicName: ""
                    );
                    FlutterSession().set('history', save);
                    makePostHistory(categoryNews['audio'],categoryNews['audio']['id'],showTopic['topicName']);
                    _assetsAudioPlayer.open(
                      toAudio(categoryNews['audio']),
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
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: HexColor(categoryTheme['button']),
                    ),
                    child: Text(
                      'ฟังนำนั่งนี้',
                      textScaleFactor: 1.8,
                      style: TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),

          showTopic['id'] != 0 ? Container(
            width:MediaQuery.of(context).size.width ,
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color:  HexColor(categoryTheme['frontground']),
            ),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text(
                  showTopic['topicName'],
                  textScaleFactor: 2.5,
                  style: TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2,),
                Text(
                  showTopic['topicDetail'],
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    color: const Color(0xccffffff),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                // SizedBox(width: MediaQuery.of(context).size.width,),
                Column(
                  children: [
                    for (int i = 0; i < showTopic['topics'].length; i++)
                      InkWell(
                        onTap: (){
                          SessionHistory save = SessionHistory(
                              id:showTopic['topics'][i]['id'].toString(),
                              url: showTopic['topics'][i]['url'],
                              title:showTopic['topics'][i]['title'],
                              artist:showTopic['topics'][i]['artist'],
                              artwork:showTopic['topics'][i]['artwork'],
                              description:showTopic['topics'][i]['description'],
                              time: new DateTime.now().millisecondsSinceEpoch,
                              day: DateFormat.E().format(DateTime.now()),
                              intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(showTopic['topics'][i]['description'])+intDay : num.tryParse(showTopic['topics'][i]['description']),
                              topicId: 0,
                              topicName: ""
                          );
                          FlutterSession().set('history', save);
                          makePostHistory(showTopic['topics'][i],showTopic['topics'][i]['id'],showTopic['topicName']);
                          _assetsAudioPlayer.open(
                            toAudio(showTopic['topics'][i]),
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
                                   showTopic['topics'][i]['id'].toString(),
                                   showTopic['topics'][i]['url'],
                                   showTopic['topics'][i]['title'],
                                   showTopic['topics'][i]['artist'],
                                   showTopic['topics'][i]['artwork'],
                                   showTopic['topics'][i]['description'],
                                  new DateTime.now().millisecondsSinceEpoch,
                                  showTopic['topicName']
                              )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.0),
                                  color: const Color(0xffffffff),
                                  image: DecorationImage(
                                      image: NetworkImage(showTopic['topics'][i]['artwork']),
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
                                    "${showTopic['topics'][i]['title']}",
                                    textScaleFactor: 1.6,
                                    style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    softWrap: true,
                                    //overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  )),
                                  Text(
                                    '${showTopic['topics'][i]['artist']} - ${showTopic['topics'][i]['description']} min',
                                    textScaleFactor: 1.4,
                                    style: TextStyle(
                                      color: const Color(0xccffffff),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 30,)
              ],
            ),
          ) : Container(),


          SizedBox(height: 30,),


          showSession.length != 0 ?
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: showSession.map((item) =>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '~ ${item['sessionDetail']}',
                      textScaleFactor: 1.8,
                      style: TextStyle(
                        color: const Color(0xccffffff),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    for (int i = 0; i < item['sessionAudios'].length; i++)
                      InkWell(
                        onTap: (){
                          SessionHistory save = SessionHistory(
                              id:item['sessionAudios'][i]['id'].toString(),
                              url: item['sessionAudios'][i]['url'],
                              title:item['sessionAudios'][i]['title'],
                              artist:item['sessionAudios'][i]['artist'],
                              artwork:item['sessionAudios'][i]['artwork'],
                              description:item['sessionAudios'][i]['description'],
                              time: new DateTime.now().millisecondsSinceEpoch,
                              day: DateFormat.E().format(DateTime.now()),
                              intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(item['sessionAudios'][i]['description'])+intDay : num.tryParse(item['sessionAudios'][i]['description']),
                              topicId: 0,
                              topicName: showTopic['topicName']
                          );
                          FlutterSession().set('history', save);
                          makePostHistory(item['sessionAudios'][i],item['sessionAudios'][i]['id'],showTopic['topicName']);
                          _assetsAudioPlayer.open(
                            toAudio(item['sessionAudios'][i]),
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
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(19.0),
                                  color: const Color(0xffffffff),
                                  image: DecorationImage(
                                    image: NetworkImage(item['sessionAudios'][i]['artwork']),
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
                                        "${item['sessionAudios'][i]['title']}",
                                        textScaleFactor: 1.6,
                                        style: TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: true,
                                        //overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      )),
                                  Text(
                                    '${item['sessionAudios'][i]['artist']} - ${item['sessionAudios'][i]['description']} min',
                                    textScaleFactor: 1.4,
                                    style: TextStyle(
                                      color: const Color(0xccffffff),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 40,),

                  ],
                ),

            ).toList().cast<Widget>(),
          )) : Container()
        ],
      ),
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
      )







    ])
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