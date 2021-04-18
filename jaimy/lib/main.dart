import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:JaiMy/pages/Home.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/widgets.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:JaiMy/constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';

const debug = true;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug);
// Importing 'package:flutter/widgets.dart' is required.
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //print(notification.audioId);
    return true;
  });
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  static const String _title = 'Flutter Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: MyStatefulWidget(
        analytics: analytics,
        observer: observer,
      ),
      theme: ThemeData(fontFamily: 'FCLamoon'),
      navigatorObservers: <NavigatorObserver>[observer],
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => MyStatefulWidget(),
//   '/topic': (BuildContext context) => TopicData(),
      },
    );
  }







}



class MyStatefulWidget extends StatefulWidget{
  MyStatefulWidget({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(analytics, observer);
}

class SessionData {
  final int id;
  final String token;
  final String messageId;

  SessionData({this.token, this.id, this.messageId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["token"] = this.token;
    data["messageId"] = this.messageId;
    return data;
  }
}
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  _MyStatefulWidgetState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  String dataShow = '92';


  List<Color> colorSun = [Color(0xffB6D4ED),Color(0xff6588B6)];
  List<Color> colorMoon = [Color(0xffB6D4ED),Color(0xff6588B6)];

  void initState()  {
    super.initState();
    Future(() {
      _someMethod(context);
      _sendAnalyticsEvent();

    });
    getHome().then((value) => setState(() {
      data = value;
    })
    );
  }
  var data;
  Future getHome() async {
    //List<Online> onlines = [];
    Dio dio = new Dio();
    var response = await dio.get('https://05hx8i6qja.execute-api.us-east-1.amazonaws.com/dev/home');
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
  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_page',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
    //print('@@@@@@@@@@@@logEvent succeeded@@@@@@@@@@@@@@@@@@@@@');
  }
  Future<void> _someMethod(context) async {
    await FlutterSession().get("token").then((val) async {
      if(val == 0 || val == null || val.isNaN){
        _firebaseMessaging.getToken().then((String token) async {
          assert(token != null);
          print("Push Messaging token: $token");
          SessionData myData = SessionData(token:"5f7c88bb619${new DateTime.now().millisecondsSinceEpoch.toString()}", id: 1, messageId: token);
          await FlutterSession().set('token', myData);
          showPopupIntro(context, IntroShow(), '');
        });

      }else if(val['messageId']  == 0 || val['messageId'] == null || val['messageId'].isNaN){
        _firebaseMessaging.getToken().then((String token) async{
          assert(token != null);
          print("Push Messaging token: $token");
          SessionData myData = SessionData(token:val['token'], id: val['id'], messageId: token);
          await FlutterSession().set('token', myData);
        });
      }
    })
        .catchError((error, stackTrace) {
// error is SecondError
      print("outer: $error");
    });

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



  @override
  Widget build(BuildContext context) {
    return  Home(
          analytics: analytics,
          observer: observer,
          data: data,
          colors: (DateTime.now().hour < 13 && DateTime.now().hour > 9) ? colorSun : colorMoon,
        );
  }
}





class IntroShow extends StatefulWidget{
  IntroShow({Key key}) : super(key: key);

  @override
  _IntroShowState createState() => _IntroShowState();
}

class _IntroShowState extends State<IntroShow> {


  makePostStart(String answer) async {
    final uri = 'https://lk5206ivth.execute-api.us-east-1.amazonaws.com/dev/aistart';
    //print(uri);
    var responsenew = await Dio().post(uri,
      data:  {
        'answer': answer,
        'time': new DateTime.now().millisecondsSinceEpoch,
      },
      options:  Options(contentType:Headers.formUrlEncodedContentType),
    );
    //print(responsenew.toString());
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return  Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:  Column(
                children: [
                  Spacer(),
                  Spacer(),
                  Text("คุณคิดอะไรอยู่?",textScaleFactor: 2.8,),
                  Text("เลือกบางอย่างสำหรับคุณตอนนี้",textScaleFactor: 2.0,),
                  //SizedBox(height: (MediaQuery.of(context).size.height-40)/5,),
                  Spacer(),


                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        makePostStart("ผ่อนคลายใจ ลดความเครียด");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 2.0,color:const Color(0xcc1c2637).withOpacity(0.4) )
                        ),
                        child: Text(
                          'ผ่อนคลายใจ ลดความเครียด',
                          textScaleFactor: 1.6,
                          style: TextStyle(
                            color: const Color(0xff1c2637),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),




                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        makePostStart("การหลับด้วยเสียงที่ฟัง");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 2.0,color:const Color(0xcc1c2637).withOpacity(0.4) )
                        ),
                        child: Text(
                          'การหลับด้วยเสียงที่ฟัง',
                          textScaleFactor: 1.6,
                          style: TextStyle(
                            color: const Color(0xff1c2637),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),




                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        makePostStart("ดูแลใจ ให้อารมณ์คงที่");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 2.0,color:const Color(0xcc1c2637).withOpacity(0.4) )
                        ),
                        child: Text(
                          'ดูแลใจ ให้อารมณ์คงที่',
                          textScaleFactor: 1.6,
                          style: TextStyle(
                            color: const Color(0xff1c2637),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),


                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        makePostStart("ใฝ่หาความสงบทางใจ");
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffffffff),
                            border: Border.all(width: 2.0,color:const Color(0xcc1c2637).withOpacity(0.4) )
                        ),
                        child: Text(
                          'ใฝ่หาความสงบทางใจ',
                          textScaleFactor: 1.6,
                          style: TextStyle(
                            color: const Color(0xff1c2637),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                  Spacer(),

                  Text("- ยินดีต้อนรับสู่ JaiMy -",textScaleFactor: 1.6,),
                  Spacer(),
                  Spacer(),
                  Spacer(),



                ]
            )

    );
  }

}








