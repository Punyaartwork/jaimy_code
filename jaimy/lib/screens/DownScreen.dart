import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:JaiMy/constants.dart';
import 'package:flutter/services.dart';


const debug = true;


class DownScreen extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  DownScreen({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
enum WidgetMarker {
  one , two , three
}
class _MyHomePageState extends State<DownScreen> {

  List <_TaskInfo> dhammas = [
    _TaskInfo( url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/37DHAMMA.mp3",
      title: "นอกรอบให้หมั่นประคองใจ",
    ),

    _TaskInfo(
      url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/19DHAMMA.mp3",
      title : "Set Zero",
    ),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/08DHAMMA.mp3",
        title: "สติกับสบาย"
    ),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/36DHAMMA.mp3",
        title: "แก้ฟุ้ง แก้ตึง"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/35DHAMMA.mp3",
        title: "สมบัติที่แท้จริง"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/34DHAMMA.mp3",
        title: "ฝึกเป็นผู้ให้"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/33DHAMMA.mp3",
        title: "ทำซ้ำๆ ทำบ่อยๆ"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/02DHAMMA.mp3",
        title: "สิ่งที่ต้องทำในชีวิต"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/07DHAMMA.mp3",
        title: "Let it be"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/01DHAMMA.mp3",
        title: "การทำสมาธิไม่ยาก"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/31DHAMMA.mp3",
        title: "นั่งตั้งนานทำไมยังไม่ได้ผล"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/29DHAMMA.mp3",
        title: "มหัศจรรย์สมาธิ"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/28DHAMMA.mp3",
        title: "ชีวิตที่ถูกหลอก"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/27DHAMMA.mp3",
        title: "เริ่มต้นจากจุดสบายแล้วจะง่าย"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/26DHAMMA.mp3",
        title: "นึกได้ก็เห็นได้"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/25DHAMMA.mp3",
        title: "มองผ่านๆ"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/24DHAMMA.mp3",
        title: "ความละเอียดภายใน"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/22DHAMMA.mp3",
        title: "นั่งอย่างมีชีวิตชีวา"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/15DHAMMA.mp3",
        title: "เราเป็นศูนย์กลางของจักรวาล"),

    _TaskInfo(
      url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/20DHAMMA.mp3",
      title: "กายสบายใจสบาย",),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/21DHAMMA.mp3",
        title: "ระลึกถึงความตาย"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/10DHAMMA.mp3",
        title: "การตอบประสบการณ์ภายใน" ),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/12DHAMMA.mp3",
        title: "วิธีปฏิบัติธรรมให้เข้าถึงประสบการณ์ภายใน"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/14DHAMMA.mp3",
        title: "ทำไมเด็กจึงเห็นธรรมะง่าย"),

    _TaskInfo(
        url: "https://di4y0jq908exx.cloudfront.net/sound/dhamma/16DHAMMA.mp3",
        title: "วิธีแก้อุปสรรคการนั่งสมาธิ")
  ];



  List <_TaskInfo> naturelist = [

    _TaskInfo(
        title:  'เสียงหยดน้ำ(5 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/natures/water-drops111.mp3'
    ),
    _TaskInfo(
        title:  'เสียงคลื่นทะเล (10 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/natures/Light+Sea+Waves_111.mp3'
    ),
    _TaskInfo(
        title:  'เสียงนกในป่า (4 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/Nature+sounds+Meditation+forest+sounds+of+birds+singing+relaxation+-+4+minutes.mp3'
    ),


    _TaskInfo(
        title:  'เสียงเหล่านกน้อย (18 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/SINGING+BIRDS.mp3'
    ),
    _TaskInfo(
        title: 'เสียงน้ำไหลช้าๆ (8 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/A+short+Meditation+of+Nature+Sounds-Relaxing+Birdsong-Calming+Sound+of+Water+Relaxation.mp3'
    ),
    _TaskInfo(
        title: 'เสียงน้ำตกท่ามกลางป่า (17 นาที)' ,
        url:'https://di4y0jq908exx.cloudfront.net/sound/A+short+Meditation+of+Nature+Sounds-Relaxing+Birdsong-Calming+Sound+of+Water+Relaxation.mp3'
           ),
    _TaskInfo(
        title: 'เสียงธรรมชาติท่ามกลางภูเขา (20 นาที)' ,
        url:  'https://di4y0jq908exx.cloudfront.net/sound/%5BNo+Copyright+Music%5D+Mountains+sounds.+Nature+Sounds.+Relaxation+and+Meditation..mp3'

    ),
  ];
  List <_TaskInfo> sounds = [
    _TaskInfo(
        title: 'Again & Again (16 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/Again+%26+Again.mp3'
    ),
    _TaskInfo(
        title: 'Ocean of Memories (15 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/Ocean+of+Memories.mp3'
    ),
    _TaskInfo(
        title: 'Clementia (14 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/Clementia.mp3'
    ),
    _TaskInfo(
        title: 'Broken Vessels (2 นาที)',
        url:
        'https://di4y0jq908exx.cloudfront.net/sound/up_630616/Broken+Vessels+(Amazing+Grace).mp3'

    ),
  ];


  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  WidgetMarker selectedMarker =  WidgetMarker.one;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: ThemeNew4,
      appBar: new AppBar(
        title:   Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            InkWell(
              onTap: (){
                _resetlist(dhammas);
                setState(() {
                  selectedMarker =  WidgetMarker.one;
                });
              },
              child: Text("นำนั่ง", textScaleFactor: 1.0,style: TextStyle(color:  Colors.white.withOpacity( (selectedMarker == WidgetMarker.one) ? 1.0 : 0.3),fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: 20,),
            InkWell(
              onTap: (){
                _resetlist(sounds);

                setState(() {
                  selectedMarker =  WidgetMarker.two;
                });
              },
              child: Text("บรรเลง", textScaleFactor: 1.0,style: TextStyle(color:Colors.white.withOpacity((selectedMarker == WidgetMarker.two) ? 1.0 : 0.3),fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: 20,),
            InkWell(
              onTap: (){
                _resetlist(naturelist);

                setState(() {
                  selectedMarker =  WidgetMarker.three;
                });
              },
              child: Text("ธรรมชาติ", textScaleFactor: 1.0,style: TextStyle(color:Colors.white.withOpacity((selectedMarker == WidgetMarker.three) ? 1.0 : 0.3),fontWeight: FontWeight.bold),),
            ),
            SizedBox(width: 20,),
            Spacer(),
          ],
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body:
      //AllPlayScreen(sounds:(selectedMarker == WidgetMarker.one) ? dhammas : sounds,)

       //(selectedMarker == WidgetMarker.two) ?  AllPlayScreen(sounds: dhammas ,) : AllPlayScreen(sounds: sounds ,)

      //(selectedMarker == WidgetMarker.two) ? NatureDownScreen() : SitDownScreen()



      Builder(
          builder: (context) => _isLoading
              ? new Center(
            child: new CircularProgressIndicator(),
          )
              : _permissionReady
              ? new Container(
            child: new ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: _items
                  .map((item) => item.task == null
                  ? new Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Text(
                  item.name,
                  textScaleFactor: 1.8,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, ),
                ),
              )
                  : new Container(
                color: Colors.white.withOpacity(0.1),
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.only(
                    left: 16.0, right: 8.0,bottom: 10),
                child: InkWell(
                  onTap: item.task.status ==
                      DownloadTaskStatus.complete
                      ? () {
                    _openDownloadedFile(item.task)
                        .then((success) {
                      if (!success) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                                'ไม่สามารถเปิดไฟล์นี้ได้')));
                      }
                    });
                  }
                      : null,
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        height: 64.0,
                        child: new Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Text(
                                item.name,
                                maxLines: 1,
                                softWrap: true,
                                overflow:
                                TextOverflow.ellipsis,
                                textScaleFactor: 1.8,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            new Padding(
                              padding:
                              const EdgeInsets.only(
                                  left: 8.0),
                              child: _buildActionForTask(
                                  item.task),
                            ),
                          ],
                        ),
                      ),
                      item.task.status ==
                          DownloadTaskStatus
                              .running ||
                          item.task.status ==
                              DownloadTaskStatus.paused
                          ? new Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child:
                        new LinearProgressIndicator(
                          value: item.task.progress /
                              100,
                        ),
                      )
                          : new Container()
                    ]
                        .where((child) => child != null)
                        .toList(),
                  ),
                ),
              ))
                  .toList(),
            ),
          )
              : new Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'โปรดอนุญาตสิทธิ์ในการเข้าถึงสโตร์ของคุณ -_-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        _checkPermission().then((hasGranted) {
                          setState(() {
                            _permissionReady = hasGranted;
                          });
                        });
                      },
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                ],
              ),
            ),
          )),
    );
  }
  /*
  Widget getCustomContainer() {
    switch (selectedMarker){
      case WidgetMarker.one:
        return SitDownScreen();
      case WidgetMarker.two:
        return MusicDownScreen();
      case WidgetMarker.three:
        return NatureDownScreen();
    }
    return SitDownScreen();
  }*/
  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download,color: Colors.white,),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'พร้อมเล่น',
            style: new TextStyle(color: Colors.white),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('ยกเลิกแล้ว', style: new TextStyle(color: Colors.amberAccent));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('ล้มเหลว', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    print(_localPath);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.url,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    print(_localPath);
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted){
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        if (permissions[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];_tasks = (selectedMarker == WidgetMarker.one) ? dhammas:  (selectedMarker == WidgetMarker.two) ? sounds : naturelist;
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_videos
        .map((video) => _TaskInfo(title: video['name'], url: video['link'])));
    */
    _items.add(_ItemHolder(name: ''));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].title, task: _tasks[i]));
      count++;
    }




    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.url == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }








  _resetlist(list) async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/

   /* _tasks.addAll(_videos
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));
*/

    _tasks = list;
    _items.add(_ItemHolder(name: ''));
    for (int i = count; i < list.length; i++) {
      _items.add(_ItemHolder(name: list[i].title, task: list[i]));
      count++;
    }


