import 'package:JaiMy/models/Alerts.dart';
import 'package:JaiMy/models/liker.dart';
import 'package:JaiMy/pages/DoJai.dart';
import 'package:JaiMy/pages/Home.dart';
import 'package:JaiMy/pages/Other.dart';
import 'package:JaiMy/pages/edit/EditProfile.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../main.dart';
import 'AlertPage.dart';
import 'ListJai.dart';
import 'Post.dart';
import 'edit/EditDetail.dart';



List<String> th_Profile = [
  "นาที",
  "ดูแลใจ",
  "ถูกใจ",
  "ดูแลใจ",
  "บันทึกอารมณ์",
  "เปลี่ยนภาพโปรไฟล์",
  "เปลี่ยนชื่อของคุณ",
  "ตกลง",
  "แก้ไขรายละเอียด",
  "บันทึกอารมณ์",
  "เสียงที่ชอบ",
  "ฟังออฟไลน์",
  "ประวัติการฟัง",
  "ตอนนี้...คุณมี\nความสุขจากสมาธิหรือเปล่า?",
  "วัดความสุขจากสมาธิของคุณ - ",
  "ล่าสุด",
  "วัดความโกรธ",
  "ความโกรธ",
  "วัดความเหงา",
  "ความเหงา",
  "วัดความสดใส",
  "ความสดใส",
  "วัดความหลงรัก",
  "ความหลงรัก",
  "วัดความน้อยเนื้อต่ำใจ",
  "ความน้อยเนื้อต่ำใจ",
  "วัดความกล้า",
  "ความกล้า",
  "วัดความเชื่อมั่น",
  "ความเชื่อมั่น",
  "วัดความเป็นกันเอง",
  "ความเป็นกันเอง",
  "ยังไม่มีการแจ้งเตือน"
];






List<String> en_Profile = [
  "Min",
  "Mindful",
  "Likes",
  "check mindful status"
  //"check your mindful status",
  "journaling",
  "change your profile",
  "change your name",
  "Done",
  "chage your detail",
  "journaling",
  "Sound like",
  "Listen offline",
  "Listening history",
  "Now...Do you\nhave the joy of meditation?",
  "Measure happiness from your meditation - ",
  "latest",
  "Measure anger",
  "Anger",
  "Measure sad",
  "sad",
  "Measure happy",
  "happy",
  "Measure love",
  "love",
  "Measure jealousy",
  "Jealousy",
  "Measure guts",
  "guts",
  "Measure confidence",
  "Confidence",
  "Measure frankness",
  "Frankness",
  "No notification yet"
];

