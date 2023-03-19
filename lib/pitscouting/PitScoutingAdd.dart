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
  //scouting questions


  //0 - Cone
  //1 - Cube
  final _gamePieces = [false, false];
  String? _driveType;

  //intake dropdown menu
  String? _intakeTypeKey;
  String _intakeType = "";
  final TextEditingController _intakeTextController = TextEditingController();

  //0 - Hybrid Node
  //1 - Mid Node
  //2 - High Node
  final _nodes = [false, false, false];

  //0 - Charge Station Engage
  //1 - Score Cube
  //2 - Score Cone
  //3 - Mobility
  final _autoFeatures = [false, false, false, false];
  String _autoSpecialFeature = "";
  final TextEditingController _autoTextController = TextEditingController();

  //notes
  String _robotNotes = "";
  final TextEditingController _notesTextController = TextEditingController();


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
                          const SizedBox(height: 15),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Text(_selectedType, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 15),
              //Options selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Intake, Shooter, and Climber
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
                  //Intake, Shooter, and Climber
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedType = 'Drive';
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(getColor("Drive"))),
                      child: const Text("Drive"))
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
                            DropdownButton(
                              hint: const Text("Select Drive Type",
                                  style: TextStyle(fontSize: 14)),
                              items: const [
                                DropdownMenuItem<String>(
                                    value: "Tank Drive",
                                    child: Text("Tank Drive")),
                                DropdownMenuItem<String>(
                                    value: "Mecanum", child: Text("Mecanum")),
                                DropdownMenuItem<String>(
                                    value: "West Coast Drive",
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("West Coast Drive"),
                                        Text("East Coast Drive When??", style: TextStyle(fontSize: 6))
                                      ],
                                    )),
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

                  //Where can the robot score to to
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "Which GAME PIECES can the ROBOT score?",
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
                                    value: _gamePieces[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _gamePieces[0] = value!;
                                      });
                                    }),
                                widget: const Text("Cones", style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),)),
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _gamePieces[1],
                                    onChanged: (value) {
                                      setState(() {
                                        _gamePieces[1] = value!;
                                      });
                                    }),
                                widget: const Text("Cubes", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),))
                          ],
                        )
                      ],
                    ),
                  ),
                  //What kind of INTAKE does the robot have?
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "What kind of INTAKE does the ROBOT have?",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        //Text Field with questions
                        DropdownButton(
                          hint: const Text("Select Intake Type",
                              style: TextStyle(fontSize: 14)),
                          items: const [
                            DropdownMenuItem<String>(
                                value: "AndyMark Climber in a Box",
                                child: Text("AndyMark Climber in a Box")),
                            DropdownMenuItem<String>(
                                value: "Elevator with Intake",
                                child: Text("Elevator with Intake")),
                            DropdownMenuItem<String>(
                                value: "Big Arm in Center with a Grabber",
                                child: Text("Big Arm in Center with a Grabber")),
                            DropdownMenuItem<String>(
                                value: "No Intake",
                                child: Text("No Intake", style: TextStyle(color: Colors.red),)),
                            DropdownMenuItem<String>(
                                value: "Other",
                                child: Text("Other (Please Specify)")),
                          ],
                          isExpanded: false,
                          onChanged: (value) {
                            setState(() {
                              _intakeType = value!;
                              _intakeTypeKey = value;
                            });
                          },
                          value: _intakeTypeKey,
                        ),
                        if(_intakeTypeKey == "Other")
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(hintText: "Describe the ROBOT's intake"),
                              controller: _intakeTextController,
                                onChanged: (value) {
                              _intakeType = value;
                            }),
                          )
                      ],
                    ),
                  ),
                  //Where can the robot score to
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "Which NODES can the ROBOT score on?",
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
                            //middle rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _nodes[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _nodes[0] = value!;
                                      });
                                    }),
                                widget: const Text("Hybrid Node")),
                            //high rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _nodes[1],
                                    onChanged: (value) {
                                      setState(() {
                                        _nodes[1] = value!;
                                      });
                                    }),
                                widget: const Text("Middle Node")),
                            //traversal rung
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _nodes[2],
                                    onChanged: (value) {
                                      setState(() {
                                        _nodes[2] = value!;
                                      });
                                    }),
                                widget: const Text("High Node")),
                          ],
                        )
                      ],
                    ),
                  ),
                  //What can the robot do during autonomous
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "What can the ROBOT do during AUTO?",
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
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _autoFeatures[0],
                                    onChanged: (value) {
                                      setState(() {
                                        _autoFeatures[0] = value!;
                                      });
                                    }),
                                widget: const Text(
                                    "Engage with Charge Station")),
                            //score cone
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _autoFeatures[1],
                                    onChanged: (value) {
                                      setState(() {
                                        _autoFeatures[1] = value!;
                                      });
                                    }),
                                widget: const Text("Score a Cone")),
                            //score cube
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _autoFeatures[2],
                                    onChanged: (value) {
                                      setState(() {
                                        _autoFeatures[2] = value!;
                                      });
                                    }),
                                widget: const Text("Score a Cube")),
                            CheckboxButton(
                                checkbox: Checkbox(
                                    value: _autoFeatures[3],
                                    onChanged: (value) {
                                      setState(() {
                                        _autoFeatures[3] = value!;
                                      });
                                    }),
                                widget: const Text("Mobility")),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(hintText: "Describe the ROBOT's AUTO"),
                              controller: _autoTextController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) {
                                _autoSpecialFeature = value;
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Extra notes on the robot
                  MaterialBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.tightForFinite(
                              width: 300, height: 50),
                          child: const Text(
                            "Put some extra NOTES on the ROBOT",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        TextField(
                          controller: _notesTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) => _robotNotes = value,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 75,)
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
    if (_confirmedImages.keys.length == 2) {
      return FloatingActionButton(
          onPressed: () {
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
    ScoutingUploader.uploadPitScouting(_teamNum, _gamePieces, _driveType!, _intakeType!, _nodes, _autoFeatures, _autoSpecialFeature!, _robotNotes!);
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
          body: const Column(
            children: [
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
        const Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        )),
      ],
    );
  }
}