///
///
///
/// Know Chart START
///
///
class KnowChart extends StatelessWidget {
  final List<Knows> data;

  KnowChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Knows, String>> series = [
      charts.Series(
        id: "Knows",
        data: this.data,
        domainFn: (Knows series, _) => series.day,
        measureFn: (Knows series, _) => series.know,
        colorFn: (_, __) => charts.MaterialPalette.white,
      )
    ];
    return Container(
      height: 200,
      padding: EdgeInsets.all(0),
      child:Column(
        children: <Widget>[
          Text(
            "สติแต่ละวัน",
            style: TextStyle(color: Colors.white),

          ),
          Expanded(
            child: charts.BarChart(series, animate: true ,
              primaryMeasureAxis:
              charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
              defaultRenderer: charts.BarRendererConfig(cornerStrategy: const charts.ConstCornerStrategy(30)),

              domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                      minimumPaddingBetweenLabelsPx: 0,
//labelAnchor: charts.TickLabelAnchor.centered,
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 10,
                        color: charts.MaterialPalette.white,
                      ),
//labelRotation: 60,
// Change the line colors to match text color.
                      lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.white))),
// It is recommended that default interactions be turned off if using bar
// renderer, because the line point highlighter is the default for time
// series chart.
            ),
          )
        ],
      ),


    );
  }
}


///
///
///
/// Relex Chart START
///
///
///
///
/*
class Relexs {
  final int id;
  final DateTime time;
  final int relex;

  Relexs(this.id, this.time, this.relex);
}*/


class RelexChart extends StatelessWidget {
  final List<Relexs> data;

  RelexChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Relexs, String>> series = [
      charts.Series(
        id: "Knows",
        data: this.data,
        domainFn: (Relexs series, _) => series.day,
        measureFn: (Relexs series, _) => series.relex,
        colorFn: (_, __) => charts.MaterialPalette.white,
      )
    ];
    return Container(
      height: 200,
      padding: EdgeInsets.all(0),
      child:Column(
        children: <Widget>[
          Text(
            "สบายแต่ละวัน",
            style: TextStyle(color: Colors.white),

          ),
          Expanded(
            child: charts.BarChart(series, animate: true ,
              primaryMeasureAxis:
              charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
              defaultRenderer: charts.BarRendererConfig(cornerStrategy: const charts.ConstCornerStrategy(30)),

              domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                      minimumPaddingBetweenLabelsPx: 0,
//labelAnchor: charts.TickLabelAnchor.centered,
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 10,
                        color: charts.MaterialPalette.white,
                      ),
//labelRotation: 60,
// Change the line colors to match text color.
                      lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.white))),
// It is recommended that default interactions be turned off if using bar
// renderer, because the line point highlighter is the default for time
// series chart.
            ),
          )
        ],
      ),


    );
  }
}








class SaveAwake extends StatefulWidget {
  final int recordObject;

  SaveAwake({Key key, @required this.recordObject}) : super(key: key);

  @override
  _SaveAwakeState createState() => new _SaveAwakeState();
}

class _SaveAwakeState extends State<SaveAwake> {
  List<Awake> awakes;
  int intKnow=0;
  int intRelex=4;
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
  void initState()  {
    super.initState();
    dataShow='Save';
    datebaseHelper.getUser(1).then((result) {
      user=result;
      setState(() {});
    });
    datebaseHelper.awakes().then((result) {
      awakes=result;
      setState(() {});
    });
  }
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
  @override
  Widget build(BuildContext context) {
//…..
//widget.recordObject
    return RaisedButton(
        child: Text(
          'SAVE DATA',
          textScaleFactor: 1.5,
        ),
        onPressed: () async {
          dataShow='SUCCESS';

          user=await datebaseHelper.getUser(1);
          int savewave = (intRelex*7)*(intKnow*5);
          savewave is int;
          savewave is double;
          int c;
          c = savewave ~/ 100;
          await datebaseHelper.insertWave(
              Wave(time: new DateTime.now().millisecondsSinceEpoch, wave:c+(intRelex*7))
          );
          await datebaseHelper.insertKnow(
              Know(know:intKnow)
          );
          await datebaseHelper.insertRelex(
              Relex(time: new DateTime.now().millisecondsSinceEpoch, relex:intRelex)
          );
          await datebaseHelper.insertAwake(Awake(
            intKnow: intKnow,
            intRelex: intRelex,
            time: new DateTime.now().millisecondsSinceEpoch,
          ));
          await datebaseHelper.updateUser(User(
            id: 1,
            name: user.name,
            profile: user.profile,
            sex: user.sex,
            age: user.age,
            intExp: user.intExp+15,
            intMinute: user.intMinute,
            intListen: user.intListen,
            intKnow: intKnow,
            intRelex: intRelex,
            intWave: user.intWave,
            intMeditate: user.intMeditate+(c+(intRelex*7)~/1.5),
            intLesson: user.intLesson,
            intEmotion: user.intEmotion,
          ));
          //print(user.name);

//dataShow=user.name;
//awakes=await datebaseHelper.awakes();
          setState((){});
/*setState(() async {
          dataShow:await datebaseHelper.users().toString();
        });*/
        }
    );
//…..

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







class awakeShow extends StatelessWidget {
//final Reward data;

//rankShow({@required this.data});
  List<String> textRank = [
    'ลูกนกในไข่',
    'นกเตรียมฟัก',
    'นกออกจากไข่',
    'นกเจริญเติบโต',
    'นกหัดบิน',
    'นกบินได้',
    'นกโผบินอย่างสงบสุข'
  ];
  List<int> intRank = [0,1,2,3,4,5,6];
  List<String> detailRank = [
    'ผู้ที่เพิ่งเริ่มนั่งสมาธิได้ไม่นาน ก็เปรียบเสมือนลูกนกที่อยู่ในไข่ เมื่อผ่านวันเวลาที่เหมาะสมก็จะพบความสุขที่แท้จริงได้',
    'ผู้ที่กำลังค้นหาความสุขที่แท้จริงแล้ว แต่จำเป็นต้องรอเวลาที่ใจตกตะกอนกว่านี้อยู่ เหมือนนกที่เตรียมจะฟักจากไข่',
    'ผู้ที่พบความสุขจากสมาธิแล้วในระดับที่พอประคับประคองตนเองได้ เปรียบเหมือนนกที่ออกจากไข่แต่ยังจำเป็นเรียนรู้อีกอยู่',
    'ผู้ที่พบความสุขที่แท้จริงแล้ว แต่กำลังเรียนรู้อาหารและปัจจัยที่เกื้อหนุนต่อความบริสุทธิ์ของใจ',
    'ผู้ที่เข้าถึงความสุขภายใน เริ่มที่จะเป็นอิสระจากเครื่องกังวล เครื่องพันธนาการที่ยึดเหนี่ยวจิตใจไว้',
    'ผู้ที่เข้าถึงความสุขอย่างชำนาญ อย่างเชี่ยวชาญ พร้อมที่จะบินและแสวงหาความสุขได้ด้วยตนเองเป็นอิสระจากโลก',
    'ผู้ที่เชี่ยวชาญกับมีการนั่งสมาธิเป็นชีวิตจิตใจ เป็นผู้มีความสุขภายในตัว สงัดและปลอดจากความทุกข์ทั้งปวง',
  ];
  List<int> intKnow = [0,1,2,3,4,5];
  List<String> textKnow = [
    'หลับลึก',
    'กึ่งหลับ กึ่งตื่น',
    'เรื่อยๆ',
    'นิ่งไม่ฟุ้งซ่าน',
    'ไม่ลังเล ไม่สงสัย',
    'สงบตั้งมั่น'
  ];
  List<int> intRelex = [0,1,2,3,4,5,6,7,8,9,10];
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

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
//title: Text(''),
            backgroundColor: ThemeNew,

//backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
          ),
//backgroundColor: ThemeNew6,
          body:SingleChildScrollView(
//scrollDirection: Axis.horizontal,

            child: Column(
              children: <Widget>[
                SizedBox(height: 30,),

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0,21),
                              blurRadius: 53,
                              color: Colors.black.withOpacity(0.05)
                          )
                        ]
                    ),
                    child:Column(
                      children: <Widget>[
                        Text("สติ คือ การตื่นตัวภายใน",style: TextStyle(fontSize: 18),),
                        Text("มีทั้งหมด 6 ขั้น",style: TextStyle(color: Colors.black45),),
                      ],
                    )
                ),


                for ( var i in intKnow )

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),

                        Image(image: AssetImage('assets/know/${i}.png'),width: 100,height: 100,),
                        SizedBox(height: 5,),
