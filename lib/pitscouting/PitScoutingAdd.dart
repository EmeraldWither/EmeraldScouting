import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../uploader.dart';

class PitScoutingAdd extends StatefulWidget {
  const PitScoutingAdd({Key? key}) : super(key: key);

  @override
  State<PitScoutingAdd> createState() => _PreScoutingState();
}

class _PreScoutingState extends State<PitScoutingAdd> {
  final _teamNumberKey = GlobalKey<FormState>();
  int _teamNum = -1;
  int _stage = 0;
  late CameraController _controller;

  late List<CameraDescription> _cameras;

  final Map<String, XFile> _confirmedImages = {};

  String _selectedType = 'Intake';

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
    );
  }


  Color getColor(String type) {
    if (_confirmedImages.keys.contains(type)) return Colors.green;
    return Colors.red;
  }

  FloatingActionButton? getActionButton() {
    if (_confirmedImages.keys.length == 4) {
      return FloatingActionButton(
          onPressed: () {
            for (var key in _confirmedImages.keys) {
              ScoutingUploader.uploadPitImage(
                  _teamNum, _confirmedImages[key]!, key);
            }
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.navigate_next));
    }
    return null;
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
    if (_stage == -1) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Pre-Scouting"),
        ),
        body: const Text("Camera access denied"),
      );
    }
    if (_stage == 0) return getStage1();
    if (_stage == 1) return getStage2();
    return getStage3();
  }
}

