import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:JaiMy/models/topic.dart';
import 'package:JaiMy/pages/Me.dart';
import 'package:JaiMy/utils/database_apr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/widgets.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../constants.dart';
List<String> mind = [
  'อดทน และรอคอยได้โดยไม่รู้เหนื่อย',
  'แสดงอารมณ์สนุกหรือร่วมสนุกตามไปกับสิ่งท่ีเห็น เช่น ร้องเพลง กระโดดโลดเต้น หัวเราะเฮฮา',
  'ไม่กลัวเมื่อต้องอยู่กับคนที่ไม่สนิทสนม',
  'ฉันรู้ตัวได้เร็วเมื่อเริ่มเครียด',
  'ฉันภูมิใจในตนเอง',
  'ฉันสามารถควบคุมความคิดได้ดี',
  'ฉันมีสติ รู้ตัวเองว่ามีอารมณ์อย่างไรเสมอ',
  'ฉันมีเวลาพักผ่อนเพียงพอ',
];
List<String> persons = [
  'ฉันสามารถแบ่งปันสิ่งของให้คนอื่นๆ เช่น ขนม ของเล่น',
  'ฉันจะบอกขอโทษหรือแสดงท่าทียอมรับผิดทันที เมื่อรู้ว่าทําผิด',
  'เมื่อไม่ได้สิ่งที่อยากได้ก็สามารถใช้สิ่งอื่นแทนได้',
  'ฉันสามารถแสดงความภาคภูมิใจเมื่อได้รับคําชมเชยได้อย่างไม่ลังเล เช่น บอกเล่าให้ผู้อื่นรู้',
  'ฉันสามารถเปิดเผยความทุกข์ใจกับกลุ่มเพื่อนได้เสมอ',
  'ฉันจะบอกคนอื่นเวลาฉันต้องการอะไรได้อย่างนุ่มนวล',
  'ฉันให้อภัยคนอื่นได้เสมอ',
  'ฉันยินดีเมื่อมีคนเตือนฉัน',
];
List<String> work = [
  'ฉันรู้สึกเห็นใจเมื่อเห็นเพื่อนหรือผู้อื่นทุกข์ร้อน อยากเข้าไปปลอบหรือเข้าไปช่วย',
  'อยากรู้อยากเห็นกับอะไรใหม่หรือสิ่งแปลกใหม่',
  'สนใจ รู้สึกสนุกกับงานหรือกิจกรรมใหม่ๆ',
  'รู้จักหาของเล่น หรือกิจกรรมเพื่อสร้างความสนุกสนานเพลิดเพลินเป็น',
  'ฉันมองปัญหาเป็นเรื่องท้าทาย',
  'ฉันควบคุมอารมณ์วิตกกังวลของตนเองได้',
  'ฉันทำให้งานเครียดเป็นงานสนุกได้',
  'ฉันมีงานอดิเรกยามว่างสม่ำเสมอ',
];
List<String> social = [
  'ยอมรับกฎเกณฑ์หรือข้อตกลง แม้จะผิดหวัง/ไม่ได้สิ่งที่ต้องการ',
  'ฉันมองโลกในแง่ดีได้เสมอ',
  'ฉันมีเพลงโปรดฟังแล้วคลายเครียด',
  'หยุดการกระทําที่ไม่ดีเมื่อผู้ใหญ่ห้าม',
  'ฉันจัดสิ่งแวดล้อมรอบตัวให้น่ารื่นรมย์เสมอ',
  'ฉันปฏิบัติตัวอยู่ในกฎเกณฑ์ของสังคมได้อย่างสบายใจ ',
  'ฉันเป็นคนปรับตัวเก่ง',
  'ฉันสร้างแรงจูงใจให้ทำในสิ่งน่าเบื่อได้',
];
List<String> questions = [
  'Question 1',
  'Question 2',
  'Question 3',
  'Question 4',
  'Question 5',
  'Question 6',
  'Question 7',
  'Question 8',
];

class WatJai extends StatefulWidget{
  WatJai({Key key}) : super(key: key);

  @override
  _WatJaiState createState() => _WatJaiState();
}

class _WatJaiState extends State<WatJai> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  String level="";
  int limit = 30;
  String today = DateFormat.E().format(DateTime.now());
  SessionJai jai = SessionJai(relexInt: 0,angryInt: 0,sadInt: 0,happyInt: 0,sumInt: 0);
  SessionEQ eq = SessionEQ(jealousInt:0, challengeInt: 0, confidenceInt: 0, openInt: 0, sumInt: 0);
  SessionExp exp = SessionExp(relexDay:"", angryDay: "", sadDay: "", happyDay: "",loveDay: "", expInt: 0,jealousDay: "",confidenceDay: "",challengeDay: "",openDay: "");
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
          level = "Lv.1 ผู้เริ่มต้น";
          exp = myJai;
        });
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        //await FlutterSession().set('expJai', "10");
        dynamic data =  val;
        print("Show::${val}");
        setState(() {
          if(data['expInt'] <= 30 && data['expInt'] >= 0){
            level = "Lv.1 ผู้เริ่มต้น";
            limit = 30;
          }else if(data['expInt'] <= 50 && data['expInt'] > 30){
            level = "Lv.2 ผู้ฝึกหัด";
            limit = 50;
          }else if(data['expInt'] <= 100 && data['expInt'] > 50){
            level = "Lv.3 ผู้เชี่ยวชาญ";
            limit = 100;
          }else{
            level = "Lv.4 ยอดฝีมือ";
            limit = 0;
          }

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



  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = mind;
    super.initState();
    Future(() {
      _startJai(context);
    });
  }

  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFfef9e8);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return   Container(
        color: bgColor(packIndex),

        padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
             // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
               // Text('เริ่มวัดความโกรธ'),

               // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
              //SizedBox(height: MediaQuery.of(context).size.height/12,),
           Column(
                children: [
                  Container(
                      width: (MediaQuery.of(context).size.width/2.0),
                      height: (MediaQuery.of(context).size.width/2.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,21),
                                blurRadius: 53,
                                color: Colors.white.withOpacity(0.9)
                            )
                          ]
                      ),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Image(
                              image: AssetImage('assets/sex/wat_man.png'),
                              height:  (MediaQuery.of(context).size.width/2.8),
                              width: (MediaQuery.of(context).size.width/2.8),
                            ),
                            onTap: (){
                              /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  UserPage(),
                          ),
                        );*/
                            },
                          ),
                          SizedBox(height: 10,),
                          Text("${level}",textScaleFactor: 1.4,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${exp.expInt}/${limit}",textScaleFactor: 1.2,style: TextStyle(color: Colors.black54),),
                        ],
                      )),

                  SizedBox(height: 20,),
                /*  Row(
                    children: [
                      SizedBox(width: 20,),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 5.0,color: Color(0xFF5ec8c7))

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${jai.sumInt}",textScaleFactor: 1.6,style: TextStyle( color: Color(0xFF777777),fontWeight: FontWeight.bold),),
                            Text("%",textScaleFactor: 1.2,style: TextStyle( color: Color(0xFF999999),fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      SizedBox(width:15),
                      Text("สภาพจิตใจ\nโดยรวม",textScaleFactor: 1.2,style:TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                      Spacer(),
                      Text("ดูสถิติ",textScaleFactor: 1.2,style:TextStyle(color: Color(0xFF757878)),textAlign: TextAlign.end,),
                      SizedBox(width: 20,)
                    ],
                  ),

                  
                  Container(width: MediaQuery.of(context).size.width,height: 5,color: Color(0xFFfce184).withOpacity(0.2),margin: EdgeInsets.symmetric(vertical: 20),),
                  
*/
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WatRelex(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Container(
                          //width: (MediaQuery.of(context).size.width/2)-25,
                            margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              //color: Color(0xFF5ec8c7),
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
                            child:Image(image: AssetImage("assets/emotion/smile.png"),width: 30,height: 30,)),
                        SizedBox(width: 15,),

                        Text("วัดความนิ่ง",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                        Spacer(),
                        Text("${jai.relexInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),





                  InkWell(
                    onTap: (){
                      if(today != exp.angryDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatAngry(),
                          ),
                        );
                      }else{
                        showAlertDialog(context,"ความโกรธ");
                      }
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Container(
                          //width: (MediaQuery.of(context).size.width/2)-25,
                            margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              //color: Color(0xFF5ec8c7),
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
                            child:Image(image: AssetImage("assets/emotion/angry.png"),width: 30,height: 30,)),
                        SizedBox(width: 15,),

                        Text("วัดความโกรธ",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                        Spacer(),
                        Text("${jai.angryInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),





                  InkWell(
                    onTap: (){
                      if(today != exp.sadDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatSad(),
                          ),
                        );
                      }else{
                        showAlertDialog(context,"ความเหงา");
                      }

                    },
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Container(
                          //width: (MediaQuery.of(context).size.width/2)-25,
                            margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              //color: Color(0xFF5ec8c7),
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
                            child:Image(image: AssetImage("assets/emotion/opensad.png"),width: 30,height: 30,)),
                        SizedBox(width: 15,),

                        Text("วัดความเหงา",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                        Spacer(),
                        Text("${jai.sadInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),





                  InkWell(
                    onTap: (){
                      if(today != exp.happyDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatHappy(),
                          ),
                        );
                      }else{
                        showAlertDialog(context,"ความสดใส");
                      }

                    },
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Container(
                          //width: (MediaQuery.of(context).size.width/2)-25,
                            margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              //color: Color(0xFF5ec8c7),
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
                            child:Image(image: AssetImage("assets/emotion/openhappy.png"),width: 30,height: 30,)),
                        SizedBox(width: 15,),

                        Text("วัดความสดใส",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                        Spacer(),
                        Text("${jai.happyInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),


                  InkWell(
                    onTap: (){
                      if(today != exp.loveDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatLove(),
                          ),
                        );
                      }else{
                        showAlertDialog(context,"ความหลงรัก");
                      }
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 25,),
                        Container(
                          //width: (MediaQuery.of(context).size.width/2)-25,
                            margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              //color: Color(0xFF5ec8c7),
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
                            child:Image(image: AssetImage("assets/emotion/kissing.png"),width: 30,height: 30,)),
                        SizedBox(width: 15,),

                        Text("วัดความหลงรัก",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                        Spacer(),
                        Text("${jai.loveInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                        SizedBox(width: 25,),
                      ],
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  //color: Color(0xFF5ec8c7),
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
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("วัดความฉลาดทางอารมณ์\n(EQ)ในตัวคุณ",textScaleFactor: 1.8,style: TextStyle(color: Color(0xFF757878)),textAlign: TextAlign.center,),


                    SizedBox(height: 10,),


                    InkWell(
                      onTap: (){
                         if(today != exp.jealousDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatJealous(),
                          ),
                        );
                        }else{
                        showAlertDialog(context,"ความอิจฉา");
                      }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 25,),
                          Container(
                            //width: (MediaQuery.of(context).size.width/2)-25,
                              margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                //color: Color(0xFF5ec8c7),
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
                              child:Image(image: AssetImage("assets/emotion/shy.png"),width: 30,height: 30,)),
                          SizedBox(width: 15,),

                          Text("วัดความอิจฉา",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                          Spacer(),
                          Text("${eq.jealousInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                          SizedBox(width: 25,),
                        ],
                      ),
                    ),






                    InkWell(
                      onTap: (){
                        if(today != exp.challengeDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatChallenge(),
                          ),
                        );
                       }else{
                        showAlertDialog(context,"ความท้าทาย");
                      }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 25,),
                          Container(
                            //width: (MediaQuery.of(context).size.width/2)-25,
                              margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                //color: Color(0xFF5ec8c7),
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
                              child:Image(image: AssetImage("assets/emotion/cool.png"),width: 30,height: 30,)),
                          SizedBox(width: 15,),

                          Text("วัดความท้าทาย",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                          Spacer(),
                          Text("${eq.challengeInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                          SizedBox(width: 25,),
                        ],
                      ),
                    ),








                    InkWell(
                      onTap: (){
                       if(today != exp.confidenceDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatConfidence(),
                          ),
                        );
                       }else{
                        showAlertDialog(context,"ความเชื่อมั่น");
                      }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 25,),
                          Container(
                            //width: (MediaQuery.of(context).size.width/2)-25,
                              margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                //color: Color(0xFF5ec8c7),
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
                              child:Image(image: AssetImage("assets/emotion/goofy.png"),width: 30,height: 30,)),
                          SizedBox(width: 15,),

                          Text("วัดความเชื่อมั่น",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                          Spacer(),
                          Text("${eq.confidenceInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                          SizedBox(width: 25,),
                        ],
                      ),
                    ),






                    InkWell(
                      onTap: (){
                        if(today != exp.openDay) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatOpen(),
                          ),
                        );
                      }else{
                        showAlertDialog(context,"ความเปิดเผย");
                      }
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 25,),
                          Container(
                            //width: (MediaQuery.of(context).size.width/2)-25,
                              margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                //color: Color(0xFF5ec8c7),
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
                              child:Image(image: AssetImage("assets/emotion/wink.png"),width: 30,height: 30,)),
                          SizedBox(width: 15,),

                          Text("วัดความเปิดเผย",textScaleFactor: 1.6,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                          Spacer(),
                          Text("${eq.openInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                          SizedBox(width: 25,),
                        ],
                      ),
                    ),


                  ],
                ),
              ),


              SizedBox(height: MediaQuery.of(context).size.height/8,),
              if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
                onTap: (){

                },
                child: Text("กลับหน้าหลัก",textScaleFactor: 1.2,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
              )
            ],
          ),

      );
  }
}






