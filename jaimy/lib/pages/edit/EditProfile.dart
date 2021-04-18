import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:aws_s3/aws_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import '../Me.dart';
class EditProfile extends StatefulWidget{
  EditProfile({Key key, this.profile , this.sex, this.text_profile}) : super(key: key);
  final String profile;
  final String sex;
  final text_profile;
  @override
  _EditProfileState createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {


  bool changeProfile = false;
  String profile='';
  String sex = 'man';
  String error = "";


  static DatabaseHelper datebaseHelper = DatabaseHelper();

  ImageProvider showProfile(String path){
    if(profile == '' || profile == 'NewProfile'){
      return AssetImage("assets/sex/${sex}.png");
    }else if(profile.length > 25){
      return NetworkImage(profile);
    }else{
      return NetworkImage("https://jaipunapp.s3-ap-southeast-1.amazonaws.com/profile/${profile}");
    }
  }

  String saveProfile(String profile){
    if(profile == '' || profile == 'NewProfile'){
      return  "assets/sex/${sex}.png";
    }else if(profile.length > 25){
      return profile;
    }else{
      return "https://jaipunapp.s3-ap-southeast-1.amazonaws.com/profile/${profile}";
    }
  }

  void initState() {
    super.initState();
    sex = widget.sex;
    profile =widget.profile;
    setState(() { });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Column(
        children: <Widget>[
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

          changeProfile ? Container(
            /* width: MediaQuery
                          .of(context)
                          .size
                          .width,*/
              alignment: Alignment.center,
              //padding: EdgeInsets.only(right: 20),
              height:  MediaQuery.of(context).size.width/2,
              child: Wrap(
                children: [
                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/7vSmcKz/1.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/7vSmcKz/1.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),
                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/jvtPJV1/4.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/jvtPJV1/4.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),

                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/gRvjWFk/6.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/gRvjWFk/6.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),



                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/pn3Thv0/5.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/pn3Thv0/5.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),


                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/mb6KWch/13.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/mb6KWch/13.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),



                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/cyWznX9/18.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/cyWznX9/18.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),


                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/bswTTXX/22.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/bswTTXX/22.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),