class Me extends StatefulWidget{
  Me({Key key, this.analytics, this.observer,this.text_profile, this.data}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final text_profile;
  final data;
  @override
  _MeState createState() => _MeState(analytics, observer,DateTime.now().timeZoneName == "+07"  ? th_Profile : en_Profile, data);
}


class _MeState extends State<Me> {
  _MeState(this.analytics, this.observer, this.text_profile,this.data);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final text_profile;
  final data;
  bool isPlaynow = true;
  static DataApr DatabaseApr = DataApr();
  List<Post> posts = [];
  List<HisJai> jais = [];
  int sumJai = 0;
  int sumLiked = 0;
  String detail = "";
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  List<Alerts> alerts = [];
  bool exsitAlert = false;
  List<Liker> likers = [];

  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
    });
    DatabaseApr.posts().then((value) => setState((){posts = value;print(value);}));
    DatabaseApr.historyJais().then((value) => setState((){jais = value;print(value);}));
    DatabaseApr.sumHisJai().then((value) { setState((){sumJai = value;});print(value);});
    FlutterSession().get("user_detail").then((val){  setState((){  detail = val == null ? "..." : val;});print(val);  });
    datebaseHelper.getUser(1).then((result) {
      //String todata = utf8.decode(data);
      user = result;
      setState(() {});
    });


    FlutterSession().get("token").then((val) async {

      FirebaseFirestore.instance.collection('alerts')
          .where('alertUserId', isEqualTo: val['token'])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          alerts.add(Alerts(
            alertUserId: doc["alertUserId"],
            alertPhoto: doc["alertPhoto"],
            alertName: doc["alertName"],
            alertDetail:doc["alertDetail"] ,
            alertTime:doc["alertTime"] ,
          ));
          print(doc["alertName"]);
        });
        setState(() {});
        FlutterSession().get("exsitAlert").then((val) async {
          print(val);
          print(alerts.length);
          if(alerts.length > 0){
            if(val != alerts.length){
              exsitAlert = true;
              setState(() {});
            }else{
              await FlutterSession().set('exsitAlert', alerts.length);
            }
          }
        });
      });
    });

    FlutterSession().get("token").then((val) async {
      FirebaseFirestore.instance
          .collection('liker')
          .where('likeId', isEqualTo: val['token'] )
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          likers.add(Liker(
              likeId: doc["likeId"],
              userId: doc["userId"]
          ));
          print(doc["likeId"]);
        });
        sumLiked = likers.length;
        setState(() {});
      });
    });

  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_ProfileMe',
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



  List<String> jai = [
    "assets/emotion/happy.png",
    "assets/emotion/flirt.png",
    "assets/emotion/sad.png",
    "assets/emotion/straight.png"
  ];



  List<String> jaiText = [
    "แฮปปี",
    "พอใจ",
    "เซง",
    "เฉยเมย"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
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
                            child: Icon(Icons.close,color: Colors.black54,),
                            onPressed: () {

                             // Navigator.pop(context);
                              Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:MyStatefulWidget()), (Route<dynamic> route) => false);

                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Icon(exsitAlert ? Icons.notification_important : Icons.notifications,color: exsitAlert ? Colors.redAccent : Colors.black54,size: 30,),
                            onPressed: () {
                              if(exsitAlert){
                                FlutterSession().set('exsitAlert', alerts.length);
                                setState(() {
                                  exsitAlert = false;
                                });
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  AlertPage(text_profile: text_profile,alerts: alerts,),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  EditProfile(profile: user.profile,sex: user.sex,text_profile:text_profile),
                            ),
                          );
                        },
                        child: Container(
                          width: 118.0,
                          height: 118.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: user.profile == 'NewProfile'  ? AssetImage("assets/sex/${user.sex}.png") : user.profile != ''  ? NetworkImage(user.profile) : AssetImage("assets/sex/${user.sex}.png")
                              ),
                            border: Border.all(width: 3.0, color: const Color(0xffffffff)),
                          ),
                        ),
                      ),

                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          showPopupSave(context, editName(text_profile: text_profile,), 'คุณชื่ออะไร');
                        },
                        child:Text(
                          '${user.name}',
                          textScaleFactor: 2.0,
                          style: TextStyle(
                            color:  Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                        ) ,
                      ),


                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  EditDetail(detail: detail,text_profile: text_profile,),
                            ),
                          );
                        },
                        child:Container(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4.5,vertical: 10),
                          child: Text(
                            "${detail}",
                            textScaleFactor: 1.4,
                            style: TextStyle(color: Colors.black26,height: 1.0),
                            textAlign: TextAlign.center,
                          ),
                        ) ,
                      ),
                      SizedBox(height: 10,),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            width: 2,
                            height: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${user.intMinute}',
                                textScaleFactor: 2.4,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${text_profile[0]}',
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ListJai(jais: jais),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${sumJai}',
                                  textScaleFactor: 2.4,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '${text_profile[1]}',
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${sumLiked}',
                                textScaleFactor: 2.4,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${text_profile[2]}',
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 30,
                          ),
                        ],
                      ),


                      SizedBox(height: 40,),
                      Row(
                        children: [
                          Spacer(),
                          if(DateTime.now().timeZoneName == "+07") InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  DoJai(text_profile: text_profile,data:data),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xff1c2637),
                              ),
                              child: Text(
                                '${text_profile[3]}',
                                textScaleFactor: 1.6,
                                style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          if(DateTime.now().timeZoneName == "+07") SizedBox(width: 10,),
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  PostPage(analytics: analytics,
                                      observer: observer,text_profile: text_profile,),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xffffffff),
                                  border: Border.all(width: 1.0,color:const Color(0xcc1c2637) )
                                ),
                                child: Text(
                                  '${text_profile[4]}',
                                  textScaleFactor: 1.6,
                                  style: TextStyle(
                                    color: const Color(0xff1c2637),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )),
                          SizedBox(width: 10,),
                          InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  Other(analytics: analytics,
                                      observer: observer,text_profile: text_profile,),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xffffffff),
                                    border: Border.all(width: 1.0,color:const Color(0xcc1c2637) )
                                ),
                                child:  Text(
                                  '…',
                                  textScaleFactor: 1.6,
                                  style: TextStyle(
                                    color: const Color(0xff1c2637),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                          Spacer(),

                        ],
                      ),

                      SizedBox(height: 40,),
                      Column(
                        children: [
                          for (var i = 0; i < posts.length; i++)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                             // borderRadius: BorderRadius.circular(22.0),
                              color: const Color(0xffffffff),
                              border: Border(
                                bottom: BorderSide(width: 0.5, color:  Colors.black12),
                              ),
                            ),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[
                                  SizedBox(width: MediaQuery.of(context).size.width-80,),
                                  Text(
                                    '${timeTodate(posts[i].postTime)}',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                      color: const Color(0xff5a7fb2),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),

                                  Text(
                                    '${posts[i].post}',
                                    textScaleFactor: 2.0,
                                    style: TextStyle(
                                      color: const Color(0xff000000),
                                      height: 1.25,
                                    ),
                                    textHeightBehavior:
                                    TextHeightBehavior(applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Image(image: AssetImage("${jai[posts[i].postEmotion]}"),width: 25,height: 25,),
                                      SizedBox(width: 15,),
                                      Text(
                                        "${jaiText[posts[i].postEmotion]}",
                                        textScaleFactor: 1.4,
                                        style: TextStyle(
                                          color: const Color(0xcc000000),
                                        ),
                                      ),
                                    ],
                                  )



                                ]
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
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
          ),



        ],
      ),
    );



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