class WatJaiSmall extends StatefulWidget{
  WatJaiSmall({Key key}) : super(key: key);

  @override
  _WatJaiSmallState createState() => _WatJaiSmallState();
}

class _WatJaiSmallState extends State<WatJaiSmall> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  String level="";
  int limit = 30;
  String today = DateFormat.E().format(DateTime.now());
  SessionJai jai = SessionJai(relexInt: 0,angryInt: 0,sadInt: 0,happyInt: 0,sumInt: 0);
  SessionEQ eq = SessionEQ(jealousInt:0, challengeInt: 0, confidenceInt: 0, openInt: 0, sumInt: 0);
  SessionExp exp = SessionExp(relexDay:"", angryDay: "", sadDay: "", happyDay: "",loveDay: "", expInt: 0,jealousDay: "",confidenceDay: "",challengeDay: "",openDay: "");
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
          level = "Lv.1 ผู้เริ่มต้น";
          exp = myJai;
        });
        //showPopupIntro(context, IntroShow(), 'แนะนำการใช้');
      }else{
        //await FlutterSession().set('expJai', "10");
        dynamic data =  val;
        print("Show::${val}");
        setState(() {
          if(data['expInt'] <= 30 && data['expInt'] >= 0){
            level = "Lv.1 ผู้เริ่มต้น";
            limit = 30;
          }else if(data['expInt'] <= 50 && data['expInt'] > 30){
            level = "Lv.2 ผู้ฝึกหัด";
            limit = 50;
          }else if(data['expInt'] <= 100 && data['expInt'] > 50){
            level = "Lv.3 ผู้เชี่ยวชาญ";
            limit = 100;
          }else{
            level = "Lv.4 ยอดฝีมือ";
            limit = 0;
          }

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



  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = mind;
    super.initState();
    Future(() {
      _startJai(context);
    });
  }

  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFfef9e8);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return   Container(
      color: bgColor(packIndex),

      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Wrap(
        //shrinkWrap: true,
        //primary: false,
        children: <Widget>[
          // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
          // Text('เริ่มวัดความโกรธ'),

          // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
          //SizedBox(height: MediaQuery.of(context).size.height/12,),
        /*  Column(
            children: [

              Text("${level}",textScaleFactor: 1.0,style: TextStyle(fontWeight: FontWeight.bold),),
              Text("${exp.expInt}/${limit}",textScaleFactor: 0.8,style: TextStyle(color: Colors.black54),),
              SizedBox(height: 20,),*/
              /*  Row(
                    children: [
                      SizedBox(width: 20,),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 5.0,color: Color(0xFF5ec8c7))

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${jai.sumInt}",textScaleFactor: 1.6,style: TextStyle( color: Color(0xFF777777),fontWeight: FontWeight.bold),),
                            Text("%",textScaleFactor: 1.2,style: TextStyle( color: Color(0xFF999999),fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      SizedBox(width:15),
                      Text("สภาพจิตใจ\nโดยรวม",textScaleFactor: 1.2,style:TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                      Spacer(),
                      Text("ดูสถิติ",textScaleFactor: 1.2,style:TextStyle(color: Color(0xFF757878)),textAlign: TextAlign.end,),
                      SizedBox(width: 20,)
                    ],
                  ),


                  Container(width: MediaQuery.of(context).size.width,height: 5,color: Color(0xFFfce184).withOpacity(0.2),margin: EdgeInsets.symmetric(vertical: 20),),

*/       Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              //color: Color(0xFF5ec8c7),
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
                child: Row(
                  children: [
                    Image(image: AssetImage("assets/emotion/smile.png"),width: 30,height: 30,),
                    SizedBox(width: 10,),

                    Text("ความนิ่ง",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                    Spacer(),
                    Text("${jai.relexInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                    //SizedBox(width: 25,),
                  ],
                ),
              ),
          if(today == exp.angryDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              //color: Color(0xFF5ec8c7),
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
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/angry.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความโกรธ",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${jai.angryInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),



          if(today == exp.sadDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              //color: Color(0xFF5ec8c7),
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
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/opensad.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความเหงา",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${jai.sadInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),




          if(today == exp.happyDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              //color: Color(0xFF5ec8c7),
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
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/openhappy.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความสดใส",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${jai.happyInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),



          if(today == exp.loveDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              //color: Color(0xFF5ec8c7),
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
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/kissing.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความหลงรัก",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${jai.loveInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),


          if(today == exp.jealousDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFfffdf2),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,21),
                      blurRadius: 53,
                      color: Colors.black.withOpacity(0.05)
                  )
                ]
            ),
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/shy.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความอิจฉา",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${eq.jealousInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),
          if(today == exp.challengeDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xFFfffdf2),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,21),
                      blurRadius: 53,
                      color: Colors.black.withOpacity(0.05)
                  )
                ]
            ),
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/cool.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความท้าทาย",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${eq.challengeInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),
          if(today == exp.confidenceDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xFFfffdf2),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,21),
                      blurRadius: 53,
                      color: Colors.black.withOpacity(0.05)
                  )
                ]
            ),
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/goofy.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความเชื่อมั่น",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${eq.confidenceInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),
           // ],
          //),
          if(today == exp.openDay) Container(
            width:(MediaQuery.of(context).size.width/2.6),
            margin:EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 5) ,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xFFfffdf2),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0,21),
                      blurRadius: 53,
                      color: Colors.black.withOpacity(0.05)
                  )
                ]
            ),
            child: Row(
              children: [
                Image(image: AssetImage("assets/emotion/wink.png"),width: 30,height: 30,),
                SizedBox(width: 10,),

                Text("ความเปิดเผย",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF757878)),),
                Spacer(),
                Text("${eq.openInt}%",textScaleFactor: 2.0,style: TextStyle( color: Color(0xFF5ec8c7),),),
                //SizedBox(width: 25,),
              ],
            ),
          ),
         

          SizedBox(height: MediaQuery.of(context).size.height/8,),
          if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
            onTap: (){

            },
            child: Text("กลับหน้าหลัก",textScaleFactor: 1.4,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
          )
        ],
      ),

    );
  }
}


//วัดความโกรธ// ********* start
List<String> angryMind = [
  'มีปัญหาการนอน\nนอนไม่หลับหรือนอนมาก',
  'ฉันรู้สึกผิดเวลาที่แสดงความรู้สึกโกรธของฉันออกมา',
  'เมื่อฉันบอกให้คนอื่นรู้\nว่าฉันโกรธอยู่ ความรู้สึกนั้น\nจะหายไปจากภายในใจฉันได้',
  'ฉันมักจะซ่อน\nความรู้สึกโกรธไม่ให้คนอื่น\nเห็นและมารู้สึกแย่เกี่ยวกับมันในภายหลัง',
  'ฉันรู้สึกโกรธ\nเวลาที่ฉันทำอะไรไม่ทันเวลา',
  'บ่อยครั้งที่ฉันรู้สึกโกรธ\nมากกว่าที่ฉันคิดว่ามันควรจะเป็น',
  'ถ้าฉันปล่อยให้คนอื่นรับรู้\nถึงความรู้สึกที่แท้จริงของฉัน มันยากมากที่ฉันจะกลายเป็นที่รักของผู้คนได้',
  'บางครั้งฉันรู้สึกโกรธมาก\nจนรู้สึกเหมือนกับว่าฉันอาจจะสูญเสียการควบคุม',
];
List<String> angryPersons = [
  'ผู้คนชอบพูดถึงฉันลับหลัง',
  'ฉันพยายามแก้แค้น\nเมื่อฉันกำลังโกรธใครสักคนอยู่',
  'แค่มีคนมาอยู่ใกล้ๆ\nก็ทำให้ฉันรู้สึกรำคาญได้แล้ว',
  'ฉันมักจะวิจารณ์คนอื่นอย่างลับๆ',
  'ฉันรู้สึกโกรธเวลา\nที่ฉันไม่ได้รับการพูดถึงเกี่ยวกับสิ่งที่ฉันทำ',
  'เพื่อนของฉันบางคน\nมีพฤติกรรมที่น่ารำคาญและรบกวนฉันเป็นอย่างมาก',
  'ฉันเก็บความรู้สึกไม่พอใจ\nเอาไว้ข้างในโดยไม่ได้เล่าให้ใครฟัง',
  'เวลาฉันรู้สึกโกรธใคร\nฉันจะบอกให้เขารู้',
];
List<String> angryWork = [
  'มีสมาธิน้อยลง',
  'หงุดหงิด กระวนกระวาย ว้าวุ่นใจ',
  'ฉันรู้สึกโกรธเวลาที่\nฉันต้องทำงานกับคนที่ไม่มีความสามารถ',
  'ฉันรู้สึกโกรธเวลาที่\nมีคนมาเปลี่ยนข้อตกลงที่เคยคุยกันไว้แล้ว',
  'ฉันได้เจอหลายคนมาก\nที่ได้ชื่อว่าเป็นผู้เชี่ยวชาญ\nแต่กลับไม่ได้เก่งไปกว่าฉันเลย',
  'ฉันรู้สึกโกรธเวลา\nมีคนที่เก่งน้อยกว่ามาออกคำสั่งกับฉัน',
  'ฉันรู้สึกโกรธเวลา\nที่ฉันไม่ได้รับการพูดถึงเกี่ยวกับสิ่งที่ฉันทำ ',
  'ฉันรู้สึกโกรธเวลา\nที่มีบางอย่างมาขัดขวางแผนของฉัน',
];
List<String> angrySocial = [
  'ฉันรู้สึกโกรธเวลา\nที่มีคนทำให้ฉันรู้สึกอับอาย',
  'ไม่อยากพบปะผู้คน',
  'ฉันรู้สึกโกรธเวลา\nที่มีคนปฏิบัติอย่างไม่เป็นธรรม',
  'เมื่อฉันรู้สึกโกรธใครสักคน\nฉันจะแสดงความรู้สึกออกมาโดยที่ไม่สนว่าใครจะอยู่รอบๆ ก็ตาม',
  'ถ้า(หรือเมื่อ)ฉันซ่อนความรู้สึกโกรธ\nที่มีกับคนอื่น ฉันจะคิดถึงสิ่งที่ทำให้ฉันโกรธไปอีกนานหลังจากนั้น',
  'มีบางสิ่งที่ทำให้ฉันรู้สึกโกรธ\nได้แทบจะทุกวัน',
  'ฉันค่อนข้างที่จะระวังตัว\nเวลาที่มีคนมาแสดงท่าที\nที่เป็นมิตรกับฉันมากจนเกินไป',
  'แม้ว่าฉันรู้สึกโกรธ\nฉันพยายามที่จะพูดคุยกับผู้คนเป็นปกติ\nโดยที่ไม่ให้พวกเขารู้ว่าฉันกำลังโกรธอยู่',
];
class WatAngry extends StatefulWidget{
  WatAngry({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatAngryState createState() => _WatAngryState();
}

class _WatAngryState extends State<WatAngry>{
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = angryMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 6){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = angryPersons;
        }else if(packIndex == 2){
          _pageQuestions = angryWork;
        }else if(packIndex == 3){
          _pageQuestions = angrySocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowJai(sumInt: sum.toInt(),IndexWat:0,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;
      sum = sum + (point*2.1);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/angry.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความโกรธ',textScaleFactor: 2.0,),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);

              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            ),

          ],
        ),

      ),
    );
  }
}
//วัดความโกรธ// ********* end





//วัดความเหงา// ********* start

