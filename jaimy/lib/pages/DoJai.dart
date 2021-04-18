import 'package:JaiMy/models/sessionHistory.dart';
import 'package:JaiMy/models/sessionMakha.dart';
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

class DoJai extends StatefulWidget{
  DoJai({Key key, @required this.text_profile,this.data}) : super(key: key);
  final text_profile;
  final data;
  @override
  DoJaiState createState() => DoJaiState(data);
}

class DoJaiState extends State<DoJai> {
  DoJaiState(this.data);
  final data;
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  String userId = "";
  int intDay = 0;
  String savedDay = "";
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  static DataApr DatabaseApr = DataApr();
  bool isPlaynow = true;



  Future<void> _startJai(context) async {
    await FlutterSession().get("myjai").then((val) async {
      if(val == 0 || val == null ){
        dynamic data =  val;
        print("Null ::: JAI");

        SessionJai myJai = SessionJai(relexInt:0, angryInt: 0, sadInt: 0, happyInt: 0,loveInt: 0, sumInt: 0);
        await FlutterSession().set('myjai', myJai);
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        dynamic data =  val;
        print(data['relexInt']);
        setState(() {
          jai = SessionJai(
              relexInt: data['relexInt'],
              angryInt: data['angryInt'],
              sadInt: data['sadInt'],
              happyInt: data['happyInt'],
              loveInt: data['loveInt'],
              sumInt: data['sumInt']
          );
        });
      }
    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });

    await FlutterSession().get("expJai").then((val) async {
      print("Show::Start ExpJai");
      if(val == 0 || val == null ){
        //dynamic data =  val;
        print("Null ::: EXPJAI");
        SessionExp myJai = SessionExp(relexDay:"", angryDay: "", sadDay: "", happyDay: "",loveDay: "", expInt: 0,jealousDay: "",challengeDay: "",confidenceDay: "",openDay: "");
        //SessionJai myJai = SessionJai(relexInt:0, angryInt: 0, sadInt: 0, happyInt: 0,loveInt: 0, sumInt: 0);
        await FlutterSession().set('expJai', myJai);
        setState(() {
          exp = myJai;
        });
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        //await FlutterSession().set('expJai', "10");
        dynamic data =  val;
        print("Show::${val}");
        setState(() {
          exp = SessionExp(
              relexDay:data['relexDay'],
              angryDay: data['angryDay'],
              sadDay: data['sadDay'],
              happyDay: data['happyDay'],
              loveDay: data['loveDay'],
              expInt: data['expInt'],
              jealousDay: data['jealousDay'],
              challengeDay: data['challengeDay'],
              confidenceDay: data['confidenceDay'],
              openDay: data['openDay']
          );
        });
      }
    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });


    await FlutterSession().get("myeq").then((val) async {
      if(val == 0 || val == null ){
        dynamic data =  val;
        print("Null ::: EQ");

        SessionEQ myEQ = SessionEQ(jealousInt:0, challengeInt: 0, confidenceInt: 0, openInt: 0, sumInt: 0);
        await FlutterSession().set('myeq', myEQ);
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        dynamic data =  val;
        print(data['jealousInt']);
        setState(() {
          eq = SessionEQ(
              jealousInt: data['jealousInt'],
              challengeInt: data['challengeInt'],
              confidenceInt: data['confidenceInt'],
              openInt: data['openInt'],
              sumInt: data['sumInt']
          );
        });
      }
    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });

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


  @override
  void initState() {
    super.initState();
    Future(() {
      _startJai(context);
      _startMakha(context);
    });
  }


  String today = DateFormat.E().format(DateTime.now());
  SessionJai jai = SessionJai(relexInt: 0,angryInt: 0,sadInt: 0,happyInt: 0,sumInt: 0);
  SessionEQ eq = SessionEQ(jealousInt:0, challengeInt: 0, confidenceInt: 0, openInt: 0, sumInt: 0);
  SessionExp exp = SessionExp(relexDay:"", angryDay: "", sadDay: "", happyDay: "",loveDay: "", expInt: 0,jealousDay: "",confidenceDay: "",challengeDay: "",openDay: "");



  @override
  Widget build(BuildContext context) {
    List<Widget> Watjats = [
      WatRelex(text_profile:widget.text_profile),
      WatAngry(text_profile:widget.text_profile),
      WatSad(text_profile:widget.text_profile),
      WatHappy(text_profile:widget.text_profile),
      WatLove(text_profile:widget.text_profile),
      WatJealous(text_profile:widget.text_profile),
      WatChallenge(text_profile:widget.text_profile),
      WatConfidence(text_profile:widget.text_profile),
      WatOpen(text_profile:widget.text_profile)
    ];


    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Stack(
        children: <Widget>[
         /* Positioned(
            bottom: 0,
            child:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(

                image: DecorationImage(
                    image:  (DateTime.now().hour < 13 && DateTime.now().hour > 9) ? const AssetImage('assets/intro/botton.png') :  const AssetImage('assets/intro/botton.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.bottomCenter
                ),
              ),
            ),

          ),
          Positioned(
            top: 0,
            child:  Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(

                image: DecorationImage(
                    image: const AssetImage('assets/intro/top.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                ),
              ),
            ),

          ),*/


          Positioned(
              top: 0,
              child:  Container(
                  padding: EdgeInsets.only(top:35),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                      child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                FlatButton(
                                  child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),

                              ],
                            ),

                            for (int i = 0; i < data.length; i++)

                              Column(
                                children: [
                                  Container(
                                    width:MediaQuery.of(context).size.width,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      image: DecorationImage(
                                        image: NetworkImage(data[i]['mindPhoto']),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Text(data[i]['mindName'],textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold),),
                                  SizedBox(height: 6,),
                                  Text(data[i]['mindDetail'],textScaleFactor: 1.6,textAlign: TextAlign.center,style:TextStyle(height: 1.0)),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    onTap: (){
                                      if(today != exp.angryDay) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Watjats[i],
                                          ),
                                        );
                                      }else{
                                        showAlertDialog(context,"อารมณ์นี้");
                                      }

                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: HexColor(data[i]['mindCButton']),
                                      ),
                                      child: Text(
                                        "${data[i]['mindButton']}",
                                        textScaleFactor: 1.6,
                                        style: TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40,),
                                  if(data[i]['mindIntro'] != "") Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    width:MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data[i]['mindIntro'],textScaleFactor: 1.8,style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(height: 6,),
                                        Text(data[i]['mindIntroDetail'],textScaleFactor: 1.4),



                                        Column(
                                          //alignment: WrapAlignment.center,
                                            children:   [
                                              for (int j = 0; j < data[i]['audios'].length; j++)
                                                InkWell(
                                                    onTap: (){
                                                      SessionHistory save = SessionHistory(
                                                          id:data[i]['audios'][j]['id'].toString(),
                                                          url: data[i]['audios'][j]['url'],
                                                          title:data[i]['audios'][j]['title'],
                                                          artist:data[i]['audios'][j]['artist'],
                                                          artwork:data[i]['audios'][j]['artwork'],
                                                          description:data[i]['audios'][j]['description'],
                                                          time: new DateTime.now().millisecondsSinceEpoch,
                                                          day: DateFormat.E().format(DateTime.now()),
                                                          intDay: savedDay == DateFormat.E().format(DateTime.now())? num.tryParse(data[i]['audios'][j]['description'])+intDay : num.tryParse(data[i]['audios'][j]['description']),
                                                          topicId: 0,
                                                          topicName:"ดูแลใจ"
                                                      );
                                                      FlutterSession().set('history', save);
                                                      makePostHistory(data[i]['audios'][j],data[i]['audios'][j]['id'],"ดูแลใจ");
                                                      _assetsAudioPlayer.open(
                                                        toAudio(data[i]['audios'][j]),
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
                                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                                      margin: EdgeInsets.only(left: 0,right: 0,top: 15),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        color: HexColor(data[i]['mindBg']),
                                                      ),
                                                      child:Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                  width:MediaQuery.of(context).size.width-140,
                                                                  child:Text(
                                                                    "${data[i]['audios'][j]['title']}",
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
                                                                '${data[i]['audios'][j]['artist']} - ${data[i]['audios'][j]['description']} min',
                                                                textScaleFactor: 1.4,
                                                                style: TextStyle(
                                                                  color: const Color(0xccffffff),
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            width: 46.0,
                                                            height: 46.0,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(19.0),
                                                              color: const Color(0xffffffff),
                                                              image: DecorationImage(
                                                                image: NetworkImage(data[i]['audios'][j]['artwork']),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                )
                                            ]
                                        ),




                                      ],
                                    ) ,
                                  ),


                                  SizedBox(height: 100,)

                                ],
                              )


                            /*


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


                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Watjats[0],
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 30,vertical: MediaQuery.of(context).size.height/10),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.text_profile[13]}',
                                      textScaleFactor: 2.4,
                                      style: TextStyle(
                                        color: const Color(0xff344d6f),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      '${widget.text_profile[14]}',
                                      textScaleFactor: 2.0,
                                      style: TextStyle(
                                        height: 1.3,
                                        color: const Color(0xcc344d6f),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),


                                    Image(image: AssetImage("assets/emotion/smile.png"),width: 55,height: 55,)

                                  ],
                                ),
                              ),
                            ),




                            Container(
                                width:  MediaQuery.of(context).size.width,
                                child:SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child:Row (
                                        children:[



                                          /*
                                          * 1 ความโกรธ
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.angryDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Watjats[1],
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[17]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/angry.png"),width: 65,height: 65,),
                                                    Text(
                                                      "${widget.text_profile[16]}",
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${jai.angryInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),








                                          /*
                                          * 2 ความเหงา
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.sadDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatSad(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[19]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/opensad.png"),width: 65,height: 65,),
                                                    Text(
                                                      "${widget.text_profile[18]}",
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${jai.sadInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),








                                          /*
                                          * 3 ความสดใส
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.happyDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatHappy(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[21]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/openhappy.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[20]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${jai.happyInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),













                                          /*
                                          * 4 ความหลงรัก
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.loveDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatLove(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[23]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/kissing.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[22]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${jai.loveInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),



                                          /*
                                          * 5 ความน้อยเนื้อต่ำใจ
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.jealousDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatJealous(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[25]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/shy.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[24]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${eq.jealousInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),



                                          /*
                                          * 6 ความกล้า
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.challengeDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatChallenge(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[27]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/cool.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[26]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${eq.challengeInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),






                                          /*
                                          * 7 ความเชื่อมั่น
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.confidenceDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatConfidence(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[29]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/goofy.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[28]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${eq.confidenceInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),



                                          /*
                                          * 8 ความเป็นกันเอง
                                          * */
                                          InkWell(
                                              onTap: (){
                                                if(today != exp.openDay) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => WatOpen(text_profile:widget.text_profile),
                                                    ),
                                                  );
                                                }else{
                                                  showAlertDialog(context,"${widget.text_profile[31]}");
                                                }
                                              },
                                              child:Container(
                                                margin: EdgeInsets.only(left: 40),
                                                child: Column(
                                                  children: [
                                                    Image(image: AssetImage("assets/emotion/wink.png"),width: 65,height: 65,),
                                                    Text(
                                                      '${widget.text_profile[30]}',
                                                      textScaleFactor: 1.6,
                                                      style: TextStyle(
                                                        color: const Color(0xfe344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '${widget.text_profile[15]} ${eq.openInt}%',
                                                      textScaleFactor: 1.2,
                                                      style: TextStyle(
                                                        color: const Color(0xcc344d6f),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    )
                                                  ],
                                                ),
                                              )
                                          ),


                                        ]
                                    )
                                )
                            )

                             */





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
          )

          /*
          Transform.translate(
            offset: Offset(34.0, 58.0),
            child: Text(
              'ตอนนี้คุณโกรธอยู่หรือเปล่าว?',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(34.0, 89.0),
            child: Text(
              'วัดอารมณ์โกรธของคุณ - ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(40.0, 130.0),
            child: Container(
              width: 78.0,
              height: 78.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(41.0, 298.0),
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(33.0, 358.0),
            child: Text(
              'วัดความเหงา',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xfeffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(42.0, 380.0),
            child: Text(
              'ล่าสุด 28%',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(141.0, 298.0),
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(138.0, 358.0),
            child: Text(
              'วัดความรัก',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xfeffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(142.0, 380.0),
            child: Text(
              'ล่าสุด 28%',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(241.0, 298.0),
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(233.0, 358.0),
            child: Text(
              'วัดความสงบ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xfeffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(242.0, 380.0),
            child: Text(
              'ล่าสุด 28%',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(341.0, 298.0),
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(333.0, 358.0),
            child: Text(
              'วัดความสดใส',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xfeffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(342.0, 380.0),
            child: Text(
              'ล่าสุด 28%',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(41.0, 298.0),
            child:
                // Adobe XD layer: 'opensad' (shape)
                Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(141.0, 298.0),
            child:
                // Adobe XD layer: 'kissing' (shape)
                Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(241.0, 298.0),
            child:
                // Adobe XD layer: 'smile' (shape)
                Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(341.0, 298.0),
            child:
                // Adobe XD layer: 'goofy' (shape)
                Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(40.0, 130.0),
            child:
                // Adobe XD layer: 'angry' (shape)
                Container(
              width: 78.0,
              height: 78.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(21.0, 12.0),
            child: Text(
              'กลับ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),


           */






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