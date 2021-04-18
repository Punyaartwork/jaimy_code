import 'package:JaiMy/models/Alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class AlertPage extends StatefulWidget {
  AlertPage({
    Key key,@required this.text_profile,this.alerts
  }) : super(key: key);
  final text_profile;
  final List<Alerts> alerts;


@override
  State<StatefulWidget> createState() => AlertPageState(alerts);
}

class AlertPageState extends State<AlertPage> {
  AlertPageState(this.alerts);
  final List<Alerts> alerts;
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffebf4ff),
        //title: Text(title),
        leading: new Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.black45,),
                iconSize:35,
                onPressed: () {
                  try {
                    Navigator.pop(context); //close the popup
                  } catch (e) {}
                },
              );
            }),
        brightness: Brightness.light,
      ),
      backgroundColor: const Color(0xffebf4ff),
      body:

      alerts.length != 0 ?

      SingleChildScrollView(
          child: Column(
              children: [
                for (var i = 0; i < alerts.length; i++)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(22.0),
                     // color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(width: 0.5, color:  Colors.black12),
                      ),
                    ),
                    child:Row(
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: alerts[i].alertPhoto == 'NewProfile'  ? AssetImage("assets/sex/man.png") : alerts[i].alertPhoto  != ''  ? NetworkImage(alerts[i].alertPhoto) : AssetImage("assets/sex/man.png")
                              )
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(width: MediaQuery.of(context).size.width-140,),
                            Text(
                              '${alerts[i].alertName}',
                              textScaleFactor: 1.4,
                              style: TextStyle(
                                color: const Color(0xff5a7fb2),
                              ),
                              textAlign: TextAlign.left,
                            ),

                            Text(
                              '${alerts[i].alertDetail}',
                              textScaleFactor: 1.8,
                              style: TextStyle(
                                color: const Color(0xff000000),
                                height: 1.25,
                              ),
                              textHeightBehavior:
                              TextHeightBehavior(applyHeightToFirstAscent: false),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${timeTodate(alerts[i].alertTime)}',
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                color: const Color(0xff5a7fb2),
                              ),
                              textAlign: TextAlign.left,
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
              ]
          )
      )

          :Center(
        child: Text("${widget.text_profile[32]}",textScaleFactor: 2.0,style: TextStyle(color:Colors.black45),),
      )





      /*
      Stack(
        children: <Widget>[




          Transform.translate(
            offset: Offset(18.0, 74.0),
            child: Container(
              width: 41.0,
              height: 41.0,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(70.0, 71.0),
            child: Text(
              'ตอนนี้คุณโกรธอยู่หรือเปล่าว?',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xff3e3e3e),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(70.0, 99.0),
            child: Text(
              'วัดอารมณ์โกรธของคุณ - ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xcc3e3e3e),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(291.0, 88.0),
            child: Text(
              '18.00 am.',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: const Color(0xff3e3e3e),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(21.0, 12.0),
            child: Text(
              'กลับ',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: const Color(0xffa3a3a3),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),





        ],
      ),






      */
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