List<String> sadMind = [
  'ฉันรู้สึกว่าตนเองน่าสงสารที่สุดเสมอ',
  'ฉันไม่ใช่คนที่ติดโทรศัพท์มากๆ ทั้งแชท ทั้งโทร อยู่แบบนี้ได้ทั้งวัน',
  'ฉันชอบออกไปไหนมาไหนคนเดียว เพราะคิดว่ามันคล่องตัวที่สุดแล้ว',
  'ไม่มีใครรู้จักฉันดีจริงๆ',
  'คิดทำร้ายตนเอง หรือคิดว่าถ้าตายไปคงจะดี',
  'หลับยาก หรือหลับๆ ตื่นๆ หรือหลับมากไป',
  'เบื่ออาหาร หรือกินมากเกินไป',
  'รู้สึกไม่ดีกับตัวเอง คิดว่าตัวเองล้มเหลว หรือทำให้ตนเองหรือครอบครัวผิดหวัง',
];
List<String> sadPersons = [
  'ฉันอยากมีคนรัก',
  'รู้สึกตื่นเต้นเวลามีคนมาชวนคุยด้วย',
  'ฉันไม่ชอบเดินไปไหนมาไหนกับเพื่อนเป็นกลุ่มใหญ่ๆ แต่จะชอบปลีกตัวเดินไปคนเดียวมากกว่า',
  'ฉันไม่ชอบแชทคุยกับเพื่อนในกลุ่มบ่อยๆ พร้อมสนุกกับการส่งสติ๊กเกอร์',
  'ฉันไม่ชอบไปปาร์ตี้กับเพื่อนๆ โดยเฉพาะการออกไปฟังดนตรีมันๆ',
  'ฉันชอบไปดูหนังคนเดียวมากกว่าต้องมีใครไปด้วย',
  'ฉันรู้สึกเหมือนไม่มีใครเข้าใจฉัน',
  'คนรอบข้างไม่ให้ความสนใจกับความคิดของฉัน',
];
List<String> sadWork = [
  'ฉันจะถือคติที่ว่า จะไม่ยืมเงินคนอื่นเด็ดขาด',
  'ฉันรู้สึกว่ามีปัญหาอะไรก็ต้องแก้ไขด้วยตัวเอง เพราะไม่อยากไปรบกวนคนอื่น',
  'ฉันรู้สึกเหมือนถูกกีดกันและโดดเดี่ยวจากผู้อื่น',
  'เบื่อ ไม่สนใจอยากทำอะไร',
  'เหนื่อยง่าย หรือ ไม่ค่อยมีแรงทำงาน',
  'สมาธิไม่ดีเวลาทำอะไร เช่น ดูโทรทัศน์ ฟังวิทยุ หรือทำงานที่ต้องใช้ความตั้งใจ',
  'ไม่ว่าฉันพบเจอปัญหาใหญ่หรือเล็กแค่ไหน ฉันจะต้องรีบไปขอคำปรึกษาจากเพื่อนๆ ตลอด',
  'คุณรู้สึกยากที่จะหาเพื่อนหรือคนมาช่วย',
];
List<String> sadSocial = [
  'พอมองท้องฟ้ายามค่ำคืนแล้วมักนึกใครสักคนที่จะมานั่งเป็นเพื่อนด้วย',
  'เคยเป็นคนนั่งนับดาวบ่อยๆ',
  'เมื่อคนในบ้านออกไปข้างนอกหมด ฉันมักจะหาเรื่องโทรคุยกับเพื่อน',
  'ฉันมักกอดตุ๊กตาบ่อยๆ ในห้องนอน ',
  'ฉันจะชอบอ่านหนังสือ ฟังเพลง สร้างโลกส่วนตัวอยู่กับตัวเอง เวลาที่จำเป็นที่ต้องอยู่บ้านคนเดียวในวันหยุดสัปดาห์',
  'ฉันชอบการนั่งทานข้าวคนเดียว พร้อมกับการดูคลิปวิดีโอหรือดูทีวีไปด้วยเพลินๆ ',
  'พูดช้า ทำอะไรช้าลง จนคนอื่นสังเกตเห็นได้',
  'ฉันชอบหามุมเงียบๆให้ตนเองทุกครั้งที่มีโอกาส',
];


class WatSad extends StatefulWidget{
  WatSad({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatSadState createState() => _WatSadState();
}

class _WatSadState extends State<WatSad> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = sadMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 6){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = sadPersons;
        }else if(packIndex == 2){
          _pageQuestions = sadWork;
        }else if(packIndex == 3){
          _pageQuestions = sadSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowJai(sumInt: sum.toInt(),IndexWat:1,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*2.1);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/opensad.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความเหงา',textScaleFactor: 2.0,),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);

                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);

              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            ),

          ],
        ),

      ),
    );
  }
}






//วัดความสดใส// ********* start
List<String> happyMind = [
  'อดทน และรอคอยได้โดยไม่รู้เหนื่อย',
  'แสดงอารมณ์สนุกหรือร่วมสนุกตามไปกับสิ่งท่ีเห็น เช่น ร้องเพลง กระโดดโลดเต้น หัวเราะเฮฮา',
  'ไม่กลัวเมื่อต้องอยู่กับคนที่ไม่สนิทสนม',
  'ฉันรู้ตัวได้เร็วเมื่อเริ่มเครียด',
  'ฉันภูมิใจในตนเอง',
  'ฉันสามารถควบคุมความคิดได้ดี',
  'ฉันมีสติ รู้ตัวเองว่ามีอารมณ์อย่างไรเสมอ',
  'ฉันมีเวลาพักผ่อนเพียงพอ',
];
List<String> happyPersons = [
  'ฉันสามารถแบ่งปันสิ่งของให้คนอื่นๆ เช่น ขนม ของเล่น',
  'ฉันจะบอกขอโทษหรือแสดงท่าทียอมรับผิดทันที เมื่อรู้ว่าทําผิด',
  'เมื่อไม่ได้สิ่งที่อยากได้ก็สามารถใช้สิ่งอื่นแทนได้',
  'ฉันสามารถแสดงความภาคภูมิใจเมื่อได้รับคําชมเชยได้อย่างไม่ลังเล เช่น บอกเล่าให้ผู้อื่นรู้',
  'ฉันสามารถเปิดเผยความทุกข์ใจกับกลุ่มเพื่อนได้เสมอ',
  'ฉันจะบอกคนอื่นเวลาฉันต้องการอะไรได้อย่างนุ่มนวล',
  'ฉันให้อภัยคนอื่นได้เสมอ',
  'ฉันยินดีเมื่อมีคนเตือนฉัน',
];
List<String> happyWork = [
  'ฉันรู้สึกเห็นใจเมื่อเห็นเพื่อนหรือผู้อื่นทุกข์ร้อน อยากเข้าไปปลอบหรือเข้าไปช่วย',
  'อยากรู้อยากเห็นกับอะไรใหม่หรือสิ่งแปลกใหม่',
  'สนใจ รู้สึกสนุกกับงานหรือกิจกรรมใหม่ๆ',
  'รู้จักหาของเล่น หรือกิจกรรมเพื่อสร้างความสนุกสนานเพลิดเพลินเป็น',
  'ฉันมองปัญหาเป็นเรื่องท้าทาย',
  'ฉันควบคุมอารมณ์วิตกกังวลของตนเองได้',
  'ฉันทำให้งานเครียดเป็นงานสนุกได้',
  'ฉันมีงานอดิเรกยามว่างสม่ำเสมอ',
];
List<String> happySocial = [
  'ยอมรับกฎเกณฑ์หรือข้อตกลง แม้จะผิดหวัง/ไม่ได้สิ่งที่ต้องการ',
  'ฉันมองโลกในแง่ดีได้เสมอ',
  'ฉันมีเพลงโปรดฟังแล้วคลายเครียด',
  'หยุดการกระทําที่ไม่ดีเมื่อผู้ใหญ่ห้าม',
  'ฉันจัดสิ่งแวดล้อมรอบตัวให้น่ารื่นรมย์เสมอ',
  'ฉันปฏิบัติตัวอยู่ในกฎเกณฑ์ของสังคมได้อย่างสบายใจ ',
  'ฉันเป็นคนปรับตัวเก่ง',
  'ฉันสร้างแรงจูงใจให้ทำในสิ่งน่าเบื่อได้',
];