class editName extends StatefulWidget {
  //final User touser;
  // final int minute;
  editName({Key key ,@required this.text_profile}) : super(key: key);
  //final int saveBoon;
  //editShow({Key key, @required this.touser}) : super(key: key);
  final text_profile;
  @override
  editNameState createState() => editNameState();
}

class editNameState extends State<editName> {




  @override
  void initState() {
    super.initState();




    datebaseHelper.getUser(1).then((result) async {
      user = result;
      name = result.name;
      setState(() {});
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
  String name = '';
  static DatabaseHelper datebaseHelper = DatabaseHelper();

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
              /* Image(image: AssetImage('assets/sex/sit_${user.sex}.png'),width: MediaQuery
                  .of(context)
                  .size
                  .width/4,height: MediaQuery
                  .of(context)
                  .size
                  .width/4,),*/
              Text("${widget.text_profile[6]}",textScaleFactor: 1.4,style: TextStyle(color:Color(0xff1c2637)),),
              SizedBox(height: 10,),
              TextField(
                //showCursor: true,
                autofocus: true,
                readOnly: false,
                //cursorColor: ThemeNew,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: name,
                  filled: true,
                  fillColor: Colors.black12,
                  // fillColor: ThemeNew,
                  // hoverColor: ThemeNew,
                  // focusColor: ThemeNew
                ),
                style: TextStyle(fontSize: 20),
                onChanged: (text) {
                  setState((){
                    name=text;
                  });
                  print("First text field: $text");
                },
              ),
              //Text("วันนี้คุณนั่งไปแล้ว ${widget.sessionMakha.intDay+widget.minute} นาที",textScaleFactor: 1.0,style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  await datebaseHelper.updateUser(User(
                    id: 1,
                    name: name == '' ? "New" : name ,
                    profile: user.profile,
                    sex: user.sex,
                    age: user.age,
                    intExp: user.intExp,
                    intMinute: user.intMinute ,
                    intListen: user.intListen ,
                    intKnow: user.intKnow,
                    intRelex: user.intRelex,
                    intWave: user.intWave,
                    intMeditate: user.intMeditate,
                    intLesson: user.intLesson,
                    intEmotion: user.intEmotion,
                  ));
                  Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me(text_profile: widget.text_profile,)), (Route<dynamic> route) => false);

                  //Navigator.pop(context);
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
                      color: Color(0xff1c2637),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,5),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.2)
                        )
                      ]
                  ),
                  child: Text("${widget.text_profile[7]}",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),

                ) ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



