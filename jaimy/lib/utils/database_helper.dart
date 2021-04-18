import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
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
    String path = p.join(databasesPath, 'jaimy_database.db');
   // String path = directory.path + 'jaimy_database.db';
    //await deleteDatabase(path);
    return _database = await openDatabase(path,
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
        await db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, profile TEXT, sex TEXT, age INTEGER, intExp INTEGER, intMinute INTEGER, intListen INTEGER, intKnow INTEGER, intRelex INTEGER, intWave INTEGER, intMeditate INTEGER, intLesson INTEGER, intEmotion INTEGER)",
        );
        await db.execute(
          "CREATE TABLE awakes(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, intKnow INTEGER, intRelex INTEGER, time INTEGER)",
        );
        await db.execute(
          "CREATE TABLE emotions(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, intEmotion INTEGER, time INTEGER)",
        );
        await db.execute(
          "CREATE TABLE waves(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, time INTEGER, wave INTEGER, day TEXT)",
        );
        await db.execute(
          "CREATE TABLE knows(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, time INTEGER, know INTEGER, day TEXT)",
        );
        await db.execute(
          "CREATE TABLE relexs(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, time INTEGER, relex INTEGER, day TEXT)",
        );
        await db.execute(
          "CREATE TABLE emocharts(id INTEGER PRIMARY KEY, emotion INTEGER, text TEXT, color TEXT)",
        );
        await db.execute(
          "CREATE TABLE musiclikes(id TEXT PRIMARY KEY, url TEXT, title TEXT, artwork TEXT, artist TEXT, description TEXT)",
        );
        await db.execute(
          "CREATE TABLE rewards(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, rewardName TEXT, rewardPhoto TEXT, rewardDetail TEXT)",
        );
      },
      //  Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
  DatabaseHelper();


  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

