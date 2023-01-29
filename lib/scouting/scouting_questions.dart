import 'package:emeraldscouting/scouting/material_box.dart';
import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:emeraldscouting/uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ScoutingQuestions extends StatefulWidget {
  const ScoutingQuestions({Key? key}) : super(key: key);

  @override
  State<ScoutingQuestions> createState() => _ScoutingQuestionsState();
}

class _ScoutingQuestionsState extends State<ScoutingQuestions> {
  Map<String, dynamic>? info;
  late double rating;
  double _intakeRating = 0.0;
  bool _isRobotBroken = false;

  fetchInfo() {
    info = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    fetchInfo();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Scouting Questions"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var info = ScoutingInfo(
                teamNum: this.info!["team"],
                lowCargo: this.info!["lowcargo"],
                highCargo: this.info!["highcargo"],
                climbLevel: this.info!["climb"],
                matchNumber: this.info!["match"],
                rating: rating.toInt());
            Navigator.pop(context);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScoutingUploader.uploadScoutingInfo(info);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Scouting data saved", textAlign: TextAlign.center)));
          },
          heroTag: const Key("scouting_next"),
          child: const Icon(Icons.cloud_upload),
        ),
        body: Center(
          child: Column(
            children: [
              //Rate Driver Ability
              MaterialBox(
                child: Column(
                  children: [
                    const Text("Rate the driver's ability out of 5",
                        style: TextStyle(fontSize: 20)),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double value) {
                        rating = value;
                      },
                    )
                  ],
                ),
              ),
              //Rate the intake
              MaterialBox(
                child: Column(
                  children: [
                    const Text("Rate the robot's intake out of 5",
                        style: TextStyle(fontSize: 20)),
                    RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      onRatingUpdate: (double value) {
                        _intakeRating = value;
                      },
                    )
                  ],
                ),
              ),
              //Did the robot break down
              MaterialBox(
                child: Column(
                  children: [
                    const Text(
                      "Did the Robot break down during the match?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    //add a true and false button for the user
                    DropdownButton(
                      items: const [
                        DropdownMenuItem<bool>(
                            value: true,
                            child: Text("YES",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900))),
                        DropdownMenuItem<bool>(value: false, child: Text("No")),
                      ],
                      isExpanded: false,
                      onChanged: (value) {
                        setState(() {
                          _isRobotBroken = value as bool;
                        });
                      },
                      value: _isRobotBroken,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