class WatHappy extends StatefulWidget{
  WatHappy({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatHappyState createState() => _WatHappyState();
}

class _WatHappyState extends State<WatHappy> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = happyMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 6){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = happyPersons;
        }else if(packIndex == 2){
          _pageQuestions = happyWork;
        }else if(packIndex == 3){
          _pageQuestions = happySocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowJai(sumInt: sum.toInt(),IndexWat:2,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*2.1);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/openhappy.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความสดใส',textScaleFactor: 2.0,),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}









//วัดความสดใส// ********* start
List<String> loveMind = [
  'คุณคิดไปเองว่าเขามีใจ',
  'คุณคิดไปเองว่าเขาไม่มีใจ',
  'คุณรู้สึกหัวใจเปราะบาง\nหวั่นไหวกับสิ่งรอบตัวง่าย',
  'หน้าเขาลอยมาบ่อยๆในหัวของคุณ',
  'คุณจะกลายเป็นคนคิดเยอะมากขึ้น',
  'คุณรู้สึกมีความมั่นใจมากขึ้น',
  'คุณเริ่มที่จะคาดหวังในตัวเองมากขึ้น',
  'รู้สึกไปว่าตัวเอง\nประสาทสัมผัสตื่นตัวมากกว่าเดิม',
];
List<String> lovePersons = [
  'เอาคำพูดของเขา\nมาคิดวนไปวนมาคนเดียวทั้งวัน',
  'คุณดูหน้าจอมือถือทั้งวัน\nว่าเขาจะทักมาบ้างไหม',
  'เขาเหลือบตามองมาแวบเดียว\nคุณก็เก็บเอามาคิด ',
  'คุณจะมองทุกสิ่งอย่าง\nในมุมที่ไม่เกี่ยวกับ\nตัวเองอย่างเดียวมากขึ้น',
  'คุณมีอาการ พูดไม่รู้เรื่อง\nพูดจาสับสน ความจำสั้นกระทันหัน\nเวลาคุยกับเขา ',
  'คุณแอบรู้สึกไปเองนิดๆ\nคิดไปว่าเขาจะคิดเหมือนกันบ้างไหม',
  'คุณมีอาการเหมือน\nไม่อยากคิดถึง\nแต่ก็ยิ่งคิดถึง',
  'คุณหลบสายตาเวลาเขามองมา',
];
List<String> loveWork = [
  'เวลาดูหนังอะไรชอบคิดไปว่า\nคุณกับเขาคือ\nพระเอกนางเอกในเรื่องนั้น ',
  'จดบันทึกทุกเรื่องราว\nเกี่ยวกับเขาเอาไว้\nเขาชอบอะไร ไม่ชอบอะไร\nเจอกันครั้งแรกเมื่อไหร่',
  'ยิ่งคุณกับเขาชอบอะไร\nคล้ายคล้ายกัน\nก็ทำให้คุณยิ่งฝันไปไกล',
  'บางครั้งคุณไม่สนใจ\nสิ่งอื่นนอกจากคนที่เรารัก\nมองแต่เขา คิดถึงแต่เขา',
  'ต่อให้คุณยุ่งแค่ไหนก็จะมีแว๊บนึงที่นึกถึงเขา',
  'จู่ๆก็เกิดอาการคล้ายไม่มีสมาธิ\nกับเรื่องอื่นที่อยู่ตรงหน้า',
  'คุณอยากทำอะไรให้ดีกว่านี้\nสร้างสิ่งที่ดีกว่านี้\nเพื่อแชร์เรื่องราวให้เขาฟัง',
  'คุณจะรู้สึกว่าตัวเองต้องพยายามมากขึ้นในเรื่องต่างๆ',
];
List<String> loveSocial = [
  'ฟังเพลงอะไรก็เหมือนแต่งมาจากชีวิตเรา',
  'ทุกครั้งเห็นเขาออนไลน์อยู่อยากทัก แต่ไม่กล้า',
  'เวลาที่เราได้คุยกัน\nเวลาที่ฉันได้อยู่ใกล้ใกล้เธอ\nช่างผ่านไปเร็ว~',
  'คิดถึง จดจำทุกเหตุการณ์\nไม่ว่าจะผ่านไปนานแค่ไหน\nก็ไม่เคยลืม ',
  'พอเขาหายไปก็มองหา\nและรู้สึกชีวิตขาดอะไรไป',
  'คุณเกิดความสุขหัวใจพองโต\nนั่งมองฟ้า มองทะเล\nเป็นวันๆ ก็ทำได ',
  'ทุกสิ่งทุกอย่างรอบตัว\nจะดูสวยงามดูดีมีสีสันไปหมด',
  'บางครั้งรู้สึกเหมือน\nเวลาผ่านไปช้าขึ้นมากๆ\nอะไรๆ ก็ดูน่าเบื่อไปซะหมด',
];


class WatLove extends StatefulWidget{
  WatLove({Key key,@required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatLoveState createState() => _WatLoveState();
}

class _WatLoveState extends State<WatLove> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = loveMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 6){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = lovePersons;
        }else if(packIndex == 2){
          _pageQuestions = loveWork;
        }else if(packIndex == 3){
          _pageQuestions = loveSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowJai(sumInt: sum.toInt(),IndexWat:3,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*2.1);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/kissing.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความหลงรัก',textScaleFactor: 2.0),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}









//วัดความอิจฉา// ********* start
List<String> jealousMind = [
  'คุณมีชีวิตชีวา',
  'คุณรู้สึกพอใจ',
  'คุณมีความสุขและพึงพอใจ',
  'คุณรู้สึกสุขกายสุขใจ',
  'คุณสุขสงบ',
  'คุณเริงร่าแจ่มใส',
];
List<String> jealousPersons = [
  'คุณมีชีวิตครอบครัวที่น่ารักและมั่นคง',
  'น้อยครั้งมากที่จะมีอะไร\nมาทำให้มโนธรรมของคุณหวั่นไหวได้',
  'คุณจะไม่ระบายความไม่พอใจใส่คนอื่น',
  'คุณโล่งใจไม่มีอะไรต้องเป็นห่วง',
  'คุณไม่อิจฉาที่คนอื่น มีทรัพย์สมบัติ',
  'คุณเป็นคนสนุกสนานสบายๆ',
];
List<String> jealousWork = [
  'คุณสร้างแรงจูงใจให้ตัวเองได้',
  'คุณหาทางผ่อนคลายได้สบายๆ',
  'คุณสนุกกับช่วงยามว่างของตัวเอง',
  'คุณสนุกกับงานที่ทำ',
  'คุณไม่ใช่คนทำอะไรซ้ำซากจำเจ',
  'คุณเป็นคนช่างคิดช่างไตร่ตรอง',
];
List<String> jealousSocial = [
  'คุณไม่มีปมด้อย',
  'ปกติแล้วตอนกลางคืน\nคุณนอนหลับสนิทดี',
  'คุณรู้สึกโชคดีที่ชีวิตนี้มีแต่โชค',
  'ที่ผ่านมาคุณใช้ชีวิตอย่างคุ้มค่า',
  'คุณจิตใจสงบ',
  'คุณรู้สึกมั่นคง',
];


class WatJealous extends StatefulWidget{
  WatJealous({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatJealousState createState() => _WatJealousState();
}

class _WatJealousState extends State<WatJealous> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = jealousMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 4){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = jealousPersons;
        }else if(packIndex == 2){
          _pageQuestions = jealousWork;
        }else if(packIndex == 3){
          _pageQuestions = jealousSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowEQ(sumInt: sum.toInt(),IndexWat:0,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*1.9);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/shy.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความน้อยเนื้อต่ำใจ',textScaleFactor: 2.0),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}



//วัดความท้าทาย// ********* start
List<String> challengeMind = [
  'คุณไม่ครั่นคร้าม',
  'คุณไม่สุขุม\nไม่รอบคอบ ',
  'คุณกล้าได้กล้าเสีย',
  'คุณหุนหันพลันแล่น',
  'คุณชอบเสี่ยงชอบผจญภัย\nหรือกล้าหาญ',
  'คุณเชื่อมั่นการตัดสินใจของตัวเองอย่างมาก',
];
List<String> challengePersons = [
  'เวลาอยากจะพูดอะไร\nคุณจะพูดออกไปตรงๆ',
  'คุณอยากร่วมบินไป\nกับลูกบอลลูนยักษ์',
  'คุณเป็นคนเดาใจยาก',
  'คุณมีความคิดสร้างสรรค์ ',
  'ฉันจะยอมเล่นบันจีจัมพ์\nเพื่อช่วยงานการกุศลที่ฉันชอบ',
  'คุณมักทำอะไรตามสัญชาตญาณ\nมากกว่าทำตามเหตุผล',
];
List<String> challengeWork = [
  'คุณไม่ลังเลเลยที่จะรับ\nคำเชื้อเชิญให้ไปพูดต่อหน้าฝูงชน',
  'คุณชอบใช้วันหยุดไปท่องป่า\nดูสัตว์มากกว่าพักอยู่ในรีสอร์ต',
  'การเปลี่ยนแปลงย่อมหมายถึงโอกาส',
  'ความท้าทายที่จะได้รับ\nงานใหญ่ชิ้นใหม่ๆ ทำให้คุณตื่นเต้น',
  'คุณอยากให้ชีวิต\nมีอะไรตื่นเต้นมากกว่านี้',
  'ฉันชอบเล่นขับรถเร็วๆ\nในงานนิทรรศการสนุกๆ',
];
List<String> challengeSocial = [
  'เมื่อโจรที่ไม่มีอาวุธ\nเข้ามาปล้นร้านขายของ\nคุณมักพยายามทำอะไรสักอย่าง',
  'คุณไม่กลัวที่จะอยู่ตามลำพัง\nในต่างเมือง',
  'ถ้ามีเด็กสองคนกำลังชกต่อยกันบนถนน\nคุณจะพยายามเข้าไปห้ามเพื่อให้เหตุการณ์สงบ',
  'คุณเชื่อว่าคนเราจำเป็น\nต้องนำเงินไปเสี่ยงโชคทำกำไร\nจะได้มีเงินสะสมมากขึ้น ',
  'คุณไม่เคยกลัวเมื่อต้องเดินทางโดยเครื่องบิน',
  'คุณไม่กลัวที่จะละเลยกฎระเบียบหยุมหยิมต่างๆ',
];


class WatChallenge extends StatefulWidget{
  WatChallenge({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatChallengeState createState() => _WatChallengeState();
}

class _WatChallengeState extends State<WatChallenge> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = challengeMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 4){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = challengePersons;
        }else if(packIndex == 2){
          _pageQuestions = challengeWork;
        }else if(packIndex == 3){
          _pageQuestions = challengeSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowEQ(sumInt: sum.toInt(),IndexWat:1,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*1.9);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/cool.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความกล้า',textScaleFactor: 2.0),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}





//วัดความเชื่อมั่น// ********* start
List<String> confidenceMind = [
  'คุณรู้สึกดีกับตัวเอง',
  'น้อยครั้งมากที่คุณ\nจะเศร้าหรือหดหู่หม่นหมอง',
  'คุณเชื่อในพลัง\nของการคิดบวก',
  'คุณมีทัศนคติใน\nเรื่องชีวิตในทางที่ดี',
  'คุณไม่เคยท้อถอย',
  'คุณไม่เคยดูถูกตัวเอง',
];
List<String> confidencePersons = [
  'คุณไม่เคยกลัวที่จะบอกคนอื่นเวลา\nที่ไม่เห็นด้วยกับพวกเขา\nไม่ว่าเขาจะเป็นใครก็ตาม',
  'คุณรู้สึกว่า\nมันไม่จำเป็นที่จะต้อง\nคล้อยตามผู้อื่นเพื่อให้คนอื่นยอมรับ',
  'คุณอยากเข้าไปร่วม\nรายการตอบคำถามทางโทรทัศน์',
  'คุณเชื่อมั่นในการตัดสินใจ\nของตัวเองมากกว่าการตัดสินใจของคนอื่น',
  'คุณรู้สึกสนุกเมื่อได้แวะเวียน\nไปพบผู้คนใหม่ๆ ในงานสังสรรค์ ',
  'คุณโน้มน้าวคนอื่นให้เห็น\nความสามารถหรือคุณค่าของฉันได้อย่างมั่นใจ ',
];
List<String> confidenceWork = [
  'ปกติคุณจะตื่นเต้นและกระตือรือร้น\nเวลาต้องทำงานโครงการใหม่ๆ',
  'การตั้งเป้าหมาย\nให้ตัวเองประสบความสำเร็จในชีวิต\nจะช่วยได้มากตราบใดที่เป้าหมายเหล่านั้น\nไม่สูงเกินไปจนไม่สามารถทำได้จริง',
  'หากมีคนมองหาตัวคุณและ\nเสนองานใหม่ด้วยเงินเดือนที่สูงขึ้น\nฉันอาจยอมรับงานนั้น\nแม้จะยังรู้สึกมั่นคงและ\nสบายใจกับงานปัจจุบันที่ทำอยู่ ',
  'เวลาเข้าร่วมเล่นเกมหรือเล่นกีฬา\nคุณจะเล่นให้ชนะเสมอ ',
  'การได้ลองเสี่ยงอย่างมีหลักการทำให้คุณรู้สึกตื่นเต้น',
  'ฉันเชื่อมั่นจริงๆ\nกับคติพจน์เก่าๆที่บอกว่า\nหากคุณต้องการให้งานออกมาดี\nจงทำมันด้วยตัวคุณเอง ',
];
List<String> confidenceSocial = [
  'คุณไม่กลัวที่จะสนับสนุนคน\nที่เสียเปรียบในการโต้แย้ง',
  'คุณไม่ประหม่าเวลาคิดว่า\nต้องไปเข้าประชุมร่วมกับ\nคนที่มีชื่อเสียงหรือมีอิทธิพลมากๆ',
  'คุณรู้สึกสนุกเมื่อคิดว่า\nจะต้องย้ายไปยังส่วนอื่นของประเทศ',
  'คุณลุกขึ้นยืนหยัดใหม่ได้อย่างรวดเร็ว\nเมื่อประสบเคราะห์กรรมอันเลวร้าย',
  'คุณชื่นชอบการโต้วาที\nหรือการอภิปรายที่ดีๆ',
  'คุณไม่ประหม่า\nเมื่อต้องพูดต่อหน้าคนนับร้อยๆคน',
];


class WatConfidence extends StatefulWidget{
  WatConfidence({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatConfidenceState createState() => _WatConfidenceState();
}

class _WatConfidenceState extends State<WatConfidence> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = confidenceMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 4){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = confidencePersons;
        }else if(packIndex == 2){
          _pageQuestions = confidenceWork;
        }else if(packIndex == 3){
          _pageQuestions = confidenceSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowEQ(sumInt: sum.toInt(),IndexWat:2,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*1.9);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/goofy.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความเชื่อมั่น',textScaleFactor: 2.0),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}





//วัดความเป็นเปิดตัวเอง// ********* start
List<String> openMind = [
  'คุณชอบแสดงความรู้สึก\nออกมาอย่างเปิดเผย',
  'คุณอยากรู้อยากเห็นและ\nทำอะไรตามสัญชาตญาณ',
  'คุณชอบพูดมากกว่าชอบฟัง',
  'คุณมีความเป็นมิตร',
  'เป็นเรื่องง่ายสำหรับคุณ\nที่จะแสดงความยินดีหรือเสียใจต่อคนอื่น\nเมื่อเห็นสมควร ',
  'ฉันมีเรื่องพูดคุยอยู่ตลอดเวลา',
];
List<String> openPersons = [
  'คุณชอบทำความรู้จักกับผู้คน',
  'คุณพยายามจริงใจและ\nซื่อตรงต่อตัวเองและผู้อื่นเสมอ',
  'คุณชอบช่วยเหลือคนอื่น',
  'ไม่ใช่เรื่องยากที่\nคุณจะแสดงความรู้สึกที่ฉันมีให้คนอื่นรู้',
  'คุณชอบอยู่กับคนหมู่มาก\nมากกว่าอยู่ตามลำพัง ',
  'คุณเข้าสังคมได้ง่าย',
];
List<String> openWork = [
  'คุณรู้สึกสบายมากเมื่อต้องเข้า\nร่วมงานสังสรรค์ที่มีคนเยอะแยะ',
  'คุณชอบเกมที่เล่นกัน\nเป็นทีมมากกว่าที่เล่นคนเดียว ',
  'คุณสนุกกับการได้นั่งเป็นคณะกรรมการ',
  'คุณชอบนำมากกว่าชอบตาม',
  'คุณพอใจเมื่อมีคนรับรู้ว่า คุณทำได้ดี',
  'คุณมีงานอดิเรกและสนใจเรื่องต่างๆ\nที่ต้องเกี่ยวพันกับผู้คน',
];
List<String> openSocial = [
  'คุณเป็นคนทำอะไรตามสบาย\nตามสถานการณ์ ไม่ยึดติด',
  'คุณเชื่อว่า คนเราควรพูดตามที่คิด\nแม้มันอาจทำให้ใครไม่สบอารมณ์',
  'คุณเชื่อว่า คนเราไม่ควรเก็บ\nสิ่งต่างๆ เป็นความลับ ',
  'ความรู้จะมีคุณค่า\nก็ต่อเมื่อมีการแบ่งปันให้ผู้อื่น',
  'เมื่ออยู่ตามลำพังกับใครในลิฟต์ บางทีฉันก็หาเรื่องคุยกับเขา',
  'เป็นเรื่องยากที่คุณจะไม่แสดงความกระตือรือร้น\nเมื่อได้รับงานใหม่ที่น่าตื่นเต้น',
];


class WatOpen extends StatefulWidget{
  WatOpen({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;
  @override
  _WatOpenState createState() => _WatOpenState();
}

class _WatOpenState extends State<WatOpen> {
  List<String> _pageQuestions;
  String _currentQuestion;
  int packIndex  = 0;
  double sum  = 0;
  int pageInt = 0;
  @override
  void initState() {
    // Initialize pageQuestions with a copy of initial question list
    _pageQuestions = openMind;
    super.initState();
  }

  void _shuffleQuestions(int point) {
    // Initialize an empty variable
    String question;

    // Check that there are still some questions left in the list
    if (_pageQuestions.isNotEmpty) {

      if(_pageQuestions.length < 4){
        packIndex += 1;
        setState(() {});
        print(_pageQuestions.length);
        if(packIndex == 1){
          _pageQuestions = openPersons;
        }else if(packIndex == 2){
          _pageQuestions = openWork;
        }else if(packIndex == 3){
          _pageQuestions = openSocial;
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowEQ(sumInt: sum.toInt(),IndexWat:3,text_profile:widget.text_profile),
            ),
          );
        }
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }else{
        // Shuffle the list
        _pageQuestions.shuffle();
        // Take the last question from the list
        question = _pageQuestions.removeLast();
      }

    }
    setState(() {
      pageInt += 1;

      sum = sum + (point*1.9);
      // call set state to update the view
      _currentQuestion = question;
    });
  }
  Color bgColor(int pack){
    if(pack == 0){
      return Color(0xFFe0e0e0);
    }else if(pack == 1){
      return Color(0xFFfff1bc);
    }else if(pack == 2){
      return Color(0xFFccefff);
    }else if(pack == 3){
      return Color(0xFFc6ffd1);
    }else {
      return Color(0xFFFFFFFF);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor(packIndex),
      body:  Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            // if (_pageQuestions.isNotEmpty && _currentQuestion == null)
            // Text('เริ่มวัดความโกรธ'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) Container(
              height: 10,
              //width: MediaQuery.of(context).size.width-80,
              //color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height:10,width:((MediaQuery.of(context).size.width-80)/12)*pageInt,color: Color(0xFF5ec8c7),)
                ],
              ) ,
            ),
            if (_pageQuestions.isEmpty) Text('No more questions left'),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null)
              Container(
                  height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${_currentQuestion}',textScaleFactor: 2.0,textAlign: TextAlign.center,),
                    ],
                  )
              ),
            // Text('${_currentQuestion} (Questions left: ${_pageQuestions.length})  ${sum}'),
            //SizedBox(height: MediaQuery.of(context).size.height/12,),
            (_pageQuestions.isNotEmpty && _currentQuestion != null) ?

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(4);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/happy.png"),width: 40,height: 40,),
                        Text("มาก",textScaleFactor: 1.2,)
                      ],
                    )

                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(3);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/flirt.png"),width: 40,height: 40,),
                        Text("กลางๆ",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(2);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/sad.png"),width: 40,height: 40,),
                        Text("น้อย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
                InkWell(
                    onTap:  (){
                      _shuffleQuestions(1);
                    },
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/straight.png"),width: 40,height: 40,),
                        Text("ไม่เลย",textScaleFactor: 1.2,)
                      ],
                    )
                ),
              ],
            ) : Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height/2 ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage("assets/emotion/wink.png"),width: 100,height: 100,),
                      ],
                    )
                ),
                RaisedButton(
                  onPressed: (){
                    _shuffleQuestions(0);
                  },
                  child: Text('เร่ิม..วัดความเป็นกันเอง',textScaleFactor: 2.0),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
                )
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height/8,),
            if (_pageQuestions.isNotEmpty && _currentQuestion != null) InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("กลับหน้าหลัก",textScaleFactor: 1.8,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87),),
            )
          ],
        ),

      ),
    );
  }
}



