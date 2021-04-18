import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:page_transition/page_transition.dart';

import '../Me.dart';

class EditDetail extends StatefulWidget{
  EditDetail({Key key, this.detail, this.text_profile}) : super(key: key);
  final String detail;
  final text_profile;

  @override
  _EditDetailState createState() => _EditDetailState(detail, text_profile);
}


class _EditDetailState extends State<EditDetail> {
  _EditDetailState(this.detail, this.text_profile) ;

  final String detail;
  final text_profile;
  String Edit = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Edit = detail;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdf4ee),
      body:  SingleChildScrollView(
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
                  //SizedBox(height: 50,),
                  Text("${text_profile[8]}",textScaleFactor: 2.2,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),

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
                          decoration: InputDecoration.collapsed(hintText: "${Edit}"),
                          readOnly: false,
                          onChanged: (text) {
                            setState((){
                              Edit=text;
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
                        child:Text("Done",textScaleFactor: 2.2,style: TextStyle(color:Color(0xFFFFFFFF),fontWeight: FontWeight.bold),)),
                    onTap: () async {
                      await FlutterSession().set('user_detail', Edit);
                      Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.fade, child:Me(text_profile: text_profile,)), (Route<dynamic> route) => false);

                    },
                  ),


                ],
              )),
    );
  }
}
