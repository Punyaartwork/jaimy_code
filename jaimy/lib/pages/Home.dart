import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:JaiMy/models/canon.dart';
import 'package:JaiMy/models/makha.dart';
import 'package:JaiMy/models/online.dart';
import 'package:JaiMy/pages/Session.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_session/flutter_session.dart';
import 'Category.dart';
import 'Me.dart';
import 'Social.dart';
class Home extends StatefulWidget{
  Home({Key key, this.analytics, this.observer,this.data, this.colors }) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final data;
  final List<Color> colors;
  @override
  _HomeState createState() => _HomeState(analytics, observer,data,colors);
}

class _HomeState extends State<Home> {
  _HomeState(this.analytics, this.observer,this.data,this.colors );

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final data;
  final List<Color> colors;
  bool isPlaynow = true;
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  static DataApr DatabaseApr = DataApr();
  final _random = new Random();
  bool show = true;
  var mettas = [];
  DateTime dateTime = DateTime.now();
  bool isLang = true;
  var mindful = [];
  /**
   * Generates a positive random integer uniformly distributed on the range
   * from [min], inclusive, to [max], exclusive.
   */
  int next(int min, int max) => min + _random.nextInt(max - min);

  void initState()  {
    super.initState();

    DateTime dateTime = DateTime.now();
    print("TIMEZONE ::::: ${dateTime.timeZoneName == "+07" ? "THAI" : "Not THAI"}");



    getHome().then((data) => setState(() {
      isLang = dateTime.timeZoneName == "+07" ? true : false;
      categoryNames = List<dynamic>.from(data['categoryNames']);
      category = data['category'];
      sessions = data['sessions'];
      mettas = data['Mettas'];
      mindful = data['mindful'];
    }));

    InternetAddress.lookup('google.com').then((value) {
      if (value.isNotEmpty && value[0].rawAddress.isNotEmpty) {
        show = true;
        setState(() {});
      }else{
        show = false;
        setState(() {});
        print('not connected');
      }
    });




    rootBundle.loadString("assets/json/listCanon.json").then((value) =>
        setState(() {
          canons = (jsonDecode(value) as List).map((i) =>
              Canons.fromJson(i)).toList();
          //print(canons.toString());
          canon = getRandomElement(canons);
        })
    );
    //print("SHOW 2  ${data['categoryNames']}");
    //print("SHOW 3  ${data['category']}");

    datebaseHelper.getUser(1).then((result) async {
      //String todata = utf8.decode(data);
      user = result;
      setState(() {  });
      await DatabaseApr.sumHisJai().then((value) { setState((){sumJai = value;});});
      await FlutterSession().get("user_detail").then((val){  setState((){  detail = val == null ? "..." : val;}); });
      await makePostRequest(result).then((value) {
        // showOnline = true;
        setState(() {  });
        AllUser().then((value)
        {
          online = value;
          //showOnline = false;
          setState(() {  });
        });
      });
    });


    Allmakha().then((value) => setState((){ makha = value; }));
    if(next(0,15) == 5){
      Future(() {
        showPopupIntro(context, QuesDay(user: user,), '');
      });
    }
  }
  String detail = "";
  int sumJai = 0;

  var sessions = [];
  List<dynamic> categoryNames = [];
  var category = [];
  List<Online> online = [];
  List<Makha> makha = [];


