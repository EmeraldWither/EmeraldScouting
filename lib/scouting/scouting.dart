import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:emeraldscouting/uploader.dart';
import 'package:flutter/material.dart';

import 'material_box.dart';

class Scouting extends StatefulWidget {
  const Scouting({Key? key}) : super(key: key);

  @override
  State<Scouting> createState() => _ScoutingState();
}

class _ScoutingState extends State<Scouting> {
  int stage = 1;
  int matchNumber = -1;

  int teamNum = 0;
  int lowCargo = 0;
  int highCargo = 0;
  int climbLevel = -1;

  final _teamNumberKey = GlobalKey<FormState>();
  final FocusNode _teamNumberFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (stage == 1 || stage == 2 || stage == 3) {
      String request;
      switch (stage) {
        case 1:
          request = "Enter the team number";
          break;
        case 2:
          request = "Enter the match number";
          break;
        case 3:
          request = "Enter the match number";
          break;
        default:
          request = "Error";
      }
      int maxLength = stage == 1 ? 4 : 2;
      if(stage == 2){
        FocusScope.of(context).unfocus();
        stage = 3;
      }
      return Scaffold(
          appBar: AppBar(
            title: const Text("Scouting"),
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              request,
              style: const TextStyle(fontSize: 30),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(105, 0, 105, 15),
                child: Form(
                  key: _teamNumberKey,
                  child: TextFormField(
                    maxLength: maxLength,
                    keyboardType: TextInputType.number,
                    focusNode: _teamNumberFocus,
                    autofocus: false,
                    onChanged: (value) {
                      if(stage == 1) {
                        teamNum = int.parse(value);
                      } else {
                        matchNumber = int.parse(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value!';
                      }
                      return null;
                    },
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  if (_teamNumberKey.currentState!.validate()) {
                    _teamNumberKey.currentState!.reset();
                    setState(() {
                      stage++;
                    });
                  }
                },
                child: const Icon(Icons.navigate_next))
          ]));
    }
    int totalScore = (lowCargo) + (highCargo * 2);

    String climbString = "None";
    switch (climbLevel) {
      case 0:
        climbString = "Low";
        totalScore += 4;
        break;
      case 1:
        climbString = "Mid";
        totalScore += 6;
        break;
      case 2:
        climbString = "High";
        totalScore += 10;
        break;
      case 3:
        climbString = "Traversal";
        totalScore += 15;
        break;
      default:
        climbString = "None";
        break;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Scouting"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var info = {
              "team": teamNum,
              "lowcargo": lowCargo,
              "highcargo": highCargo,
              "climb": climbLevel,
              "match": matchNumber,
            };

            Navigator.pushReplacementNamed(context, "/scouting/questions", arguments: info);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Please answer the following questions",
                    textAlign: TextAlign.center)));
          },
          heroTag: const Key("scouting_next"),
          child: const Icon(Icons.navigate_next),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                "Team $teamNum",
                style:
                    const TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
              )),
            ),
            MaterialBox(
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Total Score",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "$totalScore",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 20, 24, 34),
                              color: Colors.black12,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "Level",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        climbString,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              color: Colors.black12,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "Score",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(children: [
                                            const Text(
                                              "HIGH",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "$highCargo Cargo",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ]),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(children: [
                                            const Text(
                                              "LOW",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "$lowCargo Cargo",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ])
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.black12,
                      child: Column(
                        children: [
                          const Text(
                            "Climbing\n Level",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          FloatingActionButton(
                              heroTag: const Key("climbPlus"),
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.arrow_upward),
                              onPressed: () {
                                setState(() {
                                  if (climbLevel < 3) {
                                    climbLevel++;
                                  }
                                });
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          FloatingActionButton(
                            heroTag: const Key("climbMinus"),
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.arrow_downward),
                            onPressed: () {
                              setState(() {
                                if (climbLevel > -1) {
                                  climbLevel--;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      color: Colors.black12,
                      child: Column(
                        children: [
                          const Text(
                            "Cargo",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "\nHIGH",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FloatingActionButton(
                                      heroTag: const Key("highCargoPlus"),
                                      backgroundColor: Colors.green,
                                      child: const Icon(Icons.exposure_plus_2),
                                      onPressed: () {
                                        setState(() {
                                          highCargo++;
                                        });
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  FloatingActionButton(
                                    heroTag: const Key("highCargoMinus"),
                                    backgroundColor: Colors.red,
                                    child: const Icon(Icons.exposure_minus_2),
                                    onPressed: () {
                                      setState(() {
                                        if (highCargo > 0) {
                                          highCargo--;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "\nLOW",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FloatingActionButton(
                                      heroTag: const Key("lowCargoPlus"),
                                      backgroundColor: Colors.lightGreen,
                                      child: const Icon(Icons.exposure_plus_1),
                                      onPressed: () {
                                        setState(() {
                                          lowCargo++;
                                        });
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  FloatingActionButton(
                                    heroTag: const Key("lowCargoMinus"),
                                    backgroundColor: Colors.redAccent,
                                    child: const Icon(Icons.exposure_minus_1),
                                    onPressed: () {
                                      setState(() {
                                        if (lowCargo > 0) {
                                          lowCargo--;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