// Insert a dog into the database.


  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<User>> users() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('user');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        profile: maps[i]['profile'],
        sex: maps[i]['sex'],
        age: maps[i]['age'],
        intExp: maps[i]['intExp'],
        intMinute: maps[i]['intMinute'],
        intListen: maps[i]['intListen'],
        intKnow: maps[i]['intKnow'],
        intRelex: maps[i]['intRelex'],
        intWave: maps[i]['intWave'],
        intMeditate: maps[i]['intMeditate'],
        intLesson: maps[i]['intLesson'],
        intEmotion: maps[i]['intEmotion'],
      );
    });
  }

  Future<User> getUser(int id) async {
    final Database db = await database;
    List<Map> maps = await db.query('user',
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      Map<String, dynamic> result = await maps.first;
      return User(
        id: result['id'],
        name: result['name'],
        profile: result['profile'],
        sex:result['sex'],
        age: result['age'],
        intExp: result['intExp'],
        intMinute: result['intMinute'],
        intListen: result['intListen'],
        intKnow: result['intKnow'],
        intRelex: result['intRelex'],
        intWave: result['intWave'],
        intMeditate: result['intMeditate'],
        intLesson: result['intLesson'],
        intEmotion: result['intEmotion'],
      );
    }else{
      User newUser=User(
        id: 1,
        name: 'ตั้งชื่อของคุณ',
        profile: 'NewProfile',
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
      this.insertUser(newUser);
      return newUser;
    }
  }




  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'user',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }



  Future<void> insertAwake(Awake awake) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'awakes',
      awake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Awake>> awakes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('awakes', orderBy: "time DESC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Awake(
        id: maps[i]['id'],
        intKnow: maps[i]['intKnow'],
        intRelex: maps[i]['intRelex'],
        time: maps[i]['time'],
      );
    });
  }



  Future<void> insertEmotion(Emotion emotion) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'emotions',
      emotion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Emotion>> emotions() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('emotions', orderBy: "time DESC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Emotion(
        id: maps[i]['id'],
        intEmotion: maps[i]['intEmotion'],
        time: maps[i]['time'],
      );
    });
  }



  Future<void> insertWave(Wave wave) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    final List<Map<String, dynamic>> maps = await db.query('waves', orderBy: "time DESC", limit:1);
    Wave save;
    if(maps.length != 0){
      print(maps[0]);
      if(maps[0]['day']==DateFormat.E().format(DateTime.now())){
        save = Wave(
            id:maps[0]['id'] ,
            time: new DateTime.now().millisecondsSinceEpoch,
            wave: wave.wave,
            day: DateFormat.E().format(DateTime.now())
        );
      }else{
        save = Wave(
            id:null ,
            time: new DateTime.now().millisecondsSinceEpoch,
            wave: wave.wave,
            day: DateFormat.E().format(DateTime.now())
        );
      }
    }else{
      save = Wave(
          id:null ,
          time: new DateTime.now().millisecondsSinceEpoch,
          wave: wave.wave,
          day: DateFormat.E().format(DateTime.now())
      );
    }
    await db.insert(
      'waves',
      save.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Waves>> waves() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('waves', orderBy: "time DESC", limit:8);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Waves(
        maps[i]['id'],
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['wave'],
        maps[i]['day'],
      );
    });
  }


  Future<num> sumWave() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('waves', orderBy: "time ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Waves> sumWaves = await List.generate(maps.length, (i) {
      return Waves(
        maps[i]['id'],
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['wave'],
        maps[i]['day'],
      );
    });
    num wave = sumWaves.fold(0, (previous, current) => previous + current.wave);
    return (wave/sumWaves.length);
  }



  Future<void> insertKnow(Know know) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    //final List<Map<String, dynamic>> maps = await db.query('knows', orderBy: "time DESC", limit:1);
    Know save = Know(
        id:null ,
        time: new DateTime.now().millisecondsSinceEpoch,
        know: know.know,
        day: DateFormat.E().format(DateTime.now())
    );
    await db.insert(
      'knows',
      save.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Knows>> knows() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('knows', orderBy: "time ASC", limit:15);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    print(DateFormat.E().format(DateTime.now()));
    if(DateFormat.E().format(DateTime.now()) == 'Mon') {

    }
    return List.generate(maps.length, (i) {
      return Knows(
        maps[i]['id'].toString(),
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['know'],
        maps[i]['day'],
      );
    });
  }


  Future<num> sumKnow() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('knows', orderBy: "time ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Knows> sumKnows = await List.generate(maps.length, (i) {
      return Knows(
        maps[i]['id'].toString(),
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['know'],
        maps[i]['day'],
      );
    });
    num know = sumKnows.fold(0, (previous, current) => previous + current.know);
    return (know/sumKnows.length)*20;
  }



  Future<void> insertRelex(Relex relex) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    Relex save = Relex(
        id:null ,
        time: new DateTime.now().millisecondsSinceEpoch,
        relex: relex.relex,
        day: DateFormat.E().format(DateTime.now())
    );
    await db.insert(
      'relexs',
      save.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Relexs>> relexs() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('relexs', orderBy: "time ASC", limit:15);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Relexs(
        maps[i]['id'].toString(),
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['relex'],
        maps[i]['day'],
      );
    });
  }


  Future<num> sumRelex() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('relexs', orderBy: "time ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Relexs> sumRelexs = await List.generate(maps.length, (i) {
      return Relexs(
        maps[i]['id'].toString(),
        new DateTime.fromMillisecondsSinceEpoch(maps[i]['time']),
        maps[i]['relex'],
        maps[i]['day'],
      );
    });
    num relex = sumRelexs.fold(0, (previous, current) => previous + current.relex);
    return (relex/sumRelexs.length)*10;
  }



  Future<void> setEmotion(Emochart emochart) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'emocharts',
      emochart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Emocharts>> emocharts() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('emocharts');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Emocharts(
        maps[i]['id'],
        maps[i]['emotion'],
        maps[i]['text'],
        charts.ColorUtil.fromDartColor(Color(int.parse(maps[i]['color'], radix: 16) + 0xFF000000)), //charts.ColorUtil.fromDartColor(Color(int.parse(maps[i]['color'], radix: 16) + 0xFF000000)))
      );
    });
  }

  Future<void> likeMusic(Musiclike musiclike) async {
    // Get a reference to the database.
    // Insert the User into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same user is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'musiclikes',
      musiclike.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Musiclike>> musiclikes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('musiclikes', orderBy: "id ASC");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Musiclike(
        maps[i]['id'],
        maps[i]['url'],
        maps[i]['title'],
        maps[i]['artwork'],
        maps[i]['artist'],
        maps[i]['description']
      );
    });
  }




  Future<void> deleteLike(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'musiclikes',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }



  Future<void> insertReward(Reward reward) async {
    // Get a reference to the database.
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    Database db = await this.database;
    await db.insert(
      'rewards',
      reward.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Reward>> rewards() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    //final List<Map<String, dynamic>> maps = await db.query('rewards', orderBy: "time ASC", limit:15);
    final List<Map<String, dynamic>> maps = await db.query('rewards');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Reward(
        id:maps[i]['id'],
        rewardName:maps[i]['rewardName'],
        rewardPhoto:maps[i]['rewardPhoto'],
        rewardDetail:maps[i]['rewardDetail'],
      );
    });
  }

}





