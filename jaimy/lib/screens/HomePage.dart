import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/widgets.dart';
import 'package:JaiMy/utils/database_helper.dart';






class LikeMusic extends StatefulWidget {
  LikeMusic({Key key}) : super(key: key);

  @override
  LikeMusicState createState() => LikeMusicState();
}

class LikeMusicState extends State<LikeMusic> {
  //final Reward data;

  //LikeMusic({@required this.data});
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  List<Musiclike> music = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datebaseHelper.musiclikes().then((value) =>
        setState(() {  music = value.reversed.toList(); })

    );


  }
  bool isPlaynow = true;
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
    child:SingleChildScrollView(child:Column(
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
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 15,right: 15,top:15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${item.title.length > 20 ? item.title.substring(0,20)+"..." : item.title}",textScaleFactor: 1.2,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                    Text("")
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.artist,textScaleFactor: 1.0,style: TextStyle(color: Colors.white.withOpacity(0.6),)),
                                    Text("${item.description.length > 1 ? item.description.substring(0,2): item.description} นาที",textScaleFactor: 1.0,style: TextStyle(color: Colors.white.withOpacity(0.6),)),
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
}




/*

class LikeTopic extends StatefulWidget {
  LikeTopic({Key key}) : super(key: key);

  @override
  LikeTopicState createState() => LikeTopicState();
}

class LikeTopicState extends State<LikeTopic> {
  //final Reward data;

  //LikeMusic({@required this.data});
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  List<Musiclike> music = [];
  List<Topic> savetopic = [];
  String save = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datebaseHelper.musiclikes().then((value) =>
        setState(() {  music = value; })

    );
    FlutterSession().get("topics").then((val) async{
      print(val);
      //save = val.toString();
      //savetopic = val;
      savetopic = await ( val as List ).map((i) =>
          Topic.fromJson(i)).toList();
      setState(() {});
    });

  }
  @override
  Widget build(BuildContext context) {
    return    Center(
      // padding: const EdgeInsets.all(8.0),
      child: Column(
        children:  savetopic.length > 0 ? savetopic.map((item) =>

            InkWell(
              onTap: (){
                print("okok");
                //PoSound(statusPlay: false,);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayTmusic(todo:item.topicName,topic:item)),
                );
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(left: 15,right: 15,top:15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
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
                      width:80,
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(item.topicPhoto),
                          )
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      width:MediaQuery.of(context).size.width-160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${item.topicName.length > 20 ? item.topicName.substring(0,20)+"..." : item.topicName}",textScaleFactor: 1.4,style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                              Text("")
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width/2.5,
                                child:Text(item.topicDetail,textScaleFactor: 1.2 ,style: TextStyle(color: Colors.white.withOpacity(0.6),),softWrap: true,),),
                              Text("${item.topicCount} ตอน",textScaleFactor: 1.2 ,style: TextStyle(color: Colors.white.withOpacity(0.6),)),
                            ],
                          ),
                        ],
                      ),
                    )

                  ],
                ) ,
              ),
            )

        ).toList().cast<Widget>() : [Center(child: Text("คุณยังไม่ได้บันทึกหัวข้อไว้",textScaleFactor: 1.0,style: TextStyle(color: Colors.white70,height: 2.0),),)],

      ),
    );
  }
}


*/