/*
    _tasks.addAll(_musics
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    _items.add(_ItemHolder(name: 'บรรเลง'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }


    _tasks.addAll(_natures
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    _items.add(_ItemHolder(name: 'ธรรมชาติ'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }
*/


    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.url == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }
}

class _TaskInfo {
  final String title;
  final String url;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.title, this.url});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
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









/*


class SitDownScreen extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  SitDownScreen({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _SitMyHomePageState createState() => new _SitMyHomePageState();
}

class _SitMyHomePageState extends State<SitDownScreen> {

  final _videos = [
    {
      'name': 'Set Zero (11 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/19DHAMMA.mp3'
    },
    {
      'name': 'สติกับสบาย (18 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/08DHAMMA.mp3'
    },
    {
      'name': 'ซ้อมตาย (12 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/32DHAMMA.mp3'
    },
    {
      'name': 'กายสบายใจสบาย (15 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/20DHAMMA.mp3'
    },
    {
      'name': 'ง่ายจึงจะถูกวิธี (18 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/08DHAMMA.mp3'
    },
    {
      'name': 'Let it be (26 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/07DHAMMA.mp3'
    },
    {
      'name': 'นั่งอย่างมีชีวิตชีวา (22 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/22DHAMMA.mp3'
    },
    {
      'name': 'มหัศจรรย์สมาธิ (36 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/29DHAMMA.mp3'
    },
    {
      'name': 'ชีวิตที่ถูกหลอก (35 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/28DHAMMA.mp3'
    }
  ];



  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  WidgetMarker selectedMarker =  WidgetMarker.one;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return   Builder(
          builder: (context) => _isLoading
              ? new Center(
            child: new CircularProgressIndicator(),
          )
              : _permissionReady
              ? new Container(
            child: new ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: _items
                  .map((item) => item.task == null
                  ? new Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Text(
                  item.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
              )
                  : new Container(
                color: Colors.white.withOpacity(0.1),
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.only(
                    left: 16.0, right: 8.0,bottom: 10),
                child: InkWell(
                  onTap: item.task.status ==
                      DownloadTaskStatus.complete
                      ? () {
                    _openDownloadedFile(item.task)
                        .then((success) {
                      if (!success) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                                'ไม่สามารถเปิดไฟล์นี้ได้')));
                      }
                    });
                  }
                      : null,
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        height: 64.0,
                        child: new Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: new Text(
                                item.name,
                                maxLines: 1,
                                softWrap: true,
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            new Padding(
                              padding:
                              const EdgeInsets.only(
                                  left: 8.0),
                              child: _buildActionForTask(
                                  item.task),
                            ),
                          ],
                        ),
                      ),
                      item.task.status ==
                          DownloadTaskStatus
                              .running ||
                          item.task.status ==
                              DownloadTaskStatus.paused
                          ? new Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child:
                        new LinearProgressIndicator(
                          value: item.task.progress /
                              100,
                        ),
                      )
                          : new Container()
                    ]
                        .where((child) => child != null)
                        .toList(),
                  ),
                ),
              ))
                  .toList(),
            ),
          )
              : new Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'โปรดอนุญาตสิทธิ์ในการเข้าถึงสโตร์ของคุณ -_-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        _checkPermission().then((hasGranted) {
                          setState(() {
                            _permissionReady = hasGranted;
                          });
                        });
                      },
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                ],
              ),
            )));
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download,color: Colors.white,),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'พร้อมเล่น',
            style: new TextStyle(color: Colors.white),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('ยกเลิกแล้ว', style: new TextStyle(color: Colors.amberAccent));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('ล้มเหลว', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    print(_localPath);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    print(_localPath);
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted){
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        if (permissions[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/

    _tasks.addAll(_videos
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    _items.add(_ItemHolder(name: 'นำนั่งสมาธิ'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }






    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

























class MusicDownScreen extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  MusicDownScreen({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _MusicMyHomePageState createState() => new _MusicMyHomePageState();
}

class _MusicMyHomePageState extends State<MusicDownScreen> {

  final _musics = [
    {
      'name': 'Again & Again (16 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/Again+%26+Again.mp3'
    },
    {
      'name': 'Ocean of Memories (15 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/Ocean+of+Memories.mp3'
    },
    {
      'name': 'Clementia (14 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/Clementia.mp3'
    },
    {
      'name': 'เสียงพิน (6 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/dhamma/20DHAMMA.mp3'
    },
    {
      'name': 'Broken Vessels (2 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/up_630616/Broken+Vessels+(Amazing+Grace).mp3'
    },
  ];





  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  WidgetMarker selectedMarker =  WidgetMarker.one;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return   Builder(
        builder: (context) => _isLoading
            ? new Center(
          child: new CircularProgressIndicator(),
        )
            : _permissionReady
            ? new Container(
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: _items
                .map((item) => item.task == null
                ? new Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                item.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            )
                : new Container(
              color: Colors.white.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8.0,bottom: 10),
              child: InkWell(
                onTap: item.task.status ==
                    DownloadTaskStatus.complete
                    ? () {
                  _openDownloadedFile(item.task)
                      .then((success) {
                    if (!success) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                          content: Text(
                              'ไม่สามารถเปิดไฟล์นี้ได้')));
                    }
                  });
                }
                    : null,
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      height: 64.0,
                      child: new Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              item.name,
                              maxLines: 1,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          new Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8.0),
                            child: _buildActionForTask(
                                item.task),
                          ),
                        ],
                      ),
                    ),
                    item.task.status ==
                        DownloadTaskStatus
                            .running ||
                        item.task.status ==
                            DownloadTaskStatus.paused
                        ? new Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child:
                      new LinearProgressIndicator(
                        value: item.task.progress /
                            100,
                      ),
                    )
                        : new Container()
                  ]
                      .where((child) => child != null)
                      .toList(),
                ),
              ),
            ))
                .toList(),
          ),
        )
            : new Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'โปรดอนุญาตสิทธิ์ในการเข้าถึงสโตร์ของคุณ -_-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        _checkPermission().then((hasGranted) {
                          setState(() {
                            _permissionReady = hasGranted;
                          });
                        });
                      },
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                ],
              ),
            )));
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download,color: Colors.white,),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'พร้อมเล่น',
            style: new TextStyle(color: Colors.white),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('ยกเลิกแล้ว', style: new TextStyle(color: Colors.amberAccent));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('ล้มเหลว', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    print(_localPath);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    print(_localPath);
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted){
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        if (permissions[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/


    _tasks.addAll(_musics
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    _items.add(_ItemHolder(name: 'บรรเลง'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }





    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}















class NatureDownScreen extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  NatureDownScreen({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _NatureMyHomePageState createState() => new _NatureMyHomePageState();
}

class _NatureMyHomePageState extends State<NatureDownScreen> {



  final _natures = [
    {
      "name": "เสียงหยดน้ำ(5 นาที)",
      'time': '11 นาที',
      'link': "https://di4y0jq908exx.cloudfront.net/sound/natures/water-drops111.mp3"
    },
    {
      'name': 'เสียงคลื่นทะเล (10 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/natures/Light+Sea+Waves_111.mp3'
    },
    {
      'name': 'เสียงนกในป่า (4 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/Nature+sounds+Meditation+forest+sounds+of+birds+singing+relaxation+-+4+minutes.mp3'
    },
    {
      'name': 'เสียงเหล่านกน้อย (18 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/SINGING+BIRDS.mp3'
    },
    {
      'name': 'เสียงน้ำไหลช้าๆ (8 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/A+short+Meditation+of+Nature+Sounds-Relaxing+Birdsong-Calming+Sound+of+Water+Relaxation.mp3'
    },
    {
      'name': 'เสียงน้ำตกท่ามกลางป่า (17 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/The+Forest+Waterfall+HD+-+The+Calming+Sound+of+Water+(mp3cut.net).mp3'
    },
    {
      'name': 'เสียงธรรมชาติท่ามกลางภูเขา (20 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/%5BNo+Copyright+Music%5D+Mountains+sounds.+Nature+Sounds.+Relaxation+and+Meditation..mp3'
    },
  ];





  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  WidgetMarker selectedMarker =  WidgetMarker.one;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return   Builder(
        builder: (context) => _isLoading
            ? new Center(
          child: new CircularProgressIndicator(),
        )
            : _permissionReady
            ? new Container(
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: _items
                .map((item) => item.task == null
                ? new Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                item.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            )
                : new Container(
              color: Colors.white.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8.0,bottom: 10),
              child: InkWell(
                onTap: item.task.status ==
                    DownloadTaskStatus.complete
                    ? () {
                  _openDownloadedFile(item.task)
                      .then((success) {
                    if (!success) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                          content: Text(
                              'ไม่สามารถเปิดไฟล์นี้ได้')));
                    }
                  });
                }
                    : null,
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      height: 64.0,
                      child: new Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              item.name,
                              maxLines: 1,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          new Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8.0),
                            child: _buildActionForTask(
                                item.task),
                          ),
                        ],
                      ),
                    ),
                    item.task.status ==
                        DownloadTaskStatus
                            .running ||
                        item.task.status ==
                            DownloadTaskStatus.paused
                        ? new Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child:
                      new LinearProgressIndicator(
                        value: item.task.progress /
                            100,
                      ),
                    )
                        : new Container()
                  ]
                      .where((child) => child != null)
                      .toList(),
                ),
              ),
            ))
                .toList(),
          ),
        )
            : new Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'โปรดอนุญาตสิทธิ์ในการเข้าถึงสโตร์ของคุณ -_-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        _checkPermission().then((hasGranted) {
                          setState(() {
                            _permissionReady = hasGranted;
                          });
                        });
                      },
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                ],
              ),
            )));
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download,color: Colors.white,),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'พร้อมเล่น',
            style: new TextStyle(color: Colors.white),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('ยกเลิกแล้ว', style: new TextStyle(color: Colors.amberAccent));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('ล้มเหลว', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    print(_localPath);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    print(_localPath);
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted){
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        if (permissions[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/


    _tasks.addAll(_natures
        .map((video) => _TaskInfo(name: video['name'], link: video['link'])));

    _items.add(_ItemHolder(name: 'ธรรมชาติ'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }





    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}




class AllPlayScreen extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  AllPlayScreen({Key key, this.title, this.sounds , this.platform}) : super(key: key);

  final String title;

  final List<_TaskInfo> sounds;

  @override
  _AllPlayScreenState createState() => new _AllPlayScreenState();
}

class _AllPlayScreenState extends State<AllPlayScreen> {



  final _natures = [
    {
      "name": "เสียงหยดน้ำ(5 นาที)",
      'time': '11 นาที',
      'link': "https://di4y0jq908exx.cloudfront.net/sound/natures/water-drops111.mp3"
    },
    {
      'name': 'เสียงคลื่นทะเล (10 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/natures/Light+Sea+Waves_111.mp3'
    },
    {
      'name': 'เสียงนกในป่า (4 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/Nature+sounds+Meditation+forest+sounds+of+birds+singing+relaxation+-+4+minutes.mp3'
    },
    {
      'name': 'เสียงเหล่านกน้อย (18 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/SINGING+BIRDS.mp3'
    },
    {
      'name': 'เสียงน้ำไหลช้าๆ (8 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/A+short+Meditation+of+Nature+Sounds-Relaxing+Birdsong-Calming+Sound+of+Water+Relaxation.mp3'
    },
    {
      'name': 'เสียงน้ำตกท่ามกลางป่า (17 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/The+Forest+Waterfall+HD+-+The+Calming+Sound+of+Water+(mp3cut.net).mp3'
    },
    {
      'name': 'เสียงธรรมชาติท่ามกลางภูเขา (20 นาที)',
      'time': '11 นาที',
      'link':
      'https://di4y0jq908exx.cloudfront.net/sound/%5BNo+Copyright+Music%5D+Mountains+sounds.+Nature+Sounds.+Relaxation+and+Meditation..mp3'
    },
  ];





  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  WidgetMarker selectedMarker =  WidgetMarker.one;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tasks = widget.sounds;
    });
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {
        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return   Builder(
        builder: (context) => _isLoading
            ? new Center(
          child: new CircularProgressIndicator(),
        )
            : _permissionReady
            ? new Container(
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: _items
                .map((item) => item.task == null
                ? new Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                item.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
            )
                : new Container(
              color: Colors.white.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8.0,bottom: 10),
              child: InkWell(
                onTap: item.task.status ==
                    DownloadTaskStatus.complete
                    ? () {
                  _openDownloadedFile(item.task)
                      .then((success) {
                    if (!success) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(
                          content: Text(
                              'ไม่สามารถเปิดไฟล์นี้ได้')));
                    }
                  });
                }
                    : null,
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      height: 64.0,
                      child: new Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              item.name,
                              maxLines: 1,
                              softWrap: true,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          new Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 8.0),
                            child: _buildActionForTask(
                                item.task),
                          ),
                        ],
                      ),
                    ),
                    item.task.status ==
                        DownloadTaskStatus
                            .running ||
                        item.task.status ==
                            DownloadTaskStatus.paused
                        ? new Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child:
                      new LinearProgressIndicator(
                        value: item.task.progress /
                            100,
                      ),
                    )
                        : new Container()
                  ]
                      .where((child) => child != null)
                      .toList(),
                ),
              ),
            ))
                .toList(),
          ),
        )
            : new Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'โปรดอนุญาตสิทธิ์ในการเข้าถึงสโตร์ของคุณ -_-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey, fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        _checkPermission().then((hasGranted) {
                          setState(() {
                            _permissionReady = hasGranted;
                          });
                        });
                      },
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ))
                ],
              ),
            )));
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return new RawMaterialButton(
        onPressed: () {
          _requestDownload(task);
        },
        child: new Icon(Icons.file_download,color: Colors.white,),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return new RawMaterialButton(
        onPressed: () {
          _pauseDownload(task);
        },
        child: new Icon(
          Icons.pause,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return new RawMaterialButton(
        onPressed: () {
          _resumeDownload(task);
        },
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        shape: new CircleBorder(),
        constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text(
            'พร้อมเล่น',
            style: new TextStyle(color: Colors.white),
          ),
          RawMaterialButton(
            onPressed: () {
              _delete(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return new Text('ยกเลิกแล้ว', style: new TextStyle(color: Colors.amberAccent));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          new Text('ล้มเหลว', style: new TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              _retryDownload(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: new CircleBorder(),
            constraints: new BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else {
      return null;
    }
  }

  void _requestDownload(_TaskInfo task) async {
    print(_localPath);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    print(_localPath);
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await Permission.storage.status;
      if (permission != PermissionStatus.granted){
        Map<Permission, PermissionStatus> permissions = await [
          Permission.storage,
        ].request();
        if (permissions[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = widget.sounds;
    _items = [];

    /*  _tasks.addAll(_documents.map((document) =>
        _TaskInfo(name: document['name'], link: document['link'])));

    _items.add(_ItemHolder(name: 'Documents'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }

    _tasks.addAll(_images
        .map((image) => _TaskInfo(name: image['name'], link: image['link'])));

    _items.add(_ItemHolder(name: 'Images'));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }*/



    _items.add(_ItemHolder(name: ''));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }





    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

*/