class ShowJai extends StatefulWidget{
  ShowJai({Key key, @required this.sumInt, this.IndexWat, this.text_profile}) : super(key: key);
  final int sumInt;
  final int IndexWat;
  final text_profile;
  @override
  _ShowJaiState createState() => _ShowJaiState();
}

class _ShowJaiState extends State<ShowJai> with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation animation;
    String text = "";

    List<String> list1 = [
      "1",
      "2"
    ];
    List<Jai> listJai = [
      Jai(
        text1: "ตอนนี้คุณโมโห ฉุนเฉียว หงุดหงิดง่าย ทำให้มักมองโลกแบบเยาะเย้ย หวาดระแวง และไม่เชื่อใจ มักจะมีเจตนาที่ไม่ดีต่อคนอื่นได้ง่ายกว่า และบ่อยครั้งที่คิดว่าคนอื่นกำลังโกหกหรือไม่ได้ให้ความสนใจด้วยใจจริงมันอาจทำให้ผู้คนค่อยๆ ถอยออกมาและตีตัวออกห่างได้",
        text2: "คุณอาจจะมีความหงุดหงิดเก็บไว้ในใจหรือมียากที่จะควบคุมการแสดงออกเวลาโกรธได้อย่างเหมาะสม หาทางเรียนรู้เพิ่มเติมเกี่ยวกับความโกรธและผลของมันจะช่วยให้คุณหลีกเลี่ยงปัญหาที่เกิดขึ้นกับปัจจุบันและอนาคตได้ หากคุณรู้สึกอัดอั้น ให้ลองหาเพื่อนที่ไว้ใจได้คุยด้วย อาจจะเป็นคนครอบครัวหรือตัวแทนทางศาสนาที่คุณนับถือก็จะช่วยได้เช่นกัน",
        text3: "คุณรู้ว่าเมื่อไหร่ที่จะยอมหัก หรือเมื่อไหร่จะยอมงอ เมื่อไหร่ควรเรียกร้องสิทธิ หรือเมื่อไหร่ควรสงบปากสงบคำ เรียกได้ว่ามีวุฒิภาวะทางอารมณ์ คุณสามารถจัดการกับความโกรธได้เป็นอย่างดี พยายามรักษาอารมณ์ให้นิ่งแบบนี้ไว้ หากคุณคิดว่าต้องการที่ระบาย ลองหาหนังสือจิตวิทยาหรือหนังสือธรรมะดีๆ ก็จะยิ่งช่วยให้จิตของคุณเข้มแข็งขึ้น",
        text4: "คุณเป็นคนใจเย็น ไม่ขี้โกรธเลย หรือเป็นคนเย็นชาเกินไป บางครั้งคุณไม่ชอบแสดงอารมณ์ความรู้สึกออกมาโดยตรงผล ทว่าจากอารมณ์เก็บกดสะท้อนออกทาร่างกาย เช่นปวดศีรษะ โรคกระเพาะคุณควรค่อยๆ ผ่อนคลายจิตใจจะแก้ความเย็นชาที่มีต่อคนอื่นได้ลองหัดแสดงความรู้สึกในเรื่องเล็กๆน้อยๆจากนั้นค่อยหัดออกความเห็น ในเรื่องที่ใหญ่ขึ้น",
      ),
      Jai(
        text1: "ในจิตใจลึกๆ คุณจะต้องการให้คนรอบข้างสนใจคุณมากและทุกคนจะต้องสนับสนุนในสิ่งที่คุณทำด้วย ไม่เช่นนั้นคุณจะรู้สึกโกรธและไม่โอเคกับเพื่อน คุณไม่สามารถอยู่คนเดียวและทำอะไรคนเดียวได้ คุณต้องการให้เพื่อนมาแชร์ความรู้สึกของคุณในทุกห้วงอารมณ์ ถึงตอนนั้นไม่ได้อยู่ด้วยกัน โทรฯ หากันก็ยังดี",
        text2: "คุณเป็นคนเหงาปานกลาง เหงาถูกกาละเทศะ ลองหลีกเลี่ยงการนั่งนับดาวมาทำอย่างอื่นที่มีประโยชน์บ้างดีไหม อาทิเช่น นั่งนับจำนวนครั้งที่เราไม่ได้ข้ามถนนตรงทางม้าลาย, นั่งนับจำนวนครั้งที่เราไม่ได้ทิ้งขยะลงในที่ทิ้งขยะหรือบางครั้งคุณอาจเป็นเหมือนคนโรคจิตชนิดหนึ่งก็ว่าได้ ที่กลัวการถูกคนรอบข้างทอดทิ้ง ",
        text3: "แม้จะเหงาบ้าง แต่คุณไม่ได้โดดเดี่ยว คุณอยู่คนเดียวได้ ทำอะไรคนเดียวก็ได้ คุณรู้ว่า ณ เวลานั้น เพื่อนหรือคนรอบข้าง เวลาไม่ตรงกันเท่านั้น เหงาบ้างก็ดี ถ้า มันทำให้ความคิดถึงมีคุณค่าขึ้นมา และความเหงาก็สร้างแรงบันดาลใจดี ๆ ให้คุณได้เสมอ",
        text4: "หัด เหงาซะบ้าง ศิลปะหลายชิ้นในโลก เกิดขึ้นเพราะความเหงา เชื่อมั้ย!?",
      ),
      Jai(
        text1: "คุณมีความสดใสทางอารมณ์ที่ดี มีความพร้อมอย่างมากสำหรับการเรียนรู้การเข้าสังคมและเติบโตพัฒนาทักษะและความสามารถต่างๆในอนาคต",
        text2: "คุณมีความสดใสในระดับปานกลาง คุณพร้อมจะรับสิ่งใหม่ๆ ในชีวิตพอสมควร โลกของคุณถือว่าสวยงามทีเดียวล่ะ",
        text3: "พอใช้ได้ ควรพัฒนาอีกนิดหน่อย คุณมาถูกทางแล้ว แต่ต้องการการฝึกฝนอีกนิดหน่อย เริ่มจาก การสังเกตอารมณ์ต่างๆที่เกิดขึ้นและยอมรับอารมณ์นั้น ฝึกให้กำลังใจตนเองสร้างแรงจูงใจให้ตัวเอง โดยการตั้งเป้าหมาย และสุดท้าย คือฝึกโดยการสร้างความสุขรอบๆตัว",
        text4: "ต้องพัฒนาขึ้นอีก โดยการฝึกสมาธิ ฝึกสังเกตอารมณ์ ชีวิตจะได้สดใสขึ้น",
      ),
      Jai(
        text1: "คุณกำลังตกหลุมรัก ช่วงนี้คุณจะเต็มไปด้วยฮอร์โมนแห่งความสุข เป็นช่วงที่ความต้องการของคุณ ความหวังในชีวิตคุณ ผูกติดอยู่กับเขา เขากลายเป็นคนสำคัญ ไม่มีข้อแม้ใดๆสำหรับเขา เชื่อว่า เขาคือคนที่เกิดมาเพื่อเติมเต็มส่วนที่ขาดหายไปของคุณ และเชื่อทุกคำที่เขาพูด คุณแทบจะไม่ฟังคำใดๆจากคนอื่น ห้ามยังไงก็ไม่ฟัง ดื้อดึงให้สุด ทำยังไงก็ได้ให้ได้อยู่กับเขา",
        text2: "คุณกำลังรู้สึกเหมือนเป็นตัวเอกในละคร เป็นช่วงที่คุณมีความฝันหวานนิดๆ ในการมองและชื่นชมคนที่คุณสนใจ ซึ่งตอนนี้คุณกำลังมองข้ามข้อเสียของอีกฝ่ายไปทั้งหมด เลือกมองเฉพาะสิ่งที่ตัวเองอยากเห็น ทั้งยังไม่รู้นิสัยที่แท้จริงของกันและกัน แต่คุณก็มีความสุข",
        text3: "คุณสามารถเป็นตัวของตัวเองได้ มีความรักและความชื่นชมอยู่ในใจระดับที่พอดี คุณไม่เผลอให้อารมณ์มาครอบงำจิตใจ ในขณะเดียวกันก็ยังมีความสุขที่ได้รักและชื่นชมคนที่คุณชอบอยู่เสมอๆ",
        text4: "คุณเป็นตัวของตัวเองสุดๆ ไม่หลงใหลใครง่ายๆ เป็นคนที่มีความมั่นคงในจิตใจ พึงพอใจกับสิ่งที่ตนเองมี",
      ),
      Jai(
        text1: "",
        text2: "",
        text3: "",
        text4: "",
      ),
    ];
  static DataApr DatabaseApr = DataApr();
  Future<void> _updateJai(context) async {
    await FlutterSession().get("myjai").then((val) async {
      dynamic data =  val;
      if(widget.IndexWat == 0){
        double sum = ((widget.sumInt + data['sadInt'] + data['happyInt'] + data['relexInt'])/4);
        SessionJai myJai = SessionJai(relexInt:data['relexInt'], angryInt:widget.IndexWat == 0 ? widget.sumInt : data['angryInt'], sadInt: widget.IndexWat == 1 ? widget.sumInt : data['sadInt'], happyInt: widget.IndexWat == 2 ? widget.sumInt : data['happyInt'], sumInt: sum.toInt(), loveInt: widget.IndexWat == 3 ? widget.sumInt : data['loveInt'] );
        await FlutterSession().set('myjai', myJai);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความโกรธ",jaiIcon: "assets/emotion/angry.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
         print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 1){
        double sum = ((widget.sumInt + data['angryInt'] + data['happyInt'] + data['relexInt'])/4);
        SessionJai myJai = SessionJai(relexInt:data['relexInt'], angryInt:widget.IndexWat == 0 ? widget.sumInt : data['angryInt'], sadInt: widget.IndexWat == 1 ? widget.sumInt : data['sadInt'], happyInt: widget.IndexWat == 2 ? widget.sumInt : data['happyInt'], sumInt: sum.toInt(), loveInt: widget.IndexWat == 3 ? widget.sumInt : data['loveInt'] );
        await FlutterSession().set('myjai', myJai);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความเหงา",jaiIcon: "assets/emotion/opensad.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 2){
        double sum = ((widget.sumInt + data['sadInt'] + data['angryInt'] + data['relexInt'])/4);
        SessionJai myJai = SessionJai(relexInt:data['relexInt'], angryInt:widget.IndexWat == 0 ? widget.sumInt : data['angryInt'], sadInt: widget.IndexWat == 1 ? widget.sumInt : data['sadInt'], happyInt: widget.IndexWat == 2 ? widget.sumInt : data['happyInt'], sumInt: sum.toInt(), loveInt: widget.IndexWat == 3 ? widget.sumInt : data['loveInt'] );
        await FlutterSession().set('myjai', myJai);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความสดใส",jaiIcon: "assets/emotion/openhappy.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 3){
        double sum = ((data['happyInt'] + data['sadInt'] + data['angryInt'] + data['relexInt'])/4);
        SessionJai myJai = SessionJai(relexInt:data['relexInt'], angryInt:widget.IndexWat == 0 ? widget.sumInt : data['angryInt'], sadInt: widget.IndexWat == 1 ? widget.sumInt : data['sadInt'], happyInt: widget.IndexWat == 2 ? widget.sumInt : data['happyInt'], sumInt: sum.toInt() , loveInt: widget.IndexWat == 3 ? widget.sumInt : data['loveInt']);
        await FlutterSession().set('myjai', myJai);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความหลงรัก",jaiIcon: "assets/emotion/kissing.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }


    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });



    await FlutterSession().get("expJai").then((val) async {
      print("Show::Start ExpJai");
        dynamic data =  val;
        print("Null ::: EXPJAI");
        SessionExp myJai = SessionExp(
            relexDay:data['relexDay'],
            angryDay:widget.IndexWat == 0 ? DateFormat.E().format(DateTime.now()) : data['angryDay'],
            sadDay:widget.IndexWat == 1 ? DateFormat.E().format(DateTime.now()) : data['sadDay'],
            happyDay: widget.IndexWat == 2 ? DateFormat.E().format(DateTime.now()) :data['happyDay'],
            loveDay: widget.IndexWat == 3 ? DateFormat.E().format(DateTime.now()) : data['loveDay'],
            expInt: data['expInt']+5
        );
        //SessionJai myJai = SessionJai(relexInt:0, angryInt: 0, sadInt: 0, happyInt: 0,loveInt: 0, sumInt: 0);
        await FlutterSession().set('expJai', myJai);

    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });

  }
  String nameTopic = "";
  Topic topic = Topic();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0,end: widget.sumInt.toDouble()).animate(progressController)..addListener((){
      setState(() {
      });
    });
    progressController.forward();

    if(widget.sumInt > 90){
      setState(() {
        text = "${listJai[widget.IndexWat].text1}";
      });
    }else if(widget.sumInt <=90 && widget.sumInt > 70){
      setState(() {
        text = "${listJai[widget.IndexWat].text2}";
      });
    }else if(widget.sumInt <= 70 && widget.sumInt > 50){
      setState(() {
        text = "${listJai[widget.IndexWat].text3}";
      });
    }else{
      setState(() {
        text = "${listJai[widget.IndexWat].text4}";
      });
    }

    if(widget.IndexWat == 0){
      nameTopic = "แผ่เมตตาให้ใจเป็นสุข";
      topic = Topic(
          id:15,
          categoryId:1,
          lessonId:4,
          topicName: "เมตตา",
          topicDetail: "แผ่เมตตาให้ใจเป็นสุข",
          topicPhoto: "https://i.ibb.co/ZV7WSNk/15.png",
          topicTime: 0,
          topicCount: 4,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 1){
      nameTopic = "ดึงสติ";
      topic = Topic(
          id:17,
          categoryId:5,
          lessonId:2,
          topicName: "ดึงสติ",
          topicDetail: "หัดดึงสติมาไว้กับตัวเราเอง",
          topicPhoto: "https://i.ibb.co/9V56W4N/17.png",
          topicTime: 0,
          topicCount: 3,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 2){
      nameTopic = "ทำใจให้สบาย";
      topic = Topic(
          id:5,
          categoryId:3,
          lessonId:1,
          topicName: "ทำใจให้สบาย",
          topicDetail: "มาทำใจให้สบายจากเรื่องราวต่าง ๆ",
          topicPhoto: "https://i.ibb.co/L5rPCqd/05.png",
          topicTime: 0,
          topicCount: 4,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 3){
      nameTopic = "ปล่อยใจจากความรัก";
      topic = Topic(
          id:9,
          categoryId:1,
          lessonId:5,
          topicName: "ปล่อยใจจากความรัก",
          topicDetail: "ปล่อยวางใจให้พ้นจากความผูกพันต่างๆ",
          topicPhoto: "https://i.ibb.co/Jsz6m98/09.png",
          topicTime: 0,
          topicCount: 7,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }

    Future(() {
      _updateJai(context);
    });
  }
  Color bgText(){
    if(widget.sumInt > 90){
      return Colors.red;
    }else if(widget.sumInt <=90 && widget.sumInt > 70){
      return Colors.amberAccent;
    }else if(widget.sumInt <= 70 && widget.sumInt > 50){
      return Colors.teal;
    }else{
      return Colors.brown;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //appBar: AppBar(
        //title: Text('SHOW JAI'),
      //),
      body: Column(
        //padding: EdgeInsets.all(16.0),
        children:<Widget>[
         // Text("Show ${animation != null ? animation.value.toInt() : 0}%:: ${text}"),

              Container(
                  height: MediaQuery.of(context).size.height/1.2 ,
                  width: MediaQuery.of(context).size.width/1 ,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        //width: (MediaQuery.of(context).size.width/2)-25,
                         // margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                        width:(MediaQuery.of(context).size.width/3),
                          height: (MediaQuery.of(context).size.width/3),
                          //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                          decoration: BoxDecoration(
                            //color: Color(0xFF5ec8c7),
                              color: bgText(),
                              borderRadius: BorderRadius.circular(200),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0,21),
                                    blurRadius: 53,
                                    color: Colors.black.withOpacity(0.05)
                                )
                              ]
                          ),
                          alignment: Alignment.center,
                          child:Text("${animation != null ? animation.value.toInt() : 0}%",textScaleFactor: 2.5,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                      //Image(image: AssetImage("assets/emotion/openhappy.png"),width: 100,height: 100,),
                      SizedBox(height: 30,),
                      Text("${text}",textScaleFactor: 2.0,textAlign: TextAlign.center,style:TextStyle(height: 1.2))
                    ],
                  )
              ),
              RaisedButton(
                onPressed: (){
                  //_shuffleQuestions(0);
                  //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me(text_profile:widget.text_profile)), (Route<dynamic> route) => false);

                },
                child: Text('กลับหน้าหลัก',textScaleFactor: 1.4,),
              ),


        ],
      ),
    );
  }
}



