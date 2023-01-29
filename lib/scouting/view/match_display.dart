import 'dart:ui';

import 'package:emeraldscouting/climb_utils.dart';
import 'package:emeraldscouting/scouting/material_box.dart';
import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MatchDisplay extends StatefulWidget {
  const MatchDisplay({Key? key}) : super(key: key);

  @override
  State<MatchDisplay> createState() => _MatchDisplayState();
}

class _MatchDisplayState extends State<MatchDisplay> {
  List<ScoutingInfo> scoutingInfo = [];

  void fetchData(int matchNum) async {
    var documents = await FirebaseFirestore.instance
        .collection("matches")
        .doc("mount-olive")
        .collection("match-$matchNum")
        .get();
    for (var element in documents.docs) {
      var data = element.data();

      scoutingInfo.add(ScoutingInfo(
          teamNum: data["team"],
          lowCargo: data["lowcargo"],
          highCargo: data["highcargo"],
          climbLevel: data["climb"],
          matchNumber: matchNum,
          rating: data["rating"]));
      }
          setState((){});
  }

  @override
  Widget build(BuildContext context) {
    //if info is null, then we haven't fetched the data yet
    if (scoutingInfo.isEmpty) {
      fetchData(ModalRoute
          .of(context)
          ?.settings
          .arguments as int);
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Match ${scoutingInfo[0].matchNumber}"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: scoutingInfo.length,
          itemBuilder: (context, index) {
            return Card(
                elevation: 7,
                margin: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: ListTile(
                  minVerticalPadding: 10,
                  title: Text("Team ${scoutingInfo[index].teamNum}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    children: [
                      const Divider(thickness: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text("High Cargo", style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(scoutingInfo[index].highCargo.toString(),
                                  style: const TextStyle(fontSize: 16,)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("Low Cargo", style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(scoutingInfo[index].lowCargo.toString(),
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          const Text("Climb Level", style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(ClimbUtils.getLevel(scoutingInfo[index]
                              .climbLevel), style: const TextStyle(
                              fontSize: 16)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          const Text("Total Score", style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                          Text("${scoutingInfo[index].getTotalScore} points",
                              style: const TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: RatingBar.builder(
                          initialRating: scoutingInfo[index].rating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0),
                          itemBuilder: (context, _) =>
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (double value) {},
                        ),
                      )
                    ],
                  ),
                )
            );
          },
        ),
      ),
    );
  }
}