  List<Canons> canons;
  Canons canon = Canons(
      id: 1,
      canonName: "ไร้กังวล",
      canon: "ทำใจไร้กังวลในทุกสิ่ง"
  );
  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }
  String Hello(){
    if(DateTime.now().hour < 5){
      return isLang ?  "สวัสดียามเช้าค่ำ" : "Good morning";
    }else if(DateTime.now().hour >= 5 && DateTime.now().hour < 9){
      return isLang ? "อรุณสวัสดิ์" :"Good morning";
    }else if(DateTime.now().hour >= 9 && DateTime.now().hour < 12){
      return isLang ? "สวัสดียามสาย" :"Good morning" ;
    }else if(DateTime.now().hour >= 12 && DateTime.now().hour < 15){
      return  isLang ? "สวัสดียามบ่าย" : "Good afternoon";
    }else if(DateTime.now().hour >= 15 && DateTime.now().hour < 19){
      return  isLang ? "สวัสดียามเย็น" : "Good evening";
    }else if(DateTime.now().hour >= 19 && DateTime.now().hour < 21){
      return  isLang ? "สวัสดียามค่ำ" : "Good day";
    }else if(DateTime.now().hour >= 21 && DateTime.now().hour <= 24){
      return  isLang ? "ราตรีสวัสดิ์" : "Good night";
    }
  }

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


  makePostRequest(User user) async {
    FlutterSession().get("token").then((val) async {
      final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/openfirst';

      var responsenew = await Dio().post(uri,
        data:  {
          '_id': val['token'],
          'name': user.name,
          'profile':user.profile,
          'sex':user.sex,
          'intExp':user.intExp,
          'intMinute':user.intMinute,
          'intKnow': user.intKnow,
          'intRelex': user.intRelex,
          'intWave': user.intWave,
          'intMeditate': user.intMeditate,
          'time':  new DateTime.now().millisecondsSinceEpoch,
          'detail': detail,
          'intJai' : sumJai,
          'userId':val['token'],
          'tokenId':val['messageId']
        },
        options:  Options(contentType:Headers.formUrlEncodedContentType),
      );
      print(responsenew.toString());
    });

  }
  Future<List<Online>> AllUser() async {
    //List<Online> onlines = [];
    final onlines = <Online>[];
    Dio dio = new Dio();
    var response = await dio.get('https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/todos');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // String data = utf8.decode(response.bodyBytes);
     // print(response.data);
      for (var i = 0; i < response.data.length; i++) {
        onlines.add(Online(
          id: response.data[i]['_id'],
          name: response.data[i]['name'],
          profile: response.data[i]['profile'],
          sex: response.data[i]['sex'],
          intExp: num.tryParse(response.data[i]['intExp']),
          intMinute: num.tryParse(response.data[i]['intMinute']),
          intKnow: num.tryParse(response.data[i]['intKnow']),
          intRelex: num.tryParse(response.data[i]['intRelex']),
          intWave: num.tryParse(response.data[i]['intWave']),
          intMeditate: num.tryParse(response.data[i]['intMeditate']),
          time: num.tryParse(response.data[i]['time']),
          detail: response.data[i]['detail'] != null ? response.data[i]['detail'] : "...",
          intJai:response.data[i]['intJai'] != null ? num.tryParse(response.data[i]['intJai']):0,
          userId: response.data[i]['userId'],
          tokenId: response.data[i]['tokenId'],

        )
        );
      }
      return onlines;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }



  Future<List<Makha>> Allmakha() async {
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
      return makhas;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }




  Future getHome() async {
    //List<Online> onlines = [];
    Dio dio = new Dio();
    var response = await dio.get('https://05hx8i6qja.execute-api.us-east-1.amazonaws.com/dev/${DateTime.now().timeZoneName == "+07"  ? "home" : "home_en"}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // String data = utf8.decode(response.bodyBytes);
      //print(response.data.toString());
      return response.data;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[0],
      body: Stack(
        children: <Widget>[

          Positioned(
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

          ),



          Positioned(
            top: 40,
            right: 30,
            child:
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Me(analytics: analytics,observer: observer,data:mindful),
                  ),
                );
              },
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: user.profile == 'NewProfile'  ? AssetImage("assets/sex/${user.sex}.png") : user.profile != ''  ? NetworkImage(user.profile) : AssetImage("assets/sex/${user.sex}.png")
                    )
                ),
              ),
            )
            ,

          ),





          Positioned(
            top:  MediaQuery.of(context).size.height/7.5,
            //right: 30,
            child: Container(
              width:  MediaQuery.of(context).size.width,
              child:Text(
                Hello(),
                textScaleFactor: 3.2,
                style: TextStyle(
                  color: const Color(0xffffffff),
                ),
                textAlign: TextAlign.center,
              ),
            )

          ),

          DateTime.now().timeZoneName == "+07"  ? Positioned(
              top:  MediaQuery.of(context).size.height/5.3,
              //right: 30,
              child: Container(
                width:  MediaQuery.of(context).size.width,
                child:Text(
                  "${canon.canon}",
                  textScaleFactor: 1.8,
                  style: TextStyle(
                    color: const Color(0xccffffff),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
          ) : Container(),


          Positioned(
              top:  MediaQuery.of(context).size.height/4,
              //right: 30,
              child:show ? Container(
                width:  MediaQuery.of(context).size.width,
                child:SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                    child:Row (
                      children:[
                        if(categoryNames != null)

                        for (int i = 0; i < categoryNames.length; i++)

                          InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  Category(
                                  analytics: analytics,
                                  observer: observer,
                                  data: category[i]
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            margin: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19.0),
                              color: colors[1],
                            ),
                            child: Text(
                              categoryNames[i],
                              textScaleFactor: 1.4,
                              style: TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),

                    ]
                ),

                  ),
                ):Container(),
              )
          ,


          Positioned(
              top:  MediaQuery.of(context).size.height/3.3,
              //right: 30,
              child:sessions.length != 0 ? Container(
                  width:  MediaQuery.of(context).size.width,
                  child:SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:Row (
                          children:[

                            for (int i = 0; i < sessions.length; i++)
                              InkWell(
                                onTap:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  Session(
                                          analytics: analytics,
                                          observer: observer,
                                          data: sessions[i]
                                      ),
                                    ),
                                  );
                                },
                                child:  Container(
                                  width: MediaQuery.of(context).size.height/5.5,
                                  height: MediaQuery.of(context).size.height/5.5,
                                  //padding: EdgeInsets.only(left: 25),
                                  margin: EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0xffffffff),
                                    image: DecorationImage(
                                        image: NetworkImage(sessions[i]['topicPhoto']),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.bottomCenter
                                    ),
                                  ),
                              )
                            ),

                          ]
                      )
                  )
              ):  show ?
              Container(height: 60,width: MediaQuery.of(context).size.width ,child: Center(child: CircularProgressIndicator(backgroundColor: Colors.transparent,color: Colors.white60,),),)
                  :
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text("ไม่สามารถเชื่อมต่ออินเตอร์เน็ตได้\nไปที่โปรไฟล์เพื่อฟังออฟไลน์",textScaleFactor: 1.8,textAlign: TextAlign.center,),
              )
          ),


          Positioned(
              top:  MediaQuery.of(context).size.height/1.8,
              //right: 30,
              child: (online.length != 0 && makha.length != 0) ? InkWell(
                  onTap:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  Social(analytics: analytics,
                          observer: observer,online: online,tomakha: makha,data: mettas,myuser: user,),
                      ),
                    );
                  },
                  child: Container(
                    width:  MediaQuery.of(context).size.width,
                    child:Text(
                      '- ${isLang ? "ดูผู้คนที่เข้ามาใช้" : "See people coming in"} -',
                      textScaleFactor: 1.4,
                      style: TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    )
                ),
              ) : Container()
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


          /*  Transform.translate(
            offset: Offset(0.0, 292.0),
            child:
                // Adobe XD layer: 'bottom3' (shape)
          Container(
              width: 375.0,
              height: 375.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/intro/botton.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Adobe XD layer: 'top' (shape)
          Container(
            width: 375.0,
            height: 375.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/intro/top.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(296.0, 17.0),
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(17.0, 228.0),
            child: Container(
              width: 127.0,
              height: 127.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(159.0, 228.0),
            child: Container(
              width: 126.0,
              height: 127.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(300.0, 228.0),
            child: Container(
              width: 126.0,
              height: 127.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(104.0, 394.0),
            child: Text(
              '- ดูผู้คนที่เข้ามาใช้แอป -',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(113.0, 77.0),
            child: Text(
              'สวัสดียามเช้า',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 30,
                color: const Color(0xffffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(107.0, 117.0),
            child: Text(
              'ราตรีไม่รีรอ ให้คิดใหม่',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xccffffff),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(22.0, 184.0),
            child: Container(
              width: 123.0,
              height: 29.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19.0),
                color: const Color(0xff6d9f9a),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(40.0, 187.0),
            child: Text(
              'ทำใจให้สบาย',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),*/
        ],
      ),
    );
  }



  showPopupIntro(BuildContext context, Widget widget, String title,
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

            resizeToAvoidBottomInset:false,
            backgroundColor: Colors.white.withOpacity(0.8),
            body: widget,
          ),
        ),
      ),
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