                  InkWell(
                      onTap: (){
                        changeProfile = false;
                        profile = "https://i.ibb.co/0MmMtzS/17.png";
                        setState(() {});
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width:60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("https://i.ibb.co/bswTTXX/22.png")
                                  ),
                                ), ),
                            ],
                          )
                      )
                  ),







                ],
              )) :InkWell(
              onTap: (){
                if(Platform.isAndroid){
                  _pickImage();
                  //changeProfile = true;
                  //setState(() {});
                }else{
                  _pickImage();
                }
              },
              child: Container(
                /* width: MediaQuery
                          .of(context)
                          .size
                          .width,*/
                alignment: Alignment.center,
                //padding: EdgeInsets.only(right: 20),
                height:  MediaQuery.of(context).size.width/2,
                child:  Container(
                  height:  MediaQuery.of(context).size.width/2,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:  showProfile(profile)
                      )
                  ),
                ),
              )

          ),




          Text("${changeProfile ? "เลือกโปรไฟล์ที่ตรงกับคุณ\n(Android ยังไม่รองรับการอัพโหลดภาพจากเครื่อง)" : "${widget.text_profile[5]}"}",textAlign: TextAlign.center,textScaleFactor: 1.4,style:TextStyle( color: Colors.black54)),
          SizedBox(height: 20,),
          RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              color:const Color(0xff1c2637),
              child: Text(
                'Done',
                textScaleFactor: 2.2,
                style: TextStyle(color:Colors.white),
              ),
              onPressed: () async {
                await datebaseHelper.getUser(1).then((value){
                  datebaseHelper.updateUser(User(
                    id: 1,
                    name: value.name,
                    profile: saveProfile(profile),
                    sex: value.sex,
                    age: value.age,
                    intExp: value.intExp,
                    intMinute: value.intMinute,
                    intListen: value.intListen,
                    intKnow:value.intKnow,
                    intRelex: value.intRelex,
                    intWave: value.intWave,
                    intMeditate: value.intMeditate,
                    intLesson: value.intLesson,
                    intEmotion:value.intEmotion,
                  ));
                });
                setState((){});

                Navigator.of(context).pushAndRemoveUntil(PageTransition(type: PageTransitionType.bottomToTop, child:Me(text_profile: widget.text_profile,)), (Route<dynamic> route) => false);
                //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                /*setState(() async {
  dataShow:await datebaseHelper.users().toString();
});*/
              }
          ),
          //Text("${error}",textScaleFactor: 2.0,)
        ],
      ),
    );
  }










  /*
  *
  *
  *  Start Upload Profile to S3
  *
  *
  *
   */






  Future<String> _uploadImage(File file, int number,
      {String extension = 'jpg'}) async {

    String result;

    if (result == null) {
      // generating file name
      String fileName =
          "$number$extension\_${DateTime.now().millisecondsSinceEpoch}.$extension";
      print("start upload");
      setState(() {
        error = "start upload";
      });




      /* if(Platform.isAndroid){
        String uploadedImageUrl = await AmazonS3Cognito.upload(
            file.path,
            "jaipunapp",
            "ap-southeast-1:cdab38e4-b642-446b-96e2-a01a3b72fb49",
            fileName,
            AwsRegion.AP_SOUTHEAST_1,
            AwsRegion.US_EAST_1);
        print(uploadedImageUrl);
        setState(() {
          profile = uploadedImageUrl;
        });
      }else{*/
      if(!Platform.isAndroid){
      AwsS3 awsS3 = AwsS3(
          awsFolderPath: "profile",
          file: file,
          fileNameWithExt: fileName,
          poolId: "ap-southeast-1:cdab38e4-b642-446b-96e2-a01a3b72fb49",
          region: Regions.AP_SOUTHEAST_1,
          bucketName: "jaipunapp");

      //setState(() => isFileUploading = true);
     displayUploadDialog(awsS3);

      try {
          try {
            result = await awsS3.uploadFile;
            debugPrint("Result :'$result'.");
            setState(() {
              profile = result;
            });
          } on PlatformException {
            debugPrint("Result :'$result'.");
          }

      } on PlatformException catch (e) {
        debugPrint("Failed :'${e.message}'.");
      }
      Navigator.of(context).pop();

      }else{
        try {
          setState(() {
            error = "Uploading";
          });
          firebase_storage.StorageReference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child('uploads/$fileName');
          firebase_storage.StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
          firebase_storage.StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          taskSnapshot.ref.getDownloadURL().then(
                (value) =>
                    setState(() {
                      profile = value;
                      error = "Done: $value";
                    }),
          );
          await firebase_storage.FirebaseStorage.instance
              .ref().child('uploads/$fileName')
              .putFile(file);
          setState(() {
            error = "Uploaded";
          });
        } on firebase_core.FirebaseException catch (e) {
          setState(() {
            error = "Error";
          });
          // e.g, e.code == 'canceled'
        }

      }


      //  }
    }
    return result;
  }

  Future displayUploadDialog(AwsS3 awsS3) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder(
        stream: awsS3.getUploadStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return buildFileUploadDialog(snapshot, context);
        },
      ),
    );
  }
  AlertDialog buildFileUploadDialog(
      AsyncSnapshot snapshot, BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: EdgeInsets.all(6),
        child: LinearProgressIndicator(
          value: (snapshot.data != null) ? snapshot.data / 100 : 0,
          valueColor:
          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorDark),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text('Uploading...')),
            Text("${snapshot.data ?? 0}%"),
          ],
        ),
      ),
    );
  }






  File imageFile;
  final picker = ImagePicker();



  Future<Null> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    if (imageFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 500,ratioY: 500),
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
            //minimumAspectRatio: 0.5,
            aspectRatioLockEnabled: true,
          ));
      if (croppedFile != null) {
        imageFile = croppedFile;
        _uploadImage(croppedFile,1);
      }
    }
  }



}
