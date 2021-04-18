import 'package:JaiMy/models/liker.dart';
import 'package:JaiMy/player/PositionPlaying.dart';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget{
  ProfilePage({Key key, this.analytics, this.observer, this.user, this.detail, this.intJai, this.time, this.userId ,this.tokenId, this.myuser}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final User user;
  final String detail;
  final int intJai;
  final int time;
  final String userId;
  final String tokenId;
  final User myuser;
  @override
  _ProfilePageState createState() => _ProfilePageState(analytics, observer);
}


class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState(this.analytics, this.observer );
  static DataApr DatabaseApr = DataApr();
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  CollectionReference liker = FirebaseFirestore.instance.collection('liker');
  CollectionReference alerts = FirebaseFirestore.instance.collection('alerts');
  bool isPlaynow = true;
  List<Post> posts = [];
  List<HisJai> jais = [];
  int sumJai = 0;
  int sumLiked = 0;
  int time = 0;
  String detail = "";
  var data = [];
  bool isLike = false;
  List<Liker> likers = [];

  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
      if(widget.userId != "" && widget.userId != 0 && widget.userId != null){
        DatabaseApr.isLiked().then((value) => setState((){
          isLike = value.any((friend) => friend.id == widget.userId);
        }));
        FirebaseFirestore.instance
            .collection('journaling')
            .where('userId', isEqualTo: widget.userId )
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            posts.add(Post(
                post: doc["post"],
                postPhoto: doc["postPhoto"],
                postEmotion: doc["postEmotion"],
                postTime: doc['postTime']
            ));
            print(doc["post"]);
          });
          posts =  posts.reversed.toList();
          setState(() {});
        });
        FirebaseFirestore.instance
            .collection('liker')
            .where('likeId', isEqualTo: widget.userId )
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
      }

    });
    setState(() {
      user = widget.user;
      sumJai = widget.intJai;
      detail = widget.detail;
      time = widget.time;
    });


  }






  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("ตกลง"),
      onPressed: () { },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("ไม่สามารถถูกใจผู้ใช้คนนี้ได้",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text("เนื่องจากว่า ผู้ใช้คนนี้ ยังไม่ได้อัพเดทเวอร์ชั่นปัจจุบัน",textScaleFactor: 1.4,),
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


  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Profiles',
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



  static Future<void> sendNotification(String tokenId,String pname,String text, String name)async{

    //  var token = await getToken(receiver);
    // print('token : $token');
    var postUrl = "https://fcm.googleapis.com/fcm/send";

    final data = {
      "notification": {"body": "${pname} กดถูกใจโปรไฟล์ของคุณ", "title": "มีคนถูกใจคุณ"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "/${tokenId}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAn4qcmqA:APA91bEg3OPpHsBMsQzVVAh5JxBbdMN_51PysZ3vsvSi_E1chXAec5aH4DRLEXkU8ijlLakzl_IjKsZBK9GL9zQ5i1AZ3h_XUI_9XaA1vSaNSlvxFrYv7As_91oA_giikh6h2Kv2JPcq'
    };


    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );


    try {
      final response = await Dio(options).post(postUrl,
          data: data);

      if (response.statusCode == 200) {
        print('success to sending notification');
        // Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    }
    catch(e){
      print('exception $e');
    }


  }


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
                            child: Icon(Icons.arrow_back,color: Colors.black54,),
                            onPressed: () {
                              Navigator.pop(context);
                             // Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:MyStatefulWidget()), (Route<dynamic> route) => false);

                            },
                          ),
                          Spacer(),

                        ],
                      ),
                      Container(
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
                      SizedBox(height: 10,),
                      Text(
                          '${user.name}',
                          textScaleFactor: 2.0,
                          style: TextStyle(
                            color:  Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                        ) ,

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4.5,vertical: 10),
                        child: Text(
                          "${detail} - ล่าสุดเมื่อ ${timeTodate(time)}",
                          textScaleFactor: 1.4,
                          style: TextStyle(color: Colors.black26,height: 1.0),
                          textAlign: TextAlign.center,
                        ),
                      ) ,
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
                                'นาที',
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                     Column(
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
                                  'ดูแลใจ',
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black45,
                                  ),
                                )
                              ],
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
                                'ถูกใจ',
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
                          InkWell(
                            onTap: () async {
                              if(widget.userId != "" && widget.userId != 0 && widget.userId != null) {


                                if(!isLike) {
                                  DatabaseApr.likeFriend(LikeFriend(
                                      "${widget.userId}",
                                      new DateTime.now()
                                          .millisecondsSinceEpoch));
                                  await FlutterSession().get("token").then((
                                      val) async {
                                    liker
                                        .add({
                                      'likeId': widget.userId,
                                      'userId': val['token'], // J
                                    })
                                        .then((value) => print("Like Added"))
                                        .catchError((error) =>
                                        print("Failed to add like: $error"));

                                    alerts.add({
                                      'alertUserId': widget.userId,
                                      'alertPhoto':widget.myuser.profile,
                                      'alertName':widget.myuser.name,
                                      'alertDetail':"กดถูกใจโปรไฟล์ของคุณ",
                                      'alertTime':new DateTime.now().millisecondsSinceEpoch

                                    })
                                        .then((value) => print("Alert Added"))
                                        .catchError((error) =>
                                        print("Failed to add alerts: $error"));

                                  });
                                  sumLiked = sumLiked + 1;
                                  isLike = true;
                                  setState(() {});
                                }
                                
                                if(widget.tokenId != null){
                                  sendNotification("${widget.tokenId}","${widget.myuser.name}","กดถูกใจคุณ","");
                                }


                              }else{
                                showAlertDialog(context);
                              }
                            },
                            child: isLike ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xff1c2637),
                              ),
                              child: Text(
                                'ถูกใจแล้ว',
                                textScaleFactor: 1.6,
                                style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ) :  Container(
                              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xffffffff),
                                  border: Border.all(width: 1.0,color:const Color(0xcc1c2637) )
                              ),
                              child: Text(
                                'ถูกใจ',
                                textScaleFactor: 1.6,
                                style: TextStyle(
                                  color: const Color(0xff1c2637),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),

                        ],
                      ),

                      SizedBox(height: 40,),

                      isLike ? Column(
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
                      ) : Text("กดถูกใจเพื่อดูบันทึกอารมณ์ของผู้ใช้คนนี้",textScaleFactor: 2.0,)

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


