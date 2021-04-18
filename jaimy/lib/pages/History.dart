import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget{
  HistoryPage({Key key, this.analytics, this.observer }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _HistoryState createState() => _HistoryState(analytics, observer);
}


class _HistoryState extends State<HistoryPage> {
  _HistoryState(this.analytics, this.observer );

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
    });
    DatabaseApr.historySounds().then((value) =>
        setState(() {  music = value.reversed.toList(); })
    );

  }
  List<hisSound> music = [];
  static DataApr DatabaseApr = DataApr();


  bool isPlaynow = true;

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_History_Sounds',
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
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: const Color(0xFF134b53),
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
        backgroundColor: const Color(0xFF134b53),
        body:  Stack(
            children: <Widget>[

              Positioned(
                  top: 0,
                  child:  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child:SingleChildScrollView(
                      child:Column(
                      children:  music.length > 0 ? music.map((item) =>
                          InkWell(
                            onTap: (){
                              print("okok");
                              /* //PoSound(statusPlay: false,);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Sounding(audio:
                          Audio.network( item.url , metas: Metas(
                            id: item.id,
                            title: item.title,
                            artist:item.artist,
                            album:  item.description,
                            // image: MetasImage.network("https://www.google.com")
                            image: MetasImage.network(
                                item.artwork),
                          )
                          ),typePlay:"dhammas"),
                        ),
                      );*/
                              _assetsAudioPlayer.open(
                                Audio.network( item.url , metas: Metas(
                                  id: item.id,
                                  title: item.title,
                                  artist:item.artist,
                                  album:  item.description,
                                  // image: MetasImage.network("https://www.google.com")
                                  image: MetasImage.network(
                                      item.artwork),
                                )
                                ),
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
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(left: 10,right: 10,top:15),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0,21),
                                        blurRadius: 53,
                                        color: Colors.black.withOpacity(0.05)
                                    )
                                  ]
                              ),

                              child:Row(

                                children: [
                                  Container(
                                    width:60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(item.artwork),
                                        )
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                    width:MediaQuery.of(context).size.width-130,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [



                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${item.title.length > 20 ? item.title.substring(0,20)+"..." : item.title}",textScaleFactor: 1.8,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                            Text(" - ฟังเมื่อ ${timeTodate(item.time)}",textScaleFactor: 1.4,style: TextStyle(color: Colors.white54))
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item.artist,textScaleFactor: 1.4,style: TextStyle(color: Colors.white.withOpacity(0.6),)),
                                            Text("${item.description.length > 1 ? item.description.substring(0,2): item.description} นาที",textScaleFactor: 1.2,style: TextStyle(color: Colors.white.withOpacity(0.6),)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )

                                ],
                              ) ,
                            ),
                          )


                      ).toList().cast<Widget>() : [Center(child: Text("คุณยังไม่ได้บันทึกรายการที่ชอบ",textScaleFactor: 1.0,style: TextStyle(color: Colors.white70,height: 2.0),),)],

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

            ]));
  }



  String timeTodate(int time){
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(Duration(minutes: 1));
    DateTime localDateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String roughTimeString = DateFormat('jm').format(localDateTime);

    if (!localDateTime.difference(justNow).isNegative) {
      return 'เพิ่งเมื่อกี้';
    }
    if (localDateTime.day == now.day && localDateTime.month == now.month && localDateTime.year == now.year) {
      return roughTimeString;
    }
    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day && localDateTime.month == yesterday.month && localDateTime.year == yesterday.year) {
      return 'เมื่อวาน,' + roughTimeString;
    }
    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);
      return '$weekday, $roughTimeString';
    }
    return '${DateFormat('yMd').format(localDateTime)}, $roughTimeString';

  }
}

