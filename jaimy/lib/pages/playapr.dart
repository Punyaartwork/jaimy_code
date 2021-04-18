import 'dart:convert';
import 'package:JaiMy/screens/saveSitting.dart';
import 'package:http/http.dart' as http;
import 'package:JaiMy/models/tmusic.dart';
import 'package:JaiMy/utils/database_helper.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
class PlayApr extends StatefulWidget {

  final Audio audio;
  PlayApr({Key key, @required this.audio }) : super(key: key);
  @override
  PlayAprState createState() => PlayAprState();
}

class PlayAprState  extends State<PlayApr> {
  static DatabaseHelper datebaseHelper = DatabaseHelper();
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");
  AssetsAudioPlayer get _assetsAudioMusic => AssetsAudioPlayer.withId("sound");
  List<Audio> audios;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AudioSound().then((value) => setState((){audios=value;}));
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:AppBar(
       backgroundColor:Colors.transparent,
       bottomOpacity: 0.0,
       elevation: 0.0,
     ),
      backgroundColor: const Color(0xffB6D4ED),
      body: Stack(
        children: <Widget>[

          saveSitting(statusPlay: true),
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


          _assetsAudioPlayer.builderCurrent(
              builder: (context, playing) {
                if (playing == null) {
                  return SizedBox();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*0.0,
                        left: (MediaQuery.of(context).size.width-274)/2,
                        right: (MediaQuery.of(context).size.width-274)/2,
                      ),
                        width: MediaQuery.of(context).size.width*0.55,
                        height: MediaQuery.of(context).size.width*0.55,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:   NetworkImage(playing.audio.audio.metas.image.path)
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          color: const Color(0xffacd7da),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x2900747c),
                              offset: Offset(0, 20),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    Spacer(),

                    Text(
                          '${playing.audio.audio.metas.title}',
                          style: TextStyle(
                            color: const Color(0xffFFFFFF),
                            fontWeight: FontWeight.w700,
                          ),
                          textScaleFactor: 2.8,
                          textAlign: TextAlign.center,
                        ),
                    Text(
                          '${playing.audio.audio.metas.artist}',
                          style: TextStyle(
                            color: const Color(0xccFFFFFF),
                            fontWeight: FontWeight.w700,
                          ),
                          textScaleFactor: 2.2,
                          textAlign: TextAlign.center,
                        ),
                   Spacer(),

                   // SizedBox(height:  MediaQuery.of(context).size.height*0.03,),
                    _assetsAudioPlayer.builderCurrent(
                        builder: (context, playing) {
                          if (playing == null) {
                            return SizedBox();
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: _assetsAudioPlayer.builderLoopMode(
                                builder: (context, loopMode) {
                                  return PlayerBuilder.isPlaying(
                                      player: _assetsAudioPlayer,
                                      builder: (context, isPlaying) {
                                        return Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  _assetsAudioPlayer.toggleLoop();
                                                },
                                                child:
                                                _loopIcon(context,loopMode)),
                                            Spacer(),
                                            GestureDetector(
                                                onTap: () async{
                                                  if(audios.length != 0) {
                                                    showPopupIntro(context, SoundPlay(audios: audios,), '');
                                                  }
                                                },
                                                child:Icon(
                                                  Icons.waves,
                                                  size: 35,
                                                  color: const Color(0xff6487b6),
                                                )
                                            ),
                                            SizedBox(width:10),
                                            GestureDetector(
                                                onTap: () async{
                                                  print(playing.audio.audio.toString());
                                                  print(playing.audio.audio.path);
                                                  print(playing.audio.audio.metas.id);
                                                  print(playing.audio.audio.metas.title);
                                                  print(playing.audio.audio.metas.artist);
                                                  print(playing.audio.audio.metas.album);
                                                  print(playing.audio.audio.metas.image.path);
                                                  await datebaseHelper.likeMusic(
                                                      Musiclike(
                                                          playing.audio.audio.metas.id,
                                                          playing.audio.audio.path,
                                                          playing.audio.audio.metas.title,
                                                          playing.audio.audio.metas.image.path,
                                                          playing.audio.audio.metas.artist,
                                                          playing.audio.audio.metas.album
                                                      )
                                                  );
                                                  print(await datebaseHelper.musiclikes());
                                                  showAlertDialog(context);
                                                },
                                                child:
                                                _likeIcon(context))
                                          ],
                                        );
                                      });
                                }),
                          );
                        }
                    ),
                    SizedBox(height: 15,),

                    _assetsAudioPlayer.builderRealtimePlayingInfos(
                        builder: (context, infos) {
                          if (infos == null) {
                            return SizedBox();
                          }
                          return Column(
                            children: [
                              PositionSeekWidget(
                                currentPosition: infos.currentPosition,
                                duration: infos.duration,
                                seekTo: (to) {
                                  _assetsAudioPlayer.seek(to);
                                },
                              ),

                            ],
                          );
                        }
                    ),

                    Spacer(),


                    _assetsAudioPlayer.builderCurrent(
                        builder: (context, playing) {
                          if (playing == null) {
                            return SizedBox();
                          }
                          return Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: _assetsAudioPlayer.builderLoopMode(
                                  builder: (context, loopMode) {
                                    return PlayerBuilder.isPlaying(
                                        player: _assetsAudioPlayer,
                                        builder: (context, isPlaying) {
                                          return Row(
                                            children: [
                                              Spacer(),
                                              Spacer(),
                                              Spacer(),

                                              InkWell(
                                                onTap:(){
                                                  _assetsAudioPlayer.previous();
                                              },
                                              child:Container(
                                                width: 52.0,
                                                height: 52.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                  color: const Color(0xffFFFFFF),
                                                ),
                                                child:  Icon(Icons.fast_rewind,color: const Color(0xff6487b6),size: 30,),
                                              )),
                                              Spacer(),
                                              InkWell(
                                                onTap:(){
                                                  _assetsAudioPlayer.playOrPause();
                                                },
                                                child: Container(
                                                  width: 75.0,
                                                  height: 75.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                    color: const Color(0xffFFFFFF),
                                                  ),
                                                  child: Icon(
                                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                                    size: 40,
                                                    color: const Color(0xff6487b6),
                                                  ),
                                                ),
                                              )
                                              ,
                                              Spacer(),
                                              InkWell(
                                                onTap:(){
                                                  _assetsAudioPlayer.next();
                                                },
                                                child:Container(
                                                  width: 52.0,
                                                  height: 52.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                                    color: const Color(0xffFFFFFF),
                                                  ),
                                                  child:  Icon(Icons.fast_forward,color: const Color(0xff6487b6),size: 30,),
                                                ),
                                              ),

                                              Spacer(),
                                              Spacer(),
                                              Spacer(),

                                            ],
                                          );
                                        }
                                    );
                                  })
                          );
                        }
                    ),

                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),



                  ],
                );

              }
          ),

        ],
      ),

    );
  }


  Widget _loopIcon(BuildContext context,loopMode) {
    final iconSize = 30.0;
    if (loopMode == LoopMode.none) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: const Color(0xff6487b6),
      );
    } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color:  const Color(0xff6487b6),
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: const Color(0xff6487b6),
          ),
          Center(
            child: Text("1", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,color:const Color(0xff6487b6)),),
          ),
        ],
      );
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("บันทึกสำเร็จแล้ว"),
      content: Text("เข้าไปดูได้ที่เมนู 'สิ่งที่ชอบ' ในหน้าโปรไฟล์"),
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

  Widget _likeIcon(BuildContext context) {
    final iconSize = 30.0;
    //if (loopMode == LoopMode.none) {
      return Icon(
        Icons.favorite_border,
        size: iconSize,
        color: const Color(0xff6487b6),
      );
  /*  } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color:  const Color(0xff5f979b),
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: const Color(0xff5f979b),
          ),
          Center(
            child: Text("1", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold,color:const Color(0xff5f979b)),),
          ),
        ],
      );
    }*/
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              elevation: 0.0,
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.close),
                  iconSize:35,
                  onPressed: () async{
                    try {
                      _assetsAudioMusic.open(null);
                      await _assetsAudioMusic.dispose();
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomInset:false,
            backgroundColor: Colors.black54,
            body: widget,
          ),
        ),
      ),
    );
  }




}



