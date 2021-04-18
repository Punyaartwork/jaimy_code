import 'package:JaiMy/utils/database_apr.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Me.dart';
class PostPage extends StatefulWidget{
  PostPage({Key key, this.analytics, this.observer, this.text_profile}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final text_profile;
  @override
  _PostState createState() => _PostState(analytics, observer, text_profile);
}


class _PostState extends State<PostPage> {
  _PostState(this.analytics, this.observer, this.text_profile);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final text_profile;
  String userId = "";
  String post = "";
  static DataApr DatabaseApr = DataApr();
  CollectionReference journaling = FirebaseFirestore.instance.collection('journaling');
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




  String emotion = "assets/emotion/happy.png";
  int indexEmotion = 0;


  void initState()  {
    super.initState();
    Future(() {
      _sendAnalyticsEvent();
      _startUserId(context);
    });
  }
  Future<void> _startUserId(context) async {
    await FlutterSession().get("token").then((val) async {
      setState(() {
        userId = val['token'];
      });
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'open_Post',
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdf4ee),
      body: SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(height: 60,),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.arrow_back,color: Colors.black54,size: 30,),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me()), (Route<dynamic> route) => false);

                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height/9,),
              Container(
                height: 60.0,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:jai.map((item) =>
                      InkWell(
                        splashColor: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Opacity(
                                opacity:(indexEmotion == jai.indexOf(item)) ? 1 :0.6,
                                child:  Image(image: AssetImage("${item}"),width: 30,height: 30,),),
                              Text("${jaiText[jai.indexOf(item)]}",textScaleFactor: 1.2,style:TextStyle(color:Colors.black54))
                            ],
                          ),
                        ),
                        onTap:  (){
                          setState(() {
                            emotion = item;
                            indexEmotion = jai.indexOf(item);
                          });
                        },
                      )
                  ).toList().cast<Widget>(),
                ),),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0,10),
                            blurRadius: 15,
                            color: Colors.black.withOpacity(0.08)
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(
                          //fontSize: 20.0,
                          height: 2.0,
                          color: Colors.black
                      ),
                      maxLines: 8,
                      autofocus: true,
                      decoration: InputDecoration.collapsed(hintText: ""),
                      readOnly: false,
                      onChanged: (text) {
                        setState((){
                          post=text;
                        });
                        print("First text field: $text");
                      },
                    ),
                  )
              ),


              InkWell(
                splashColor: Colors.transparent,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xff1c2637),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0,21),
                              blurRadius: 20,
                              color: Colors.black.withOpacity(0.05)
                          )
                        ]
                    ),
                    child:Text("${text_profile[9]}",textScaleFactor: 2.0,style: TextStyle(color:Color(0xFFFFFFFF),fontWeight: FontWeight.bold),)),
                onTap: () async {
                  await DatabaseApr.insertPost(
                    Post(
                      id: null,
                      post:post,
                      postEmotion: indexEmotion,
                      postPhoto: "",
                      postTime: new DateTime.now().millisecondsSinceEpoch
                    )
                  );
                  print(await DatabaseApr.posts() );

                  journaling
                      .add({
                    'userId':userId,
                    'post': post, // John Doe
                    'postEmotion': indexEmotion, // Stokes and Sons
                    'postPhoto': "",
                    'postTime':new DateTime.now().millisecondsSinceEpoch,
                    'postLike':0,
                  })
                      .then((value) => print("Post Added"))
                      .catchError((error) => print("Failed to add user: $error"));
                  Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.bottomToTop, child:Me(text_profile: text_profile,)), (Route<dynamic> route) => false);


                },
              ),


            ],
          )),
    );
  }
}
