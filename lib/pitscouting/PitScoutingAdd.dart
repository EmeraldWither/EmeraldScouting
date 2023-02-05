import 'package:camera/camera.dart';
import 'package:emeraldscouting/RadioButton.dart';
import 'package:flutter/material.dart';

import '../CheckboxButton.dart';
import '../scouting/material_box.dart';
import '../uploader.dart';

class PitScoutingAdd extends StatefulWidget {
  const PitScoutingAdd({Key? key}) : super(key: key);

  @override
  State<PitScoutingAdd> createState() => _PreScoutingState();
}

class _PreScoutingState extends State<PitScoutingAdd> {
  final _teamNumberKey = GlobalKey<FormState>();
  final _cycleTimeKey = GlobalKey<FormState>();
  final _scrollController = ScrollController(initialScrollOffset: 0);

  int _teamNum = -1;
  int _stage = 0;
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  final Map<String, XFile> _confirmedImages = {};
  String _selectedType = 'Intake';

  //PIT SCOUTING QUESTIONS
  int _cargoHold = 1;

  //0 - Low
  //1 - High
  final _hubs = [false, false];
  String? _driveType;
  double _cycleTime = 0;

  //0 - Low
  //1 - Mid
  //2 - High
  //3 - Traversal
  final _rungs = [false, false, false, false];

