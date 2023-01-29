import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file/local.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';


class ScoutingUploader {
  static void uploadScoutingInfo(ScoutingInfo info) async {
    final data = {
      "team": info.teamNum,
      "highcargo": info.highCargo,
      "lowcargo": info.lowCargo,
      "climb": info.climbLevel,
      "rating": info.rating
    };
    FirebaseFirestore.instance.collection("matches").doc("mount-olive")
        .collection("match-${info.matchNumber}").doc("team${info.teamNum}")
        .set(data);
    ensureMatchNumbers(info.matchNumber);

    //Now store in local storage
    var fs = const LocalFileSystem();
    var dir = await getApplicationDocumentsDirectory();
    var file = await fs.directory(dir.uri)
        .childDirectory("mount-olive")
        .childDirectory("match-${info.matchNumber}")
        .childFile("${info.teamNum}-info").create(recursive: true);
    await file.writeAsString(jsonEncode(data));
  }

  static Future<ScoutingInfo> fetchData(int team, int matchNumber) async {
    final data = await FirebaseFirestore.instance.collection("matches").doc(
        "mount-olive").collection("match-$matchNumber").doc("team$team").get();
    return ScoutingInfo(teamNum: team,
        lowCargo: data["lowcargo"],
        highCargo: data["highcargo"],
        climbLevel: data["climb"],
        matchNumber: matchNumber,
        rating: data["rating"]
    );
  }
  static void uploadPitImage(int team, XFile image, String type) async{
    File file = File(image.path);
    print(image.path);
    var storage = FirebaseStorage.instanceFor(bucket: "gs://robo-t-scouting.appspot.com");
    var teamFolder = storage.ref().child("mount-olive/").child("$team/").child("$type.png");
    await teamFolder.putFile(file, SettableMetadata(contentType: "image/png"));
  }

  static void ensureMatchNumbers(int matchNum) async {
    var doc = await FirebaseFirestore.instance.collection("matches").doc(
        "mount-olive").get();
    List<dynamic> arr = [];
    if (doc.data() != null && doc.data()!["matches"] != null) {
      arr = List<dynamic>.from(doc.data()!["matches"]);
    }
    arr.add(matchNum);
    arr = arr.toSet().toList();
    final Map<String, dynamic> data = {
      "event-id": "mount-olive",
      "matches": arr
    };
    FirebaseFirestore.instance.collection("matches").doc("mount-olive").set(
        data);
  }

}