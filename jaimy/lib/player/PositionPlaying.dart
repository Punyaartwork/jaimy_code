import 'package:JaiMy/pages/playapr.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';


class PositionPlaying extends StatefulWidget {
  //final Duration currentPosition;
  final bool isPlayNow;
  final Function(bool) isOpen;

  const PositionPlaying({
    //  @required this.currentPosition,
    @required this.isPlayNow,
    @required this.isOpen,
  });

  @override
  _PositionPlayingState createState() => _PositionPlayingState();
}

class _PositionPlayingState extends State<PositionPlaying> {
  AssetsAudioPlayer get _assetsAudioPlayer => AssetsAudioPlayer.withId("music");

  @override
  Widget build(BuildContext context) {
    return widget.isPlayNow ? Positioned(
      bottom: 0,
      child:
      _assetsAudioPlayer.builderCurrent(
          builder: (BuildContext context, Playing playing) {
            if (playing != null) {
              //final myAudio = this.audios[0];
              print(playing.audio.audio.metas.title);
              print(playing.audio.audio.metas.artist);
              return

                Container(
                    height: 95,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 10,left: 20,right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      color: const Color(0xff1c2637),
                    ),
                    //width: 375.0,
                    //height: 95.0,
                    child: Row(
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(type: PageTransitionType.bottomToTop, child: PlayApr())
                              );
                            },
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text("${playing.audio.audio.metas.title.length >= 15? playing.audio.audio.metas.title.substring(0,15) + "..." : playing.audio.audio.metas.title}",
                                  style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 2.0,
                                ),
                                Text(
                                  playing.audio.audio.metas.artist,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.6,
                                ),

                              ],
                            )),
                        Spacer(),

                        _assetsAudioPlayer.builderLoopMode(
                            builder: (context, loopMode) {
                              return PlayerBuilder.isPlaying(
                                  player: _assetsAudioPlayer,
                                  builder: (context, isPlaying) {
                                    return  InkWell(
                                      //padding:EdgeInsets.all(0),
                                      child: Icon(
                                          Icons.stop,size: 40,color:Colors.white),
                                      onTap: () async {
                                        _assetsAudioPlayer.open(null);
                                        await _assetsAudioPlayer.dispose();
                                        print(playing.toString());

                                        playing = null;
                                        widget.isOpen(false);
                                      },
                                    );
                                  }
                              );
                            }
                        ),
                        _assetsAudioPlayer.builderLoopMode(
                            builder: (context, loopMode) {
                              return PlayerBuilder.isPlaying(
                                  player: _assetsAudioPlayer,
                                  builder: (context, isPlaying) {
                                    return  FlatButton(
                                      padding:EdgeInsets.all(0),
                                      child:Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                                            color: const Color(0xffffffff),
                                          ),
                                          child: Icon(
                                              isPlaying ? Icons.pause : Icons.play_arrow,size: 32,color:Color(0xff1c2637))),
                                      onPressed: () {
                                        _assetsAudioPlayer.playOrPause();
                                      },
                                    );
                                  }
                              );
                            }
                        ),

                      ],
                    )  );
            }else{
              return Container();
            }
            return Container( height: 95,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10,left: 20,right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                color: const Color(0xff5f979b),
              ),
              //width: 375.0,
              //height: 95.0,
              child:  Center(child: CircularProgressIndicator(backgroundColor: Colors.white),),);
          }
      ),

    ) : Container();
  }

}