  //0 - Limelight with Aim Assist
  //1 - Dual Intake
  //2 - Autonomous
  final _features = [false, false, false];

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
    _controller.dispose();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    _cameras = await availableCameras();
    _controller =
        CameraController(_cameras[0], ResolutionPreset.max, enableAudio: false);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.setFlashMode(FlashMode.off);

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            setState(() {
              _stage = -2;
            });
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  //Widgets for the Staeges of the Pit Scouting
  Widget getStage1() {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pre-Scouting"),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Enter a team number",
            style: TextStyle(fontSize: 30),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(105, 0, 105, 15),
              child: Form(
                key: _teamNumberKey,
                child: TextFormField(
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  onChanged: (value) {
                    _teamNum = int.parse(value);
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
                    _stage = 1;
                  });
                }
              },
              child: const Icon(Icons.navigate_next))
        ]));
  }

  Widget getStage2() {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pit Scouting"),
        ),
        floatingActionButton: getActionButton(),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(7, 7, 7, 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Team $_teamNum", style: const TextStyle(fontSize: 48)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Center(
                        child: CameraPreview(_controller),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                var type = _selectedType;
                                _controller.takePicture().then((value) {
                                  setState(() {
                                    _confirmedImages[type] = value;
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 8, 25, 8)),
                              child: const Icon(Icons.camera_alt, size: 35)),
                          const SizedBox(height: 5),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(_selectedType, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 15),
              //Options selection
              Column(
                children: [
                  //Intake, Shooter, and Climber
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Intake';
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  getColor("Intake"))),
                          child: const Text("Intake")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Shooter';
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  getColor("Shooter"))),
                          child: const Text("Shooter")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Climb';
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(getColor("Climb"))),
                          child: const Text("Climb"))
                    ],
                  ),
                  //Intake, Shooter, and Climber
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedType = 'Drive';
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(getColor("Drive"))),
                          child: const Text("Drive")),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget getStage3() {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Scouting Questions"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _stage = 3;
            });
          },
          heroTag: const Key("scouting_next"),
          child: const Icon(Icons.cloud_upload),
        ),
        //Use a gesture detector to allow clicking off of the text field input
        body: GestureDetector(
          onTap: () {
            // call this method here to hide soft keyboard
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 6,
              controller: _scrollController,
              child: ListView(
                children: [
                  //Drive Train Type
                  MaterialBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Drive Train Type",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24),
                            ),
                            //add a true and false button for the user
                            DropdownButton(
                              hint: const Text("Select Drive Type",
                                  style: TextStyle(fontSize: 14)),
                              items: const [
                                DropdownMenuItem<String>(
                                    value: "Tank Drive (KOP)",
                                    child: Text("Tank Drive (KOP)")),
                                DropdownMenuItem<String>(
                                    value: "Tank Drive",
                                    child: Text("Tank Drive")),
                                DropdownMenuItem<String>(
                                    value: "Mecanum", child: Text("Mecanum")),
                                DropdownMenuItem<String>(
                                    value: "West Coast Drive",
                                    child: Text("West Coast Drive")),
                                DropdownMenuItem<String>(
                                    value: "Swerve Drive",
                                    child: Text("Swerve Drive")),
                              ],
                              isExpanded: false,
                              onChanged: (value) {
                                setState(() {
                                  _driveType = value as String;
                                });
                              },
                              value: _driveType,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  //How much cargo can the robot hold (pain and suffering)
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "How much cargo can the ROBOT hold at a time?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Radial Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //0 Cargo
                            RadioButton(
                                radio: Radio(
                                  value: 0,
                                  groupValue: _cargoHold,
                                  onChanged: (value) {
                                    setState(() {
                                      _cargoHold = value as int;
                                    });
                                  },
                                ),
                                widget: const Text("0",
                                    style: TextStyle(fontSize: 16))),
                            const SizedBox(width: 20),
                            //1 Cargo
                            RadioButton(
                                radio: Radio(
                                  value: 1,
                                  groupValue: _cargoHold,
                                  onChanged: (value) {
                                    setState(() {
                                      _cargoHold = value as int;
                                    });
                                  },
                                ),
                                widget: const Text("1",
                                    style: TextStyle(fontSize: 16))),
                            const SizedBox(width: 20),
                            //2 Cargo
                            RadioButton(
                                radio: Radio(
                                  value: 2,
                                  groupValue: _cargoHold,
                                  onChanged: (value) {
                                    setState(() {
                                      _cargoHold = value as int;
                                    });
                                  },
                                ),
                                widget: const Text("2",
                                    style: TextStyle(fontSize: 16))),
                            const SizedBox(width: 20),
                            //2 Cargo
                            RadioButton(
                                radio: Radio(
                                  value: 3,
                                  groupValue: _cargoHold,
                                  onChanged: (value) {
                                    setState(() {
                                      _cargoHold = value as int;
                                    });
                                  },
                                ),
                                widget: const Text("3",
                                    style: TextStyle(fontSize: 16)))
                          ],
                        )
                      ],
                    ),
                  ),
                  //Where can the robot shoot to
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "Which HUB can the ROBOT score on?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Radial Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Low Cargo
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _hubs[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _hubs[0] = value!;
                                      });
                                    }),
                                widget: const Text("Low Hub")),
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _hubs[1],
                                    onChanged: (value) {
                                      print("got changed");
                                      setState(() {
                                        _hubs[1] = value!;
                                      });
                                    }),
                                widget: const Text("High Hub"))
                          ],
                        )
                      ],
                    ),
                  ),
                  //What is the average cycle time for a robot
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "What is the average cycle time for the ROBOT?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Text Field with questions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //input field
                            Form(
                              key: _cycleTimeKey,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: "seconds",
                                          alignLabelWithHint: true),
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      onEditingComplete: () {
                                        _cycleTimeKey.currentState?.validate();
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          _cycleTime = 0;
                                        } else {
                                          _cycleTime = double.parse(value);
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a value!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  //Where can the robot climb to
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "Which RUNGS can the ROBOT climb on?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Radial Buttons
                        Wrap(
                          direction: Axis.vertical,
                          verticalDirection: VerticalDirection.up,
                          children: [
                            //Low Rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _rungs[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _rungs[0] = value!;
                                      });
                                    }),
                                widget: const Text("Low Rung")),
                            //middle rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _rungs[1],
                                    onChanged: (value) {
                                      setState(() {
                                        _rungs[1] = value!;
                                      });
                                    }),
                                widget: const Text("Middle Rung")),
                            //high rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _rungs[2],
                                    onChanged: (value) {
                                      setState(() {
                                        _rungs[2] = value!;
                                      });
                                    }),
                                widget: const Text("High Rung")),
                            //traversal rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _rungs[3],
                                    onChanged: (value) {
                                      setState(() {
                                        _rungs[3] = value!;
                                      });
                                    }),
                                widget: const Text("Traversal Rung")),
                          ],
                        )
                      ],
                    ),
                  ),
                  //What features does the robot have
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "What features does the ROBOT have?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Radial Buttons
                        Wrap(
                          direction: Axis.vertical,
                          children: [
                            //Low Rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _features[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _features[0] = value!;
                                      });
                                    }),
                                widget: const Text(
                                    "Limelight w/ Aim Assist/Auto Shoot")),
                            //middle rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _features[1],
                                    onChanged: (value) {
                                      setState(() {
                                        _features[1] = value!;
                                      });
                                    }),
                                widget: const Text("Dual Intake")),
                            //high rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _features[2],
                                    onChanged: (value) {
                                      setState(() {
                                        _features[2] = value!;
                                      });
                                    }),
                                widget: const Text("Autonomous")),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Color getColor(String type) {
    if (_confirmedImages.keys.contains(type)) return Colors.green;
    return Colors.red;
  }

  FloatingActionButton? getActionButton() {
    if (_confirmedImages.keys.length == 4) {
      return FloatingActionButton(
          onPressed: () {
            // for (var key in _confirmedImages.keys) {
            //   ScoutingUploader.uploadPitImage(
            //       _teamNum, _confirmedImages[key]!, key);
            // }
            // Navigator.of(context).pop();
            setState(() {
              _stage = 2;
            });
          },
          child: const Icon(Icons.navigate_next));
    }
    return null;
  }

  void uploadData() async {
    for (String fileName in _confirmedImages.keys) {
      await ScoutingUploader.uploadPitImage(
          _teamNum, _confirmedImages[fileName]!, fileName);
    }
    ScoutingUploader.uploadPitScouting(_teamNum, _cargoHold, _hubs, _driveType!,
        _cycleTime, _rungs, _features);
    print("finished!");
    pop();
  }

  void pop() {
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_stage == -2) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
            centerTitle: true,
            titleTextStyle: const TextStyle(fontSize: 30),
            title: const Text("SCOUTING FAILED"),
          ),
          backgroundColor: const Color.fromRGBO(255, 0, 0, 1),
          body: Column(
            children: const [
              Icon(Icons.warning_amber_rounded, size: 300, color: Colors.white),
              Text("SEVERE ERROR",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 5,
                      fontSize: 48,
                      decoration: TextDecoration.underline)),
              SizedBox(height: 10),
              Text(
                  "Camera access denied. \n\nPlease allow camera access in settings.",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                  textAlign: TextAlign.center)
            ],
          ));
    }
    if (_stage == 0) return getStage1();
    if (_stage == 1) return getStage2();
    if (_stage == 2) return getStage3();

    uploadData();
    return Stack(
      children: [
        getStage3(),
        const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black)),
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        )),
      ],
    );
  }
}