class SessionJai {
  final int relexInt;
  final int angryInt;
  final int sadInt;
  final int happyInt;
  final int loveInt;
  final int sumInt;

  SessionJai({this.relexInt, this.angryInt, this.sadInt, this.happyInt , this.loveInt, this.sumInt});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["relexInt"] = relexInt;
    data["angryInt"] = this.angryInt;
    data["sadInt"] = this.sadInt;
    data["happyInt"] = this.happyInt;
    data["loveInt"] = this.loveInt;
    data["sumInt"] = this.sumInt;
    return data;
  }
}




class SessionEQ {
  final int jealousInt;
  final int challengeInt;
  final int confidenceInt;
  final int openInt;
  final int sumInt;

  SessionEQ({this.jealousInt, this.challengeInt, this.confidenceInt, this.openInt , this.sumInt});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["jealousInt"] = jealousInt;
    data["challengeInt"] = this.challengeInt;
    data["confidenceInt"] = this.confidenceInt;
    data["openInt"] = this.openInt;
    data["sumInt"] = this.sumInt;
    return data;
  }
}

class SessionExp {
  final String relexDay;
  final String angryDay;
  final String sadDay;
  final String happyDay;
  final String loveDay;
  final int expInt;
  final String jealousDay;
  final String challengeDay;
  final String confidenceDay;
  final String openDay;


  SessionExp({this.relexDay, this.angryDay, this.sadDay, this.happyDay , this.loveDay, this.expInt ,this.jealousDay, this.challengeDay , this.confidenceDay,this.openDay});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["relexDay"] = relexDay;
    data["angryDay"] = this.angryDay;
    data["sadDay"] = this.sadDay;
    data["happyDay"] = this.happyDay;
    data["loveDay"] = this.loveDay;
    data["expInt"] = this.expInt;
    data["jealousDay"] = this.jealousDay;
    data["challengeDay"] = this.challengeDay;
    data["confidenceDay"] = this.confidenceDay;
    data["openDay"] = this.openDay;
    return data;
  }
}



class Jai {
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  Jai({this.text1, this.text2, this.text3, this.text4});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["text1"] = this.text1;
    data["text2"] = this.text2;
    data["text3"] = this.text3;
    data["text4"] = this.text4;
    return data;
  }
}


class EQ {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;

  EQ({this.text1, this.text2, this.text3, this.text4, this.text5});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["text1"] = this.text1;
    data["text2"] = this.text2;
    data["text3"] = this.text3;
    data["text4"] = this.text4;
    data["text5"] = this.text5;
    return data;
  }
}










class WatRelex extends StatefulWidget{
  WatRelex({Key key, @required this.text_profile}) : super(key: key);
  final text_profile;

  @override
  _WatRelexState createState() => _WatRelexState();
}

class _WatRelexState extends State<WatRelex> {
  List<Awake> awakes;
  int intKnow=2;
  int intRelex=5;
  String rateName;
  String problem;
  String howto;
  int rateInt;
  int sumInt;
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
  static DataApr DatabaseApr = DataApr();
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
  bool Saved = false;

  //final Reward data;

  //LikeMusic({@required this.data});
  Color bgText(){
    if( sumInt > 90){
      return Colors.red;
    }else if(sumInt <=90 &&  sumInt > 70){
      return Colors.amberAccent;
    }else if( sumInt <= 70 &&  sumInt > 50){
      return Colors.teal;
    }else{
      return Colors.brown;
    }
  }



  Future<void> _updateJai(context) async {
    await FlutterSession().get("myjai").then((val) async {
      dynamic data =  val;
        double sum = ((data['happyInt'] + data['sadInt'] + data['angryInt'] + sumInt)/4);
        SessionJai myJai = SessionJai(relexInt:sumInt, angryInt:  data['angryInt'], sadInt:  data['sadInt'], happyInt:  data['happyInt'], sumInt: sum.toInt() , loveInt:  data['loveInt']);
        await FlutterSession().set('myjai', myJai);

    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });
  }