//Text(textRank[i]),
                        Text(
                          textKnow[i],
                          style: TextStyle(fontSize: 16
//,fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5,),
/* Text(
                      detailRank[i],
                      style: TextStyle(fontSize: 14,color: Colors.black87,),
                    ),
                    SizedBox(height: 20,),*/
                      ],
                    ),

                  ),



                SizedBox(height: 100,),

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0,21),
                              blurRadius: 53,
                              color: Colors.black.withOpacity(0.05)
                          )
                        ]
                    ),
                    child:Column(
                      children: <Widget>[
                        Text("สบาย คือ สุขขั้นแรก",style: TextStyle(fontSize: 18),),
                        Text("มีทั้งหมด 11 ขั้น",style: TextStyle(color: Colors.black45),),
                      ],
                    )
                ),


                for ( var i in intRelex )

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),

                        Image(image: AssetImage('assets/relex/${i}.png'),width: 100,height: 100,),
                        SizedBox(height: 5,),
//Text(textRank[i]),
                        Text(
                          textRelex[i],
                          style: TextStyle(fontSize: 16
//,fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 5,),
/* Text(
                      detailRank[i],
                      style: TextStyle(fontSize: 14,color: Colors.black87,),
                    ),
                    SizedBox(height: 20,),*/
                      ],
                    ),

                  )
              ],
            ),
          ));
  }
}