class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}






class User {
  final int id;
  final String name;
  final String profile;
  final String sex;
  final int age;
  final int intExp;
  final int intMinute;
  final int intListen;
  final int intKnow;
  final int intRelex;
  final int intWave;
  final int intMeditate;
  final int intLesson;
  final int intEmotion;

  User({this.id, this.name, this.profile, this.sex, this.age, this.intExp, this.intMinute, this.intListen, this.intKnow, this.intRelex, this.intWave, this.intMeditate, this.intLesson, this.intEmotion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profile': profile,
      'sex': sex,
      'age': age,
      'intExp': intExp,
      'intMinute': intMinute,
      'intListen': intListen,
      'intKnow': intKnow,
      'intRelex': intRelex,
      'intWave': intWave,
      'intMeditate': intMeditate,
      'intLesson': intLesson,
      'intEmotion': intEmotion
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, name: $name, age: $age, profile: $profile, sex: $sex, age: $age, intExp: $intExp, intMinute: $intMinute, intListen: $intListen, intKnow: $intKnow, intRelex: $intRelex, intWave: $intWave, intMeditate: $intMeditate, intLesson: $intLesson, intEmotion: $intEmotion}';
  }
}





class Awake {
  final int id;
  final int intKnow;
  final int intRelex;
  final int time;

  Awake({this.id, this.intKnow, this.intRelex, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'intKnow': intKnow,
      'intRelex': intRelex,
      'time': time,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Awake{id: $id, intKnow: $intKnow, intRelex: $intRelex, time: $time}';
  }
}


class Emotion {
  final int id;
  final int intEmotion;
  final int time;

  Emotion({this.id, this.intEmotion, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'intEmotion': intEmotion,
      'time': time,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Emotion{id: $id, intEmotion: $intEmotion, time: $time}';
  }
}

class Wave {
  final int id;
  final int time;
  final int wave;
  final String day;

  Wave({this.id,this.time, this.wave, this.day});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'wave': wave,
      'day' : day
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Wave{id: $id, time: $time, wave: $wave, day: $day}';
  }
}




class Waves {
  final int id;
  final DateTime time;
  final int wave;
  final String day;


  Waves(this.id,this.time, this.wave, this.day);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'wave': wave,
      'day' : day,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Waves{id: $id, time: $time, wave: $wave, day: $day}';
  }
}



class Know {
  final int id;
  final int time;
  final int know;
  final String day;

  Know({this.id,this.time, this.know, this.day});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'know': know,
      'day': day,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Know{id: $id, time: $time, know: $know, day: $day}';
  }
}


class Knows {
  final String id;
  final DateTime time;
  final int know;
  final String day;

  Knows(this.id, this.time, this.know, this.day);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'know': know,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Knows{id: $id, time: $time, know: $know, day: $day}';
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


class Relexs {
  final String id;
  final DateTime time;
  final int relex;
  final String day;

  Relexs(this.id, this.time, this.relex, this.day);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'relex': relex,
      'day': day,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Relexs{id: $id, time: $time, relex: $relex, day: $day}';
  }
}


class Emochart {
  final int id;
  final int emotion;
  final String text;
  final String color;

  Emochart({this.id,this.emotion, this.text, this.color});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotion': emotion,
      'text': text,
      'color': color,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Emochart{id: $id, emotion: $emotion, text: $text, color: $color}';
  }
}


class Emocharts {
  final int id;
  final int emotion;
  final String text;
  final charts.Color color;

  Emocharts(this.id, this.emotion, this.text, this.color);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotion': emotion,
      'text': text,
      'color': color,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Emocharts{id: $id, emotion: $emotion, text: $text, color: $color}';
  }
}



class Musiclike {
  final String id;
  final String url;
  final String title;
  final String artist;
  final String artwork;
  final String description;


  Musiclike(this.id, this.url, this.title, this.artwork, this.artist, this.description);

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
      'artwork': artwork,
      'artist':artist,
      'description':description
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Musiclike{id: $id, url: $url, title: $title, artwork: $artwork, artist: $artist, description: $description}';
  }
}



class Reward{
  final int id;
  final String rewardName;
  final String rewardPhoto;
  final String rewardDetail;

  Reward({this.id,this.rewardName,this.rewardPhoto, this.rewardDetail});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rewardName': rewardName,
      'rewardPhoto': rewardPhoto,
      'rewardDetail': rewardDetail,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Reward{id: $id, rewardName: $rewardName, rewardPhoto: $rewardPhoto, rewardDetail: $rewardDetail}';
  }
}