  @override
  Widget build(BuildContext context) {
    int savewave = (intRelex*7)*(intKnow*5);
    savewave is int;
    savewave is double;
    int c;
    c = savewave ~/ 100;
    return  Scaffold(
        appBar: AppBar(
          //title: Text(''),
          //backgroundColor: ThemeNew,

          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          iconTheme:   IconThemeData(
                color: ThemeNew),
        ),
        //backgroundColor: ThemeNew6,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top:10),
          child: Saved ?
          Column(
            children: <Widget>[
          Container(
          height: MediaQuery.of(context).size.height/1.5 ,
            width: MediaQuery.of(context).size.width/1 ,
            padding: EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.center,
            child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [

               Container(
                //width: (MediaQuery.of(context).size.width/2)-25,
                // margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                  width:(MediaQuery.of(context).size.width/3),
                  height: (MediaQuery.of(context).size.width/3),
                  //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  decoration: BoxDecoration(
                    //color: Color(0xFF5ec8c7),
                      color: bgText(),
                      borderRadius: BorderRadius.circular(200),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,21),
                            blurRadius: 53,
                            color: Colors.black.withOpacity(0.05)
                        )
                      ]
                  ),
                  alignment: Alignment.center,
                  child:Text("${sumInt}%",textScaleFactor: 3.5,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
              SizedBox(height: 15,),

              Text("${rateName}",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 2.6,),
              SizedBox(height: 10,),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,21),
                            blurRadius: 53,
                            color: Colors.black.withOpacity(0.05)
                        )
                      ]
                  ),
                  child: Column(
                    children: <Widget>[
                      Text("สิ่งที่พบอยู่",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textScaleFactor: 2.2,),
                      Text("${problem}",style: TextStyle(color: Colors.black87,fontSize: 14),textScaleFactor: 2.0,),
                      SizedBox(height: 10,),
                      Text("แนวทางการพัฒนา",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textScaleFactor: 2.2,),
                      Text("${howto}",style: TextStyle(color: Colors.black87,fontSize: 14),textScaleFactor: 2.0,),
                    ],
                  )
              ),
              ])),
              SizedBox(height: 40,),


              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                      color: ThemeNew4,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,21),
                            blurRadius: 53,
                            color: Colors.black.withOpacity(0.05)
                        )
                      ]
                  ),
                  child:FlatButton(
                    child: Column(
                      children: <Widget>[
                        Text("กลับหน้าแรก",textScaleFactor: 2.2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onPressed: () {
                      //Navigator.of(context)
                      Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me(text_profile: widget.text_profile,)), (Route<dynamic> route) => false);

                    //  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                      //showPopup(context, SaveAwakePlay(), 'บันทึกการนั่ง');
                    },
                  )),
            ],
          )
              : Column(
            children: <Widget>[
/*              Padding(
                  padding: EdgeInsets.only(left:MediaQuery.of(context).size.width-70,right: 30),
                  child:FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration:  BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,21),
                                blurRadius: 53,
                                color: Colors.black.withOpacity(0.07)
                            )
                          ]
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child:  const Text('?', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => awakeShow(),
                        ),
                      );
                    },
                  )
              ),*/
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
                      Text("สติ คือ การตื่นตัวภายใน",textScaleFactor: 2.4,),
                      Text("บันทึกระดับสติในการนั่งสมาธิ",textScaleFactor: 1.6,style: TextStyle(color: Colors.black45),),
                    ],
                  )
              ),
              SizedBox(height: 40,),
              Text(textKnow[intKnow],textScaleFactor: 2.4,),
              SizedBox(height: 5,),

              Image(image: AssetImage('assets/know/${intKnow}.png'),width: 100,height: 100,),
              SizedBox(height: 30,),

              Padding(
                  padding: const EdgeInsets.only(right:80,left:80),
                  child:SliderTheme(
                      data: SliderThemeData(
                          thumbColor: ThemeNew,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child:Slider(
                          value: intKnow.toDouble(),
                          onChanged: (newValue){
                            setState(() => intKnow = newValue.toInt());
                          },
                          activeColor:ThemeNew,
                          min:0,
                          max:5
                      ))),
              SizedBox(height: 60,),

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
                      Text("สบาย คือ สุขขั้นแรก",textScaleFactor: 2.4),
                      Text("บันทึกระดับความสบายในการนั่งสมาธิ",textScaleFactor: 1.6,style: TextStyle(color: Colors.black45),),
                    ],
                  )
              ),


              SizedBox(height: 40,),
              Text(textRelex[intRelex],textScaleFactor: 2.4,),
              SizedBox(height: 5,),

              Image(image: AssetImage('assets/relex/${intRelex}.png'),width: 100,height: 100,),
              SizedBox(height: 30,),
              Padding(
                  padding: const EdgeInsets.only(right:80,left:80),
                  child:SliderTheme(
                    data: SliderThemeData(
                        thumbColor: ThemeNew,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                    child:Slider(
                        value: intRelex.toDouble(),
                        onChanged: (newValue){
                          setState(() => intRelex = newValue.toInt());
                        },
                        activeColor:ThemeNew,
                        min:0,
                        max:10
                    ),)),

              SizedBox(height: 60,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,//Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    decoration: BoxDecoration(
                        color: ThemeNew,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0,21),
                              blurRadius: 53,
                              color: Colors.black.withOpacity(0.05)
                          )
                        ]
                    ),
                    child:FlatButton(
                        textColor: Colors.white,
                        child: Text(
                          'วัดความนิ่ง',
                          textScaleFactor: 2.0,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          dataShow='SUCCESS';

                          user=await datebaseHelper.getUser(1);




                          //dataShow=user.name;
                         // awakes=await datebaseHelper.awakes();
                          Saved = true;
                          //print(await datebaseHelper.rewards());
                          //var re = user.intExp+5;


                         // print(awakes);
                          sumInt = c+(intRelex*7);

                          await DatabaseApr.saveJai(HisJai(id: null,jai: "ความนิ่ง",jaiIcon: "assets/emotion/smile.png",jaiInt:sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
                    //      print(await DatabaseApr.historyJais());


                          if (intKnow <= 2 && intKnow >= 0) {
                            if (intRelex <= 2 && intRelex >= 0) {
                              rateInt = 1;
                              rateName = "เส้นติด";
                              problem =
                              "เส้นติด เส้นตึงจากการนั่งท่าที่ไม่ได้มาตรฐาน หรือ\nมีความอยากมากจนเกินเป็นความฟุ้งซ่าน อีกทั้งยังร่างกายพักผ่อนไม่เพียงพอ";
                              howto =
                              "อย่าเพิ่งรีบนั่ง ให้ผ่อนคลายบริหารร่างกายเสียก่อน\nเพราะถ้าร่างกายไม่สบายก็ยากที่ใจจะสบายได้ อีกทั้งต้องพักผ่อนให้เพียงพอ\nหมั่นออกกำลังกายให้พอดีเพื่อให้เลือดเกิดการไหลเวียนที่ดีและบริโภคอาหารแต่พอดี";
                            } else if (intRelex <= 4 && intRelex > 2) {
                              rateInt = 2;
                              rateName = "เผลอ";
                              problem =
                              "เผลอใช้ความพยายามในการนั่งโดยไม่รู้ตัว\nกับคาดหวังผลที่จะได้จากการนั่ง\nหรือไม่ก็เกิดจากการบริโภคอาหารที่มากเกินไปจนรู้สึกไม่สบายตัว";
                              howto =
                              "ผ่อนคลายโดยการลืมตามาดูภาพวิวทิวทิศน์\nหรือเปลี่ยนอิริยาบถในท่าที่สบายแล้วค่อยกลับมานั่งใหม่\nอีกทั้งต้องพักผ่อนให้เพียงพอ หมั่นออกกำลังกายให้พอดีเพื่อให้เลือดเกิดการไหลเวียนที่ดีและบริโภคอาหารแต่พอดี";
                            } else if (intRelex <= 6 && intRelex > 4) {
                              rateInt = 3;
                              rateName = "ฟุ้งหลับ";
                              problem =
                              "เผลอฟุ้งซ่านถึงเรื่องราวคน สัตว์ สิ่งของจนใจรู้สึกเหนื่อย\nส่งผลให้ร่างกายเพลียเพราะใช้พลังงานไปกับการคิดจนเผลอหลับไป";
                              howto =  "จับอารมณ์สบายให้ได้\nเน้นให้มีความสุขที่เกิดจากสมาธิก่อน\nให้การเห็นภาพภายในเป็นเรื่องรอง และพักผ่อนให้เพียงพอ\nหมั่นออกกำลังกายให้พอดีเพื่อให้เลือดเกิดการไหลเวียนที่ดีกับบริโภคอาหารแต่พอดี";

                            } else if (intRelex <= 8 && intRelex > 6) {
                              rateInt = 4;
                              rateName = "เผลอสติ";
                              problem =
                              "เป็นอาการเผลอสติเป็นครั้งคราว\nเนื่องจากขาดการประคองสตินอกรอบ\nหรือไม่ก็เพราะร่างกายพักผ่อนไม่เพียงพอกับบริโภคอาหารเยอะเกินไป";
                              howto =
                              "ปรับใจให้สบายอย่างต่อเนื่อง โดยการทำใจนิ่ง ๆ ว่าง ๆ เบาๆ\nอีกทั้งต้องพักผ่อนให้เพียงพอ หมั่นออกกำลังกายให้พอดี\nเพื่อให้เลือดเกิดการไหลเวียนที่ดีกับบริโภคอาหารแต่พอดี";
                            } else if (intRelex <= 10 && intRelex > 8) {
                              rateInt = 5;
                              rateName = "พักน้อย";
                              problem =
                              "พักผ่อนไม่เพียงพอ , นั่งท่าที่ไม่ได้มาตรฐาน , กินเยอะ , ไม่ออกกำลังกาย";
                              howto =
                              "ปรับท่านั่งให้เป็นมาตรฐาน ไม่ให้สบายเกินไป\nอีกทั้งต้องพักผ่อนให้เพียงพอ หมั่นออกกำลังกายให้พอดี\nเพื่อให้เลือดเกิดการไหลเวียนที่ดีกับบริโภคอาหารแต่พอด";
                            } else if (intRelex > 10) {
                              rateInt = 6;
                              rateName = "ตกภวังค์";
                              problem =
                              "สติหลุด ตกสู่ภวังค์ สมาธิยังไม่สมบูรณ์ เลยเป็นสาเหตุให้ไม่สามารถรู้สึกตัวได้";
                              howto =
                              "ฝึกการประคองสติด้วยการภาวนา หรือนึกภาพนำใจให้เป็นกุศล\nอีกทั้งต้องพักผ่อนให้เพียงพอ หมั่นออกกำลังกายให้พอดี\nเพื่อให้เลือดเกิดการไหลเวียนที่ดี\nกับบริโภคอาหารแต่พอดี";
                            }
                          } else if (intKnow <= 4 && intKnow > 2) {
                            if (intRelex <= 2 && intRelex >= 0) {
                              rateInt = 7;
                              rateName = "ใจขุ่น";
                              problem =
                              "ไม่มีการเตรียมใจให้พร้อมก่อนนั่ง ติดการใช้ความพยายามมาจากเรื่องงาน\nหรือใจมีเรื่องขุ่นมัวไม่สบายใจอันเกิดจากการจับผิด มุ่งร้ายคนอื่น";
                              howto =
                              "เปลี่ยนอิริยาบถโดยการออกไปเดินผ่อนคลายกับธรรมชาติ\nหรือย้ายที่นั่งในที่เงียบ ๆ สงบ ๆ กลางธรรมชาติ";
                            } else if (intRelex <= 4 && intRelex > 2) {
                              rateInt = 8;
                              rateName = "เผลอคิด";
                              problem =
                              "ใช้ความคิดนำไปก่อน , มีความรู้สึกอยากให้ดีเหมือนเดิมหรือดีกว่าเดิม, เผลอใช้ความพยายามในการนั่ง";
                              howto =  "ถ้ามีอาการตื้อ ๆ แสดงว่าตึงแล้ว ให้ลืมตาขึ้น\nเริ่มต้นใหม่ ปรับให้สบาย ผ่อนคลายโดยการลืมตามดูภาพวิวทิวทัศน์";
                            } else if (intRelex <= 6 && intRelex > 4) {
                              rateInt = 9;
                              rateName = "ปล่อยใจ";
                              problem =
                              "ปล่อยใจไปติดในเรื่องราวต่าง ๆ ใจออกห่างจากสมาธิ หมดกำลังใจในการนั่ง มีความประมาท";
                              howto =
                              "เอาใจกลับมาอยู่กับตัว โดยการปล่อยวางและพิจารณาโลก\nตามความเป็นจริงจนเกิดการคลายความผูกพัน หรือระลึกถึงความตาย";

                            } else if (intRelex <= 8 && intRelex > 6) {
                              rateInt = 10;
                              rateName = "ประมาท";
                              problem =
                              "ประมาท นอกรอบปล่อยใจ ให้ฟุ้งซ่าน หรือมีความเพียร จัดเกินไป";
                              howto =
                              "รักษาอารมณ์ดี อารมณ์เดียว ให้ได้ตลอดทั้งวัน\nไม่ประมาท ไม่คุยเรื่องที่ชวนขุ่นมัวใจ";
                            } else if (intRelex <= 10 && intRelex > 8) {
                              rateInt = 11;
                              rateName = "ตื่นเต้น";
                              problem =
                              "เมื่อมีประสบการณ์ภายในเกิดขึ้น ก็มีเผลอเกิดความตื่นเต้น ยินดีในประสบการณ์นั้น เนื่องจากฟังมาก่อน";
                              howto =
                              "ให้ลืมในสิ่งที่เคยได้ยินได้ฟังมา\nอย่าคิดนำว่าจะมีอะไรเกิดขึ้นต่อไป\nให้เริ่มต้นจากจุดที่ง่าย ๆ สบาย ๆ ก่อน \nไม่คาดหวังอะไรจากสมาธิ";
                            } else if (intRelex > 10) {
                              rateInt = 12;
                              rateName = "ใจสงบ";
                              problem =
                              "ใจสงบ เริ่มปลอดกังวล เป็นหนึ่งเดียวกับธรรมชาติ";
                              howto =
                              "ประคับประคองสติให้ต่อเนื่องยาวนานขึ้นผ่านการนึกภาพดวงแก้วหรือภาพที่เป็นกุศล";
                            }
                          } else if (intKnow <= 6 && intKnow > 4) {
                            if (intRelex <= 2 && intRelex >= 0) {
                              rateInt = 13;
                              rateName = "ใจร้อน";
                              problem =
                              "เส้นติด เส้นตึง, มีความอยากมาก ใจร้อน , บังคับภาพ, กดลูกนัยน์ตา , ใช้กำลังในการบริกรรม";
                              howto =
                              "ถ้ามีอาการตื้อ ๆ แสดงว่าตึงแล้ว ให้ลืมตาขึ้น\nเริ่มต้นใหม่ ปรับให้สบาย ผ่อนคลายโดยการลืมตามดูภาพวิวทิวทัศน์";
                            } else if (intRelex <= 4 && intRelex > 2) {
                              rateInt = 14;
                              rateName = "พักน้อย";
                              problem =
                              "ร่างกายพักผ่อนไม่เพียงพอ หรือบริโภคอาหารมากเกินไป";
                              howto =
                              "เปลี่ยนสภาพแวดล้อมใหม่ โดยการหาที่โล่ง ๆ\nอากาศถ่ายเท เพื่อให้ร่างกายปลอดโปร่ง หายใจสะดวก";
                            } else if (intRelex <= 6 && intRelex > 4) {
                              rateInt = 15;
                              rateName = "นอนน้อย";
                              problem =
                              "ร่างกายพักผ่อนไม่เพียงพอ หรือบริโภคอาหารมากเกินไป";
                              howto =  "พักผ่อนให้เพียงพอ หมั่นออกกำลังกายให้พอดี\nเพื่อให้เลือดเกิดการไหลเวียนที่ดีกับบริโภคอาหารแต่พอดี";

                            } else if (intRelex <= 8 && intRelex > 6) {
                              rateInt = 16;
                              rateName = "เริ่มนิ่ง";
                              problem =
                              "ใจเริ่มนิ่งในระดับหนึ่งแล้ว";
                              howto =
                              "หมั่นประคองสติด้วยการนึกภาพที่เป็นกุศล\nหรือด้วยการภาวนาอย่างสม่ำเสมอ";
                            } else if (intRelex <= 10 && intRelex > 8) {
                              rateInt = 17;
                              rateName = "กลมกลืน";
                              problem =
                              "ใจนิ่งจนกลมกลืนไปกับธรรมชาติโดยรอบ";
                              howto =
                              "หมั่นประคองสติด้วยการนึกภาพที่เป็นกุศล\nหรือด้วยการภาวนาอย่างสม่ำเสมอ";
                            } else if (intRelex > 10) {
                              rateInt = 18;
                              rateName = "นิ่งแน่น";
                              problem =
                              "ใจนิ่งถูกส่วน นิ่งแน่น";
                              howto =
                              "หมั่นประคองสติด้วยการนึกภาพที่เป็นกุศล\nหรือด้วยการภาวนาอย่างสม่ำเสมอ";
                            }
                          }
                          setState((){});
                          _updateJai(context);
                          /*setState(() async {
          dataShow:await datebaseHelper.users().toString();
        });*/
                        }
                    ),),

                ],
              ),

              //Text('Awakes : ${awakes}'),

              SizedBox(height: 50,),
            ],
          ),
        ));
  }
}







