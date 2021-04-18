//import 'package:charts_flutter/flutter.dart';
import 'dart:convert';
import 'dart:math';

import 'package:JaiMy/models/sessionMakha.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';

import '../constants.dart';




class saveSitting extends StatefulWidget {
  final bool statusPlay;

  saveSitting({Key key, @required this.statusPlay}) : super(key: key);
  @override
  State<StatefulWidget> createState() => saveSittingState();
}

class saveSittingState extends State<saveSitting> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  bool isPlaynow;
  double _x = 200;
  double _y = 300;
  SessionMakha sessionMakha;
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  static DataApr DatabaseApr = DataApr();
  String detail = "";
  int sumJai = 0;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isPlaynow = widget.statusPlay ? widget.statusPlay : true;
    Future(() async{
      await _startMakha(context);
      setState(() {
        _x = MediaQuery.of(context).size.width/2 - 50;
        _y =  MediaQuery.of(context).size.height/2 - 50;
      });
    });
    DatabaseApr.sumHisJai().then((value) { setState((){sumJai = value;});print(value);});
    FlutterSession().get("user_detail").then((val){  setState((){  detail = val == null ? "..." : val;}); });


    datebaseHelper.getUser(1).then((result) async {
      user = result;
      setState(() {});
    });

    }
  bool isInteger(num value) =>
      value is int || value == value.roundToDouble();
  @override
  Widget build(BuildContext context) {
    return  isPlaynow ?
    Positioned(
        left: 0,
        top: 0,
        child: _assetsAudioPlayer.builderRealtimePlayingInfos(
        builder: (context, infos) {
          if (infos != null) {
            //final myAudio = this.audios[0];
            //print(playing.audio.audio.metas.title);
            //print(playing.audio.audio.metas.artist);
            //print(isInteger(infos.currentPosition.inMilliseconds/99));
            //print((infos.currentPosition.inMilliseconds/99));
            //print(isInteger(infos.currentPosition.inSeconds/60));

            if(isInteger(infos.currentPosition.inSeconds/60)){
              makePostRequest(infos.currentPosition.inMinutes);
              datebaseHelper.updateUser(User(
                  id: 1,
                  name: user.name,
                  profile: user.profile,
                  sex: user.sex,
                  age: user.age,
                  intExp: user.intExp,
                  intMinute: user.intMinute + infos.currentPosition.inMinutes,
                  intListen: user.intListen + infos.currentPosition.inMinutes,
                  intKnow: user.intKnow,
                  intRelex: user.intRelex,
                  intWave: user.intWave,
                  intMeditate: user.intMeditate,
                  intLesson: user.intLesson,
                  intEmotion: user.intEmotion,
                ));
                print(user.name);
              print('saved');

            }else{

            }
           //print("${infos.duration.inMilliseconds}====${infos.currentPosition.inMilliseconds}");
            return Container();
                /*
                Draggable(
                  child: InkWell(
                    onTap: (){
                      print(infos.currentPosition.inMinutes);
                      showPopupSave(context, saveMakha(minute: infos.currentPosition.inMinutes , sessionMakha: sessionMakha,), 'บันทึกการนั่ง');
                      setState(() {
                        isPlaynow = false;
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:  ((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? ThemeNew :Color(0xFF1a59fc),
                          border: Border.all(
                            color:((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? ThemeNew : Color(0xFF1a59fc),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,5),
                                blurRadius: 30,
                                color: Colors.black.withOpacity(0.4)
                            )
                          ]
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? "กำลัง":"บันทึก"}",textScaleFactor: 1.4,style:TextStyle(color: Colors.white)),
                          Text("${((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? "บันทึก": infos.currentPosition.inMinutes}",textScaleFactor:((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? 1.8 : 2.0,style:TextStyle(height:((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ?1.2 : 1.0,color:  Colors.white,fontWeight: FontWeight.bold),),
                          Text("${((infos.duration.inSeconds-10) <= infos.currentPosition.inSeconds) ? "อัตโนมัติ":"นาที"}",textScaleFactor: 1.0,style:TextStyle(color: Colors.white)),
                        ],
                      )
                      ,
                    ),
                  ) ,
                  feedback: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:Color(0xFF1a59fc),
                        border: Border.all(
                          color:Color(0xFF1a59fc),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0,5),
                              blurRadius: 30,
                              color: Colors.black.withOpacity(0.4)
                          )
                        ]
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text("บันทึก",textScaleFactor: 0.8,style:TextStyle(color: Colors.white)),
                        //Text("ชม.",textScaleFactor: 1.6,style:TextStyle(height: 1.0,color: Colors.white),),
                      ],
                    )
                    ,
                  ),
                  childWhenDragging: Container(),

                  onDragEnd: (dragDetails) {
                    setState(() {
                      _x = dragDetails.offset.dx;
                      // if applicable, don't forget offsets like app/status bar
                      _y = dragDetails.offset.dy;
//                      _y = dragDetails.offset.dy - appBarHeight - statusBarHeight;
                    });
                  },*/




          }
          return SizedBox(height: 100,width: 100,);
        }
        )
        ): Container();
  }




  showPopupSave(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: PopupContent(
          content: Scaffold(

            resizeToAvoidBottomInset: false,
            // backgroundColor: Colors.white.withOpacity(0.5),
            backgroundColor: Colors.black.withOpacity(0.15),
            body: widget,
          ),
        ),
      ),
    );
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
          sessionMakha = myData;
        });
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        dynamic data =  val;
        print(data['id']);
        print(data['name']);
        print(data['profile']);
        setState(() {
          sessionMakha = SessionMakha(
              id: data['id'],
              name:user.name,
              profile: user.profile,
              sex: data['sex'],
              rankDay: data['rankDay'],
              rankMonth: data['rankMonth'],
              intDay:DateFormat.E().format(DateTime.now()) != data['day'] ? 0 : data['intDay'],
              intMonth:DateFormat.MMM().format(DateTime.now()) != data['month'] ? 0 : data['intMonth'],
              day:data['day'],
              month:data['month']
          );
        });
      }

    }) .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });
  }


  makePostRequest(minute) async {
    FlutterSession().get("token").then((val) async {
      final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/makhas';

      var responsenew = await Dio().post(uri,
        data: {
          //  '_id': '5f7c88bb6191610555985122',
          '_id': '5f7c88bb619${sessionMakha.id}',
          //'_id': widget.sessionData.id,
          'name': sessionMakha.name,
          'profile': sessionMakha.profile,
          'sex': sessionMakha.sex,
          "rankDay": 1,
          'rankMonth': 1,
          'intDay': sessionMakha.intDay + minute,
          'intMonth': sessionMakha.intMonth + minute,
          'day': DateFormat.E().format(DateTime.now()),
          'month': DateFormat.MMM().format(DateTime.now()),
          'time': new DateTime.now().millisecondsSinceEpoch,
          'detail': detail,
          'intJai': sumJai,
          'userId':val['token'],
          'tokenId':val['messageId']
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      print(responsenew.toString());
    });
    await FlutterSession().set('makha',
        SessionMakha(
          id:sessionMakha.id,
          name: sessionMakha.name,
          profile:sessionMakha.profile,
          sex:sessionMakha.sex,
          rankDay:1,
          rankMonth:1,
          intDay:sessionMakha.intDay+minute,
          intMonth:sessionMakha.intMonth+minute,
          day:DateFormat.E().format(DateTime.now()),
          month:DateFormat.MMM().format(DateTime.now()),
        )
    );

  }

}




class PopupLayout extends ModalRoute {
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
      {Key key,
        this.bgColor,
        @required this.child,
        this.top,
        this.bottom,
        this.left,
        this.right});

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: this.bottom,
          left: this.left,
          right: this.right,
          top: this.top),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}



