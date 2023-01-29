import 'dart:convert';

import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

class ScoutingData{
  static Future<List<ScoutingInfo>>get scoutings async {
    List<ScoutingInfo> scoutings = [];

    var fs = const LocalFileSystem();
    var dir = await getApplicationDocumentsDirectory();
    var file = fs.directory(dir.uri)
        .childDirectory("mount-olive");
    if(!file.existsSync()) return [];
    var event = file.listSync();
    for (var element in event) {
      var match = fs.directory(element.uri);
      match.listSync().forEach((element) {
        var team = fs.file(element.uri);
        String name = team.basename.split(".")[0];
        int lowCargo = -1;
        int highCargo = -1;
        int climbLevel = -1;
        int teamNum = -1;
        int matchNumber = -1;
        int rating = -1;
        if(name.endsWith("-info")){
          String data = team.readAsStringSync();
          var json = jsonDecode(data);
          print(json);
          lowCargo = json["lowcargo"];
          highCargo = json["highcargo"];
          climbLevel = json["climb"];
          teamNum = int.parse(name.split("-")[0]);
          matchNumber = int.parse(match.basename.split("-")[1]);
        }
        scoutings.add(ScoutingInfo(teamNum: teamNum, lowCargo: lowCargo, highCargo: highCargo, climbLevel: climbLevel, matchNumber: matchNumber, rating: rating));
      });
    }
    return scoutings;
  }
}