List<String> Ques = [
  'อดทน และรอคอยได้โดยไม่รู้เหนื่อย',
  'แสดงอารมณ์สนุกหรือร่วมสนุกตามไปกับสิ่งท่ีเห็น\nเช่น ร้องเพลง กระโดดโลดเต้น หัวเราะเฮฮา',
  'ไม่กลัวเมื่อต้องอยู่กับคนที่ไม่สนิทสนม',
  'รู้ตัวได้เร็วเมื่อเริ่มเครียด',
  'ภูมิใจในตนเอง',
  'สามารถควบคุมความคิดได้ดี',
  'มีสติ รู้ตัวเองว่ามีอารมณ์อย่างไรเสมอ',
  'มีเวลาพักผ่อนเพียงพอ',

  'สามารถแบ่งปันสิ่งของให้คนอื่นๆ\nเช่น ขนม ของเล่น',
  'จะบอกขอโทษหรือแสดงท่าทียอมรับผิดทันที\nเมื่อรู้ว่าทําผิด',
  'เมื่อไม่ได้สิ่งที่อยากได้ก็สามารถใช้สิ่งอื่นแทนได้',
  'สามารถแสดงความภาคภูมิใจ\nเมื่อได้รับคําชมเชยได้อย่างไม่ลังเล เช่น บอกเล่าให้ผู้อื่นรู้',
  'สามารถเปิดเผยความทุกข์ใจ\nกับกลุ่มเพื่อนได้เสมอ',
  'จะบอกคนอื่นเวลาฉันต้องการอะไร\nได้อย่างนุ่มนวล',
  'ให้อภัยคนอื่นได้เสมอ',
  'ยินดีเมื่อมีคนเตือนฉัน',


  'รู้สึกเห็นใจเมื่อเห็นเพื่อนหรือผู้อื่นทุกข์ร้อน\nอยากเข้าไปปลอบหรือเข้าไปช่วย',
  'อยากรู้อยากเห็นกับอะไรใหม่หรือสิ่งแปลกใหม่',
  'สนใจ รู้สึกสนุกกับงานหรือกิจกรรมใหม่ๆ',
  'รู้จักหาของเล่น หรือกิจกรรม\nเพื่อสร้างความสนุกสนานเพลิดเพลินเป็น',
  'มองปัญหาเป็นเรื่องท้าทาย',
  'ควบคุมอารมณ์วิตกกังวลของตนเองได้',
  'ทำให้งานเครียดเป็นงานสนุกได้',
  'มีงานอดิเรกยามว่างสม่ำเสมอ',


  'ยอมรับกฎเกณฑ์หรือข้อตกลง\nแม้จะผิดหวังไม่ได้สิ่งที่ต้องการ',
  'มองโลกในแง่ดีได้เสมอ',
  'มีเพลงโปรดฟังแล้วคลายเครียด',
  'หยุดการกระทําที่ไม่ดีเมื่อผู้ใหญ่ห้าม',
  'จัดสิ่งแวดล้อมรอบตัวให้น่ารื่นรมย์เสมอ',
  'ปฏิบัติตัวอยู่ในกฎเกณฑ์ของสังคม\nได้อย่างสบายใจ ',
  'เป็นคนปรับตัวเก่ง',
  'สร้างแรงจูงใจให้ทำในสิ่งน่าเบื่อได้',

];
List<String> StartQues = [
  'คุณใช่คนที่',
  'คุณเป็นคน',
  'คุณคือคน',
  'เธอคือคน',
  'คิดว่าคุณเป็นคน',
  'ท่านเป็นคน',
  'เธอใช่คนที่',
];
List<String> EndQues = [
  'ใช่หรือไม่?',
  'ใช่หรือเปล่า?',
  'ใช่ไหม!?',
  'จริงไหม?',
  'ใช่หรือไม่ค่ะ?',
  'ใช่หรือไม่ครับ?',
  'ใช่หรือเปล่าครับ?',
  'ใช่หรือเปล่าค่ะ?',
];