class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({
    @required this.currentPosition,
    @required this.duration,
    @required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

         NeumorphicSlider(
              height: 10,
              min: 0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: percent * widget.duration.inMilliseconds.toDouble(),
              style:
              SliderStyle(variant: Color(0xffFFFFFF), accent:Color(0xffFFFFFF),disableDepth: true),
              //Color(0xffe2eff0)
              onChangeEnd: (newValue) {
                setState(() {
                  listenOnlyUserInterraction = false;
                  widget.seekTo(_visibleValue);
                });
              },
              onChangeStart: (_) {
                setState(() {
                  listenOnlyUserInterraction = true;
                });
              },
              onChanged: (newValue) {
                setState(() {
                  final to = Duration(milliseconds: newValue.floor());
                  _visibleValue = to;
                });
              },
            ),
          SizedBox(height: 5,),

          Row(
            children: [
              SizedBox(width: 10,),
              SizedBox(
                // width: 40,
                child: Text(durationToString(widget.currentPosition),style: TextStyle(color: const Color(0xffFFFFFF),fontWeight: FontWeight.bold),textScaleFactor: 1.2,),
              ),
              Spacer(),
              SizedBox(
                //width: 40,
                child: Text(durationToString(widget.duration),style: TextStyle(color: const Color(0xffFFFFFF),fontWeight: FontWeight.bold),textScaleFactor: 1.2,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes =
  twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  String twoDigitSeconds =
  twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return "$twoDigitMinutes:$twoDigitSeconds";
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






class SoundPlay extends StatefulWidget{
  SoundPlay({Key key, this.audios}) : super(key: key);
  final List<Audio> audios;

  @override
  _SoundPlayState createState() => _SoundPlayState(audios);
}

class _SoundPlayState extends State<SoundPlay> {
  _SoundPlayState(this.audios);
  final List<Audio> audios;
  AssetsAudioPlayer get _assetsAudioMusic => AssetsAudioPlayer.withId("sound");

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("เลือกบรรเลงประกอบ",textScaleFactor: 2.4,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          Text("ระดับเสียง",textScaleFactor: 1.8,style: TextStyle(color:Colors.white),),
          StreamBuilder(
              stream: _assetsAudioMusic.volume,
              builder: (context, asyncSnapshot) {
                final double volume = asyncSnapshot.data;
                return  Padding(
                    padding: const EdgeInsets.only(right:40,left:40),
                    child:SliderTheme(
                      data: SliderThemeData(
                          thumbColor: Colors.white70,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child:Slider(
                          value: volume.toDouble(),
                          onChanged: (newValue){
                            _assetsAudioMusic.setVolume(newValue.toDouble());
                          },
                          activeColor:Colors.white,
                          min:0.0,
                          max:1.0
                      ),)
                );
          }),
          _assetsAudioMusic.builderRealtimePlayingInfos(
              builder: (context, infos) {
                if (infos == null) {
                  return SizedBox();
                }
                return Column(
                  children: [
                    SoundPositionSeekWidget(
                      currentPosition: infos.currentPosition,
                      duration: infos.duration,

                      seekTo: (to) {
                        _assetsAudioMusic.seek(to);
                      },
                    ),

                  ],
                );
              }
          ),

          SizedBox(height: 15,),

          for (int i = 0; i < audios.length; i++)
            InkWell(
              onTap: (){
                _assetsAudioMusic.open(
                  audios[i],
                  autoStart: true,
                  showNotification: true,
                  playInBackground: PlayInBackground.enabled,
                  //    phoneCallStrategy: PhoneCallStrategy.none,
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                  notificationSettings: NotificationSettings(
                    seekBarEnabled: true,
                    stopEnabled: true,
                    customStopAction: (player){
                      player.stop();
                    },
                    prevEnabled: false,
                    customNextAction: (player) {
                      player.next();
                    },
                    customPrevAction: (player){
                      player.previous();
                    },
                    customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
                    customPauseIcon: AndroidResDrawable(name:"ic_pause_custom"),
                    customPlayIcon: AndroidResDrawable(name:"ic_play_custom"),
                  ),
                );
              },
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 46.0,
                      height: 46.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19.0),
                        color: const Color(0xffffffff),
                        image: DecorationImage(
                          image: NetworkImage(audios[i].metas.image.path),
                          fit: BoxFit.cover,
                        ),
                      ),

                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width:MediaQuery.of(context).size.width-140,
                            child:Text(
                              "${audios[i].metas.title}",
                              textScaleFactor: 1.6,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              softWrap: true,
                              //overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            )),
                        Text(
                          '${audios[i].metas.artist} - ${audios[i].metas.album} min',
                          textScaleFactor: 1.4,
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}





Future<List<Audio>> AudioSound() async {
  List<Tmusic> Musics;
  print('https://05hx8i6qja.execute-api.us-east-1.amazonaws.com/dev/soundplay');

  final response =
  await http.get('https://05hx8i6qja.execute-api.us-east-1.amazonaws.com/dev/soundplay');
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body)[0];
    String todata = utf8.decode(response.bodyBytes);
    Musics=(jsonDecode(todata) as List).map((i) =>
        Tmusic.fromJson(i)).toList();
    print(Musics[0].title);
    final Audios = <Audio>[];
    for (var i = 0; i < Musics.length; i++) {
      Audios.add(
          Audio.network(
            Musics[i].url,
            metas: Metas(
              id: Musics[i].id.toString(),
              title: Musics[i].title,
              artist: Musics[i].artist,
              album:  Musics[i].description,
              // image: MetasImage.network("https://www.google.com")
              image: MetasImage.network(
                  Musics[i].artwork),
            ),
          )
      );
    }
    return Audios;
  }else {
    throw Exception('Failed to load album');
  }
}






class SoundPositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const SoundPositionSeekWidget({
    @required this.currentPosition,
    @required this.duration,
    @required this.seekTo,
  });

  @override
  _SoundPositionSeekWidgetState createState() => _SoundPositionSeekWidgetState();
}

class _SoundPositionSeekWidgetState extends State<SoundPositionSeekWidget> {
  Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(SoundPositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
/*
          NeumorphicSlider(
            height: 10,
            min: 0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: percent * widget.duration.inMilliseconds.toDouble(),
            style:
            SliderStyle(variant: Color(0xffFFFFFF), accent:Color(0xffFFFFFF),disableDepth: true),
            //Color(0xffe2eff0)
            onChangeEnd: (newValue) {
              setState(() {
                listenOnlyUserInterraction = false;
                widget.seekTo(_visibleValue);
              });
            },
            onChangeStart: (_) {
              setState(() {
                listenOnlyUserInterraction = true;
              });
            },
            onChanged: (newValue) {
              setState(() {
                final to = Duration(milliseconds: newValue.floor());
                _visibleValue = to;
              });
            },
          ),
          SizedBox(height: 5,),
*/
          Row(
            children: [
              Spacer(),
              SizedBox(
                // width: 40,
                child: Text(durationToString(widget.currentPosition),style: TextStyle(color: const Color(0xffFFFFFF)) ,textScaleFactor: 1.4,),
              ),
              Text(" / ",style: TextStyle(color: const Color(0xffFFFFFF)) ,textScaleFactor: 1.4,),
              SizedBox(
                //width: 40,
                child: Text(durationToString(widget.duration),style: TextStyle(color: const Color(0xffFFFFFF) ),textScaleFactor: 1.4,),
              ),
              Spacer(),

            ],
          ),
        ],
      ),
    );
  }
}