class ShowEQ extends StatefulWidget{
  ShowEQ({Key key, @required this.sumInt, this.IndexWat, this.text_profile}) : super(key: key);
  final int sumInt;
  final int IndexWat;
  final text_profile;
  @override
  _ShowEQState createState() => _ShowEQState();
}

class _ShowEQState extends State<ShowEQ> with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation animation;
  String text = "";
  List<String> list1 = [
    "1",
    "2"
  ];
  List<EQ> listEQ = [
    EQ(
      text1: "มีความอิจฉาน้อยมากและมีความพึงพอใจในสิ่งที่มีสูงมาก",
      text2: "มีความอิจฉาน้อย มีความพึงพอใจในสิ่งที่มีสูง",
      text3: "มีความอิจฉาและมีความพึงพอใจในสิ่งที่มีปานกลาง",
      text4: "มีความอิจฉาสูง มีความพึงพอใจในสิ่งที่มีน้อย",
      text5: "มีความอิจฉาเยอะมาก มีความพึงพอใจในสิ่งที่มีน้อยมาก",
    ),
    EQ(
      text1: "คุณชอบความท้าทายมาก",
      text2: "คุณชอบความท้าทายพอสมควร",
      text3: "คุณชอบความท้าทายในระดับสูงกว่าปกติหน่อยๆ",
      text4: "คุณชอบความท้าทายในระดับปกติ",
      text5: "คุณมีความขี้ขลาดมากกว่าท้าทาย",
    ),
    EQ(
      text1: "คุณมีความเชื่อมั่นในตัวเองมากทีเดียว",
      text2: "คุณมีความเชื่อมั่นในตัวเองมากพอควร",
      text3: "คุณมีความเชื่อมั่นในตัวเองในระดับปกติ",
      text4: "คุณมีความเชื่อมั่นในตัวเองน้อย",
      text5: "คุณมีความเชื่อมั่นในตัวเองน้อยมาก",
    ),
    EQ(
      text1: "คุณเป็นคนเปิดเผยอย่างมาก",
      text2: "คุณเป็นคนเปิดเผยพอสมควร",
      text3: "คุณเป็นคนเปิดเผยในระดับทั่วไป",
      text4: "คุณเป็นคนปิดตัวเองหน่อยๆ",
      text5: "คุณเป็นคนปิดตัวเอง",
    ),
  ];

  static DataApr DatabaseApr = DataApr();
  Future<void> _updateJai(context) async {
    await FlutterSession().get("myeq").then((val) async {
      dynamic data =  val;
      if(widget.IndexWat == 0){
        double sum = ((widget.sumInt + data['challengeInt'] + data['confidenceInt'] + data['openInt'])/4);
        SessionEQ myEQ = SessionEQ( jealousInt:widget.IndexWat == 0 ? widget.sumInt : data['jealousInt'], challengeInt: widget.IndexWat == 1 ? widget.sumInt : data['challengeInt'], confidenceInt: widget.IndexWat == 2 ? widget.sumInt : data['confidenceInt'], sumInt: sum.toInt(), openInt: widget.IndexWat == 3 ? widget.sumInt : data['openInt'] );
        await FlutterSession().set('myeq', myEQ);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความน้อยเนื้อต่ำใจ",jaiIcon: "assets/emotion/shy.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 1){
        double sum = ((widget.sumInt + data['jealousInt'] + data['confidenceInt'] + data['openInt'])/4);
        SessionEQ myEQ = SessionEQ( jealousInt:widget.IndexWat == 0 ? widget.sumInt : data['jealousInt'], challengeInt: widget.IndexWat == 1 ? widget.sumInt : data['challengeInt'], confidenceInt: widget.IndexWat == 2 ? widget.sumInt : data['confidenceInt'], sumInt: sum.toInt(), openInt: widget.IndexWat == 3 ? widget.sumInt : data['openInt'] );
        await FlutterSession().set('myeq', myEQ);
      await DatabaseApr.saveJai(HisJai(id: null,jai: "ความกล้า",jaiIcon: "assets/emotion/cool.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
      print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 2){
        double sum = ((widget.sumInt + data['jealousInt'] + data['challengeInt'] + data['openInt'])/4);
        SessionEQ myEQ = SessionEQ( jealousInt:widget.IndexWat == 0 ? widget.sumInt : data['jealousInt'], challengeInt: widget.IndexWat == 1 ? widget.sumInt : data['challengeInt'], confidenceInt: widget.IndexWat == 2 ? widget.sumInt : data['confidenceInt'], sumInt: sum.toInt(), openInt: widget.IndexWat == 3 ? widget.sumInt : data['openInt'] );
        await FlutterSession().set('myeq', myEQ);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความเชื่อมั่น",jaiIcon: "assets/emotion/goofy.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }else if(widget.IndexWat == 3){
        double sum = ((widget.sumInt + data['jealousInt'] + data['challengeInt'] + data['confidenceInt'])/4);
        SessionEQ myEQ = SessionEQ( jealousInt:widget.IndexWat == 0 ? widget.sumInt : data['jealousInt'], challengeInt: widget.IndexWat == 1 ? widget.sumInt : data['challengeInt'], confidenceInt: widget.IndexWat == 2 ? widget.sumInt : data['confidenceInt'], sumInt: sum.toInt() , openInt: widget.IndexWat == 3 ? widget.sumInt : data['openInt']);
        await FlutterSession().set('myeq', myEQ);
        await DatabaseApr.saveJai(HisJai(id: null,jai: "ความเป็นกันเอง",jaiIcon: "assets/emotion/wink.png",jaiInt:widget.sumInt,jaiTime: new DateTime.now().millisecondsSinceEpoch));
        print(await DatabaseApr.historyJais());
      }


    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });



    await FlutterSession().get("expJai").then((val) async {
      print("Show::Start ExpJai");
      dynamic data =  val;
      print("Null ::: EXPJAI");
      SessionExp myJai = SessionExp(
          relexDay:data['relexDay'],
          angryDay:  data['angryDay'],
          sadDay: data['sadDay'],
          happyDay: data['happyDay'],
          loveDay:  data['loveDay'],
          expInt: data['expInt']+5,
          jealousDay:widget.IndexWat == 0 ? DateFormat.E().format(DateTime.now()) : data['jealousDay'],
          challengeDay:widget.IndexWat == 1 ? DateFormat.E().format(DateTime.now()) : data['challengeDay'],
          confidenceDay: widget.IndexWat == 2 ? DateFormat.E().format(DateTime.now()) :data['confidenceDay'],
          openDay: widget.IndexWat == 3 ? DateFormat.E().format(DateTime.now()) : data['openDay'],
      );
      //SessionJai myJai = SessionJai(relexInt:0, angryInt: 0, sadInt: 0, happyInt: 0,loveInt: 0, sumInt: 0);
      await FlutterSession().set('expJai', myJai);

    })
        .catchError((error, stackTrace) {
      // error is SecondError
      print("outer: $error");
    });

  }
  String nameTopic = "";
  Topic topic = Topic();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0,end: widget.sumInt.toDouble()).animate(progressController)..addListener((){
      setState(() {
      });
    });
    progressController.forward();

    if(widget.sumInt > 80){
      setState(() {
        text = "${listEQ[widget.IndexWat].text1}";
      });
    }else if(widget.sumInt <=80 && widget.sumInt > 60){
      setState(() {
        text = "${listEQ[widget.IndexWat].text2}";
      });
    }else if(widget.sumInt <= 60 && widget.sumInt > 50){
      setState(() {
        text = "${listEQ[widget.IndexWat].text3}";
      });
    }else if(widget.sumInt <= 50 && widget.sumInt > 40){
      setState(() {
        text = "${listEQ[widget.IndexWat].text4}";
      });
    }else{
      setState(() {
        text = "${listEQ[widget.IndexWat].text5}";
      });
    }
/*
    if(widget.IndexWat == 0){
      nameTopic = "แผ่เมตตาให้ใจเป็นสุข";
      topic = Topic(
          id:15,
          categoryId:1,
          lessonId:4,
          topicName: "เมตตา",
          topicDetail: "แผ่เมตตาให้ใจเป็นสุข",
          topicPhoto: "https://i.ibb.co/ZV7WSNk/15.png",
          topicTime: 0,
          topicCount: 4,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 1){
      nameTopic = "ดึงสติ";
      topic = Topic(
          id:17,
          categoryId:5,
          lessonId:2,
          topicName: "ดึงสติ",
          topicDetail: "หัดดึงสติมาไว้กับตัวเราเอง",
          topicPhoto: "https://i.ibb.co/9V56W4N/17.png",
          topicTime: 0,
          topicCount: 3,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 2){
      nameTopic = "ทำใจให้สบาย";
      topic = Topic(
          id:5,
          categoryId:3,
          lessonId:1,
          topicName: "ทำใจให้สบาย",
          topicDetail: "มาทำใจให้สบายจากเรื่องราวต่าง ๆ",
          topicPhoto: "https://i.ibb.co/L5rPCqd/05.png",
          topicTime: 0,
          topicCount: 4,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }else if(widget.IndexWat == 3){
      nameTopic = "ปล่อยใจจากความรัก";
      topic = Topic(
          id:9,
          categoryId:1,
          lessonId:5,
          topicName: "ปล่อยใจจากความรัก",
          topicDetail: "ปล่อยวางใจให้พ้นจากความผูกพันต่างๆ",
          topicPhoto: "https://i.ibb.co/Jsz6m98/09.png",
          topicTime: 0,
          topicCount: 7,
          topicView: 0,
          topicColor: "#000",
          topicBg: "#fff"
      );
      setState(() {});
    }
*/
    Future(() {
      _updateJai(context);
    });
  }
  Color bgText(){
    if(widget.sumInt > 80){
      return Colors.indigo;
    }else if(widget.sumInt <=80 && widget.sumInt > 60){
      return Colors.brown;
    }else if(widget.sumInt <= 60 && widget.sumInt > 50){
      return Colors.teal;
    }else if(widget.sumInt <= 50 && widget.sumInt > 40) {
      return Colors.amberAccent;
    }else{
      return Colors.red;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //appBar: AppBar(
      //title: Text('SHOW JAI'),
      //),
      body: Column(
        //padding: EdgeInsets.all(16.0),
        children:<Widget>[
          // Text("Show ${animation != null ? animation.value.toInt() : 0}%:: ${text}"),

          Container(
              height: MediaQuery.of(context).size.height/1.2 ,
              width: MediaQuery.of(context).size.width/1 ,
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //width: (MediaQuery.of(context).size.width/2)-25,
                    // margin:EdgeInsets.only(top: 10,bottom: 10,left: 0,right: 5) ,
                      width:(MediaQuery.of(context).size.width/3),
                      height: (MediaQuery.of(context).size.width/3),
                      //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                      decoration: BoxDecoration(
                        //color: Color(0xFF5ec8c7),
                          color: bgText(),
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,21),
                                blurRadius: 53,
                                color: Colors.black.withOpacity(0.05)
                            )
                          ]
                      ),
                      alignment: Alignment.center,
                      child:Text("${animation != null ? animation.value.toInt() : 0}%",textScaleFactor: 2.5,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                  //Image(image: AssetImage("assets/emotion/openhappy.png"),width: 100,height: 100,),
                  SizedBox(height: 30,),
                  Text("${text}",textScaleFactor: 1.6,textAlign: TextAlign.center,style:TextStyle(height: 1.2))
                ],
              )
          ),
          RaisedButton(
            onPressed: (){
              //_shuffleQuestions(0)ฝฝNavigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me(text_profile: widget.text_profile,)), (Route<dynamic> route) => false);

            },
            child: Text('กลับหน้าหลัก',textScaleFactor: 1.4,),
          ),
        /*  InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlayTmusic(todo:nameTopic,topic:topic)),
              );
            },
            child: Text("ฟัง..${nameTopic}..",textScaleFactor: 1.0,textAlign: TextAlign.center,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
          )*/

        ],
      ),
    );
  }
}