class QuesDay extends StatefulWidget{
  QuesDay({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _QuesDayState createState() => _QuesDayState(user);
}


class _QuesDayState extends State<QuesDay> {
  _QuesDayState( this.user) ;
  final User user;
  String Question="";
  String StartQuestion="";
  String EndQuestion="";

  T getRandomElement<T>(List<T> list) {
    final random = new Random();
    var i = random.nextInt(list.length);
    return list[i];
  }

  makePostJai(String question,String emotion) async {
    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/aijai';
    //print(uri);
    var responsenew = await Dio().post(uri,
      data:  {
        'question': Question,
        'emotion': emotion,
        'sex':user.sex,
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    //print(responsenew.toString());
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    Question = getRandomElement(Ques);
    StartQuestion = getRandomElement(StartQues);
    EndQuestion = getRandomElement(EndQues);
  }



  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width,),
        Spacer(),
        Text(
          'ทบทวนตนเองก่อนนั่งสมาธิ',
          style: TextStyle(
            color: Colors.black54,
          ),
          textScaleFactor: 1.8,
          //textAlign: TextAlign.left,
        ),
        Spacer(),
        Text("${StartQuestion}",textScaleFactor: 2.4,style: TextStyle(color: Colors.black87,fontStyle: FontStyle.italic),),
        Text(
          '${Question}',
          style: TextStyle(
            color: Colors.black87,
          ),
          textScaleFactor: 2.8,
          textAlign: TextAlign.center,
        ),
        Text("${EndQuestion}",textScaleFactor: 2.2,style: TextStyle(color: Colors.black54,fontStyle: FontStyle.italic),),
        Spacer(),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10,),
              InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    makePostJai(Question,"0");
                    Navigator.pop(context);

                  },
                  child:Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,)
              ),
              //SizedBox(width: 10,),
              InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async{

                    makePostJai(Question,"1");
                    Navigator.pop(context);


                  },
                  child:Image(image: AssetImage("assets/emotion/openhappy.png"),width: 40,height: 40,)),
              InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async{

                    makePostJai(Question,"2");

                    Navigator.pop(context);

                  },
                  child:Image(image: AssetImage("assets/emotion/smile.png"),width: 40,height: 40,)),
//                                  SizedBox(width: 10,),
              InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {

                    makePostJai(Question,"3");
                    Navigator.pop(context);

                  },
                  child:Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,)),
              //                                SizedBox(width: 10,),
              InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async{

                    makePostJai(Question,"4");
                    Navigator.pop(context);

                  },
                  child:Image(image: AssetImage("assets/emotion/opensad.png"),width: 40,height: 40,)),
              SizedBox(width: 10,),

            ]
        ),
        Spacer(),
        Spacer(),
        Spacer(),
        Spacer(),


      ],
    );
  }
}









