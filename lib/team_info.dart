import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TeamInfo {
  var auth = "npE0id9QLI0lDa7d2PYdYGP3Pb3f8EcIm8TGrKllSm67BRdoZX9YOXMcEzGuSi9Q";
  int teamNum;
  String city = "unknown";
  String state = "unknown";
  int rookieYear = 0000;
  String name = "unknown";
  String website = "unknown";
  String school = "unknown";
  String country = "unknown";

  late Image pic;

  TeamInfo({required this.teamNum});

  Future<void> fetchData() async {
    var response = await get(
        Uri(
            scheme: 'https',
            host: "www.thebluealliance.com",
            path: 'api/v3/team/frc$teamNum'),
        headers: {"X-TBA-Auth-Key": auth});
    var picture = await get(
        Uri(
            scheme: 'https',
            host: "www.thebluealliance.com",
            path: 'api/v3/team/frc$teamNum/media/2022'),
        headers: {"X-TBA-Auth-Key": auth});

    Map data = jsonDecode(response.body);
    debugPrint(response.body);
    dynamic picData = jsonDecode(picture.body);
    city = data['city'];
    state = data['state_prov'];
    rookieYear = data['rookie_year'];
    name = data['nickname'];
    school = data['school_name'];
    website = data['website'];
    country = data['country'];

    pic = Image.memory(
      base64Decode(picData[0]['details']['base64Image'])
    );
  }
}
