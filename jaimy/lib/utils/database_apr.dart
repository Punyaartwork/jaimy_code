import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path/path.dart' as p;

class DataApr {
  static DataApr _DatabaseApr;
  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory directory = await getApplicationDocumentsDirectory();
    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'apr_database.db');
   // String path = directory.path + 'jaimy_database.db';
    //await deleteDatabase(path);
    return _database = await openDatabase(path,
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE posts(id INTEGER PRIMARY KEY, post TEXT, postPhoto TEXT, postEmotion INTEGER, postTime INTEGER)",
        );
        await db.execute(
          "CREATE TABLE likeFriends(id TEXT PRIMARY KEY, time INTEGER)",
        );
        await db.execute(
          "CREATE TABLE historySound(id TEXT PRIMARY KEY, url TEXT, title TEXT, artwork TEXT, artist TEXT, description TEXT, time INTEGER, topicName TEXT )",
        );
        await db.execute(
          "CREATE TABLE historyJais(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, jai TEXT, jaiIcon TEXT, jaiInt INTEGER, jaiTime INTEGER)",
        );
      },
      //  Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
  DataApr();


  Future<void> insertPost(Post post) async {
    // Get a reference to the database.
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Post>> posts() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('posts', orderBy: "id DESC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Post(
        id: maps[i]['id'],
        post: maps[i]['post'],
        postPhoto: maps[i]['postPhoto'],
        postEmotion:maps[i]['postEmotion'] ,
        postTime: maps[i]['postTime']
      );
    });
  }

  Future<void> updatePost(Post post) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'posts',
      post.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [post.id],
    );
  }

  Future<void> deletePost(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'posts',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future<void> likeFriend(LikeFriend friend) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    //final List<Map<String, dynamic>> maps = await db.query('knows', orderBy: "time DESC", limit:1);

    await db.insert(
      'likeFriends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<LikeFriend>> isLiked() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('likeFriends', orderBy: "time ASC", limit:15);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    print(DateFormat.E().format(DateTime.now()));
    if(DateFormat.E().format(DateTime.now()) == 'Mon') {

    }
    return List.generate(maps.length, (i) {
      return LikeFriend(
        maps[i]['id'].toString(),
        maps[i]['time'],
      );
    });
  }


  Future<num> sumLikeFriend() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('likeFriends', orderBy: "time ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<LikeFriend> sumLikes = await List.generate(maps.length, (i) {
      return LikeFriend(
        maps[i]['id'].toString(),
        maps[i]['time'],
      );
    });
    //num know = sumKnows.fold(0, (previous, current) => previous + current.);
    return  sumLikes.length;
  }


  Future<void> saveMusic(hisSound sounds) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'historySound',
      sounds.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<hisSound>> historySounds() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('historySound', orderBy: "time ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return hisSound(
        maps[i]['id'],
        maps[i]['url'],
        maps[i]['title'],
        maps[i]['artist'],
        maps[i]['artwork'],
        maps[i]['description'],
        maps[i]['time'],
        maps[i]['topicName'],
      );
    });
  }




  Future<void> deleteHisSound(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'historySound',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }







  Future<void> saveJai(HisJai jai) async {
    // Get a reference to the database.
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'historyJais',
      jai.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<HisJai>> historyJais() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    //final List<Map<String, dynamic>> maps = await db.query('rewards', orderBy: "time ASC", limit:15);
    final List<Map<String, dynamic>> maps = await db.query('historyJais', orderBy: "jaiTime ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return HisJai(
        id:maps[i]['id'],
        jai:maps[i]['jai'],
        jaiIcon:maps[i]['jaiIcon'],
        jaiInt:maps[i]['jaiInt'],
        jaiTime:maps[i]['jaiTime'],
      );
    });
  }


  Future<num> sumHisJai() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('historyJais', orderBy: "jaiTime ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<HisJai> sumJais = await List.generate(maps.length, (i) {
      return HisJai(
        id:maps[i]['id'],
        jai:maps[i]['jai'],
        jaiIcon:maps[i]['jaiIcon'],
        jaiInt:maps[i]['jaiInt'],
        jaiTime:maps[i]['jaiTime'],
      );
    });
    //num know = sumKnows.fold(0, (previous, current) => previous + current.);
    return  sumJais.length;
  }

}






class Post {
  final int id;
  final String post;
  final String postPhoto;
  final int postEmotion;
  final int postTime;

  Post({this.id, this.post, this.postPhoto, this.postEmotion, this.postTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post': post,
      'postPhoto': postPhoto,
      'postEmotion': postEmotion,
      'postTime': postTime,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Post{id: $id, post: $post, ,postPhoto: $postPhoto, postEmotion: $postEmotion, postTime: $postTime}';
  }
}




class LikeFriend {
  final String id;
  final int time;

  LikeFriend(this.id, this.time);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'LikeFriend{id: $id, time: $time }';
  }
}




class Relex {
  final int id;
  final int time;
  final int relex;
  final String day;

  Relex({this.id,this.time, this.relex, this.day});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'relex': relex,
      'day':day
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Relex{id: $id, time: $time, relex: $relex, day: $day}';
  }
}




class hisSound {
  final String id;
  final String url;
  final String title;
  final String artist;
  final String artwork;
  final String description;
  final int time;
  final String topicName;


  hisSound(this.id, this.url, this.title, this.artist, this.artwork, this.description, this.time, this.topicName);

  /*factory Musiclike.fromJson(Map<String, dynamic> json) {
    return Musiclike(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      artwork: json['artwork'],
      artist: json['artist'],
      description: json['description'],
    );
  }*/

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'artist':artist,
      'artwork': artwork,
      'description':description,
      'time':time,
      'topicName':topicName

    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'hisSound{id: $id, url: $url, title: $title, artist: $artist, artwork: $artwork, description: $description, time: $time, topicName:$topicName}';
  }
}



class HisJai{
  final int id;
  final String jai;
  final String jaiIcon;
  final int jaiInt;
  final int jaiTime;

  HisJai({this.id,this.jai,this.jaiIcon, this.jaiInt, this.jaiTime});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jai': jai,
      'jaiIcon': jaiIcon,
      'jaiInt': jaiInt,
      'jaiTime': jaiTime,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'HisJai{id: $id, jai: $jai, jaiIcon: $jaiIcon, jaiInt: $jaiInt, jaiTime: $jaiTime}';
  }
}