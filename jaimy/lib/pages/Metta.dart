import 'package:JaiMy/models/metta.dart';
import 'package:JaiMy/models/sessionHistory.dart';
import 'package:JaiMy/models/sessionMetta.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/WatJai.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';

class MettaPage extends StatefulWidget{
  MettaPage({Key key, this.mettas, this.data}) : super(key: key);
  final List<Metta> mettas;
  final data;

  @override
  MettaState createState() => MettaState(mettas, data);
}

class MettaState extends State<MettaPage> {
  MettaState(this.mettas, this.data);
  final List<Metta> mettas;
  final data;
  String userId = "";
  int intDay = 0;
  String savedDay = "";
  bool isPlaynow = true;
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  static DataApr DatabaseApr = DataApr();


  showAlertDialog(BuildContext context,String text) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("วันนี้คุณวัด${text}ไปแล้ว"),
      content: Text("สามารถวัดอีกในวันถัดไปนะค่ะ.."),
      //title: Text("เหรียญไม่เพียงพอ"),
      //content: Text("คุณไม่สามารถตักบาตรมากกว่านี้ได้ กรุณาไปที่หน้าถุงเงินหลังรับพรเสร็จ เพื่อเพิ่มเหรียญ"),
      actions: [
        //okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  SessionMetta sessionMetta;
  List<Audio> audios=[];




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

  @override
  void initState() {
    super.initState();
    Future(() {
      _startMetta(context);
    });
    AudiosVal(data).then((value) => setState(() {
      audios = value;
    }));
  }



  Future<void> _startMetta(context) async {
    await FlutterSession().get("metta").then((val) async {

      print("start2");
      dynamic user = await datebaseHelper.getUser(1);
      if(val == 0 || val == null){

        //showPopupIntro(context, loginPage(), 'แนะนำการใช้');
        //print("start3");
        print(user.name);
        SessionMetta myData = SessionMetta(
          id:new DateTime.now().millisecondsSinceEpoch.toString(),
          name: user.name,
          profile: user.profile,
          sex:user.sex == "man" ? "https://i.ibb.co/SX5HyLH/man.png" : "https://i.ibb.co/K0QsLdB/woman.png" ,
          intMonth: 0,
          intDay: 0,
          day: "",
          month: "",
          metta: "เข้ามาแผ่เมตตา"
        );
        await FlutterSession().set('metta', myData);
        setState(() {
          sessionMetta = myData;
        });
        toMetta(myData);
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        dynamic data =  val;
        print(data['id']);
        print(data['name']);
        print(data['profile']);
        setState(() {
          setState(() {
            userId = data['id'];
            intDay = data['intDay'];
            savedDay = data['day'];
          });
          sessionMetta = SessionMetta(
              id: data['id'],
              name:user.name,
              profile: user.profile,
              sex: data['sex'],
              intDay:DateFormat.E().format(DateTime.now()) != data['day'] ? 0 : data['intDay'],
              intMonth:DateFormat.MMM().format(DateTime.now()) != data['month'] ? 0 : data['intMonth'],
              day:data['day'],
              month:data['month'],
            metta:data['metta'],

          );
          setState(() {});
          toMetta(sessionMetta);
        });

      }

    }) .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });
  }

  List<Awake> awakes;
  int intKnow=2;
  int intRelex=5;
  User user = User(
    id: 1,
    name: '',
    profile: '',
    sex: 'man',
    age: 10,
    intExp: 0,
    intMinute:0,
    intListen: 0,
    intKnow: 0,
    intRelex: 0,
    intWave: 0,
    intMeditate: 0,
    intLesson: 0,
    intEmotion: 0,
  );
  String dataShow = '92';
  static DatabaseHelper datebaseHelper = DatabaseHelper();

  makePostRequest(title) async {

    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/mettas';

    var responsenew = await Dio().post(uri,
      data:  {
        //  '_id': '5f7c88bb6191610555985122',
        '_id': '5f7c88bb619${sessionMetta.id}',
        //'_id': widget.sessionData.id,
        'name': sessionMetta.name,
        'profile': sessionMetta.profile,
        'sex':sessionMetta.sex,
        'intDay':sessionMetta.intDay+1,
        'intMonth':sessionMetta.intMonth+1,
        'day':DateFormat.E().format(DateTime.now()),
        'month':DateFormat.MMM().format(DateTime.now()),
        'time':  new DateTime.now().millisecondsSinceEpoch,
        'metta':"กำลังแผ่เมตตาด้วยฟัง${title}อยู่"
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    print(responsenew.toString());
    await FlutterSession().set('metta',
        SessionMetta(
          id:sessionMetta.id,
          name: sessionMetta.name,
          profile:sessionMetta.profile,
          sex:sessionMetta.sex,
          intDay:sessionMetta.intDay+1,
          intMonth:sessionMetta.intMonth+1,
          day:DateFormat.E().format(DateTime.now()),
          month:DateFormat.MMM().format(DateTime.now()),
          metta: "แผ่เมตตาด้วยฟัง${title}"
        )
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


  toMetta(SessionMetta data) async{

    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/mettas';

    var responsenew = await Dio().post(uri,
      data:  {
        //  '_id': '5f7c88bb6191610555985122',
        '_id': '5f7c88bb619${data.id}',
        //'_id': widget.sessionData.id,
        'name': data.name,
        'profile': data.profile,
        'sex':data.sex,
        'intDay':data.intDay+1,
        'intMonth':data.intMonth+1,
        'day':DateFormat.E().format(DateTime.now()),
        'month':DateFormat.MMM().format(DateTime.now()),
        'time':  new DateTime.now().millisecondsSinceEpoch,
        'metta':"เข้ามาแผ่เมตตา"
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    print(responsenew.toString());
  }


  toMettaClick(SessionMetta data,String sound) async{
    print("Start");
    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/mettas';

    var responsenew = await Dio().post(uri,
      data:  {
        //  '_id': '5f7c88bb6191610555985122',
        '_id': '5f7c88bb619${data.id}',
        //'_id': widget.sessionData.id,
        'name': data.name,
        'profile': data.profile,
        'sex':data.sex,
        'intDay':data.intDay+1,
        'intMonth':data.intMonth+1,
        'day':DateFormat.E().format(DateTime.now()),
        'month':DateFormat.MMM().format(DateTime.now()),
        'time':  new DateTime.now().millisecondsSinceEpoch,
        'metta':sound
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    print("End");
    print(responsenew.toString());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0c111b),
      body: Stack(
        children: <Widget>[


          Positioned(
            top: 0,
            child:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(

                image: DecorationImage(
                    image: const AssetImage('assets/intro/topdark.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                ),
              ),
            ),

          ),


          Positioned(
              top: 0,
              child:  Container(
                  padding: EdgeInsets.only(top:35),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-100,
                  child: SingleChildScrollView(
                      child: Column(
                          children: [

                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),

                              ],
                            ),




                            Container(
                                width:  MediaQuery.of(context).size.width,
                                child:SingleChildScrollView(
                                 //   scrollDirection: Axis.horizontal,
                                    child:Column (
                                        children:mettas.map((item) =>


                                            Container(
                                              margin: EdgeInsets.only(top:15),
                                              child:
                                              Row(
                                                children: [
                                                  SizedBox(width: 40,),
                                                  Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                        color: const Color(0xffffffff),
                                                        //border: Border.all(width: 3.0, color: const Color(0xffa5c3f7)),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: item.profile == 'NewProfile'  ? NetworkImage(item.sex) : item.profile != ''  ? NetworkImage(item.profile) : NetworkImage(item.sex)
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(width: 15,),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${item.metta}",textScaleFactor: 1.6,style: TextStyle(color: Colors.white),),
                                                      Row(
                                                        children: [
                                                          Text("${item.name}",textScaleFactor: 1.2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                          Text(" - ${timeTodate(num.tryParse(item.time))}",textScaleFactor: 1.2,style: TextStyle(color: Colors.white70,),),
                                                        ],
                                                      )
                                                    ],
                                                  ),


                                                ],
                                              )
                                              ,)
                                        ).toList().cast<Widget>()
                                    )
                                )
                            )





                          ]
                      )
                  )
              )
          ),



          Positioned(
            bottom: 100,
            child:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ Color(0xff0c111b).withOpacity(0.0), Color(0xff0c111b)])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [


                  Container(
                      width:  MediaQuery.of(context).size.width,
                      child:SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child:Row (
                              children:[

                                for (int i = 0; i < audios.length; i++)

                                  InkWell(
                                      onTap:(){


                                        SessionHistory save = SessionHistory(
                                            id:audios[i].metas.id,
                                            url: audios[i].path,
                                            title:audios[i].metas.title,
                                            artist:audios[i].metas.artist,
                                            artwork:audios[i].metas.image.path,
                                            description: audios[i].metas.album,
                                            time: new DateTime.now().millisecondsSinceEpoch,
                                            day: DateFormat.E().format(DateTime.now()),
                                            intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(audios[i].metas.album)+intDay : num.tryParse(audios[i].metas.album),
                                            topicId: 0,
                                            topicName: "ห้องแผ่เมตตา"
                                        );

                                        FlutterSession().set('history', save);
                                        toMettaClick(sessionMetta,"ฟัง ${audios[i].metas.title}");
                                        makePostHistory(audios[i],audios[i].metas.id,"ห้องแผ่เมตตา");
                                        _assetsAudioPlayer.open(
                                          Playlist(audios: audios.sublist(audios.indexOf(audios[i]))),
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
                                                audios[i].metas.id,
                                                audios[i].path,
                                                audios[i].metas.title,
                                                audios[i].metas.artist,
                                                audios[i].metas.image.path,
                                                audios[i].metas.album,
                                                new DateTime.now().millisecondsSinceEpoch,
                                                "ห้องแผ่เมตตา"
                                            )
                                        );

                                      },
                                      child:  Container(
                                        width: MediaQuery.of(context).size.height/6.5,
                                        height: MediaQuery.of(context).size.height/6.5,
                                        //padding: EdgeInsets.only(left: 25),
                                        margin: EdgeInsets.only(left: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: const Color(0xffffffff),
                                          image: DecorationImage(
                                              image: NetworkImage(audios[i].metas.image.path),
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.bottomCenter
                                          ),
                                        ),
                                      )
                                  ),
                              ]
                          )
                      )
                  )


                ],
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



        ],
      ),
    );
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