class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({
    Key key,
    this.content,
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }

}





class saveMakha extends StatefulWidget {
  //final User touser;
  final int minute;
  final SessionMakha sessionMakha;
  saveMakha({Key key, @required this.minute,this.sessionMakha}) : super(key: key);
  //final int saveBoon;
  //editShow({Key key, @required this.touser}) : super(key: key);
  @override
  saveMakhaState createState() => saveMakhaState();
}

class saveMakhaState extends State<saveMakha> {


  makePostRequest() async {

    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/makhas';

    var responsenew = await Dio().post(uri,
      data:  {
        //  '_id': '5f7c88bb6191610555985122',
        '_id': '5f7c88bb619${widget.sessionMakha.id}',
        //'_id': widget.sessionData.id,
        'name': widget.sessionMakha.name,
        'profile': widget.sessionMakha.profile,
        'sex':widget.sessionMakha.sex,
        "rankDay":1,
        'rankMonth':1,
        'intDay':widget.sessionMakha.intDay+widget.minute,
        'intMonth':widget.sessionMakha.intMonth+widget.minute,
        'day':DateFormat.E().format(DateTime.now()),
        'month':DateFormat.MMM().format(DateTime.now()),
        'time':  new DateTime.now().millisecondsSinceEpoch,
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    print(responsenew.toString());
    await FlutterSession().set('makha',
        SessionMakha(
          id:widget.sessionMakha.id,
          name: widget.sessionMakha.name,
          profile:widget.sessionMakha.profile,
          sex:widget.sessionMakha.sex,
          rankDay:1,
          rankMonth:1,
          intDay:widget.sessionMakha.intDay+widget.minute,
          intMonth:widget.sessionMakha.intMonth+widget.minute,
          day:DateFormat.E().format(DateTime.now()),
          month:DateFormat.MMM().format(DateTime.now()),
        )
    );

  }

  @override
  void initState() {
    super.initState();
    makePostRequest();

    datebaseHelper.getUser(1).then((result) async {

      user=result;
      setState(() {});


      await datebaseHelper.updateUser(User(
        id: 1,
        name: user.name,
        profile: user.profile,
        sex: user.sex,
        age: user.age,
        intExp: user.intExp+10,
        intMinute: user.intMinute +widget.minute,
        intListen: user.intListen +widget.minute,
        intKnow: user.intKnow,
        intRelex: user.intRelex,
        intWave: user.intWave,
        intMeditate: user.intMeditate,
        intLesson: user.intLesson,
        intEmotion: user.intEmotion,
      ));
      print(user.name);
      Saved = true;
      setState((){});
      var re = user.intExp+5;
      if(re > 0 && re <= 20){
        datebaseHelper.insertReward(Reward(
          id:1,
          rewardName:"เริ่มต้นฝึกใจ",
          rewardPhoto:"e1",
          rewardDetail:"คุณได้เริ่มบันทึกสติสบายจากการปฏิบัติธรรม",
        ));
      }else if(re > 50 && re <= 70){
        datebaseHelper.insertReward(Reward(
          id:2,
          rewardName:"นักฝึกใจ",
          rewardPhoto:"e2",
          rewardDetail:"คุณได้บันทึกมากกว่า 10 ครั้ง",
        ));
      }else if(re > 100 && re <= 120){
        datebaseHelper.insertReward(Reward(
          id:3,
          rewardName:"ผู้ปักธง",
          rewardPhoto:"e3",
          rewardDetail:"คุณได้บันทึกมากกว่า 20 ครั้ง",
        ));
      }else if(re > 500 && re <= 520){
        datebaseHelper.insertReward(Reward(
          id:4,
          rewardName:"ตราสีเงิน",
          rewardPhoto:"e4",
          rewardDetail:"คุณได้บันทึกมากกว่า 50 ครั้ง",
        ));
      }else if(re > 1000 && re <= 1020){
        datebaseHelper.insertReward(Reward(
          id:5,
          rewardName:"ตราทองคำ",
          rewardPhoto:"e5",
          rewardDetail:"คุณได้บันทึกมากกว่า 100 ครั้ง",
        ));
      }
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
  List<String> textKnow = [
    'หลับลึก',
    'กึ่งหลับ กึ่งตื่น',
    'เรื่อยๆ',
    'นิ่งไม่ฟุ้งซ่าน',
    'ไม่ลังเล ไม่สงสัย',
    'สงบตั้งมั่น'
  ];
  List<String> textRelex = [
    'เครียด ปวดหัว',
    'ตึง ไม่มีความสุข',
    'เบื่อ ขี้เกียจนั่ง',
    'อึดอัด ไม่สบายตัว',
    'เพลียจิตใจ อ่อนแอ',
    'ไม่รู้สึกอะไรเลย',
    'เฉยๆ ไม่คิดอะไร',
    'นิ่งๆเฉยๆ',
    'โล่ง โปร่ง เบาสบาย',
    'ตัวขยายใจเบาสบาย',
    'ตัวหายใจอิ่มเอิบ'
  ];
  bool Saved = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(left: 20,right: 20,bottom: 40),
        width:MediaQuery
            .of(context)
            .size
            .width/1.5  ,
        height: MediaQuery
            .of(context)
            .size
            .width/1.5  ,
        // color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            //border: Border.all(color: Colors.yellowAccent,width: 8.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0,10),
                  blurRadius: 30,
                  color: Colors.black.withOpacity(0.4)
              )
            ]
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Image(image: AssetImage('assets/sex/sit_${user.sex}.png'),width: MediaQuery
                  .of(context)
                  .size
                  .width/4,height: MediaQuery
                  .of(context)
                  .size
                  .width/4,),
              SizedBox(height: 10,),
              Text("บันทึกผลเรียบร้อยแล้ว",textScaleFactor: 2.0,style: TextStyle(color: ThemeNew8),),
              Text("วันนี้คุณนั่งไปแล้ว ${widget.sessionMakha.intDay+widget.minute} นาที",textScaleFactor: 1.6,style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              InkWell(
                splashColor: Colors.transparent,
                onTap: (){
                  Navigator.pop(context);
                  // Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: GivePage(typeId: cho.typeId,saveBoon: widget.saveBoon+20,)));

                },
                child:Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width/1.5-40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 15),
                  decoration: BoxDecoration(
                      color: ThemeNew8,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,5),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: Text("ปิดหน้าต่าง",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),textScaleFactor: 1.4,),

                ) ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



