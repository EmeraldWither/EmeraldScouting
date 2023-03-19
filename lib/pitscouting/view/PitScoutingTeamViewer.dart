import 'package:emeraldscouting/scouting/material_box.dart';
import 'package:emeraldscouting/uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PitScoutingTeamViewer extends StatefulWidget {
  const PitScoutingTeamViewer({Key? key}) : super(key: key);

  @override
  State<PitScoutingTeamViewer> createState() => _PitScoutingTeamViewerState();
}

class _PitScoutingTeamViewerState extends State<PitScoutingTeamViewer> {
  final Map<String, Image> _images = {};
  bool fetched = false;
  Map<String, dynamic> _questions = {};

  void fetchData(BuildContext context) async {
    int team = ModalRoute.of(context)?.settings.arguments as int;
    var dir =
        FirebaseStorage.instanceFor(bucket: "gs://robo-t-scouting.appspot.com")
            .ref()
            .child("warren-hills")
            .child("$team");
    var images = await dir.listAll();
    for (var image in images.items) {
      var type = image.name.replaceAll(".png", "");
      var data = await image.getData();
      if (data == null) continue;
      Image img = Image.memory(data);
      _images[type] = img;
    }
    _questions = await ScoutingUploader.getPitQuestions(team);
    if (!mounted) return;
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!fetched) {
      fetchData(context);
      return Scaffold(
        appBar: AppBar(
          title:
              Text("Team ${ModalRoute.of(context)?.settings.arguments as int}"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Loading..."),
              SizedBox(height: 10),
              CircularProgressIndicator()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Team ${ModalRoute.of(context)?.settings.arguments as int}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 6,
          child: ListView(
            children: [getAutoWidget(), getDriveWidget(), getIntakeWidget(), getRobotNotes()],
          ),
        ),
      ),
    );
  }

  Widget getAutoWidget() {
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Autonomous",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_questions["autoFeatures"][0])
              const Text("Charge Station Auto Balance", style: TextStyle(fontSize: 24)),
            if (_questions["autoFeatures"][1])
              const Text("Score Cube", style: TextStyle(fontSize: 24)),
            if (_questions["autoFeatures"][2])
              const Text("Score Cone", style: TextStyle(fontSize: 24)),
            if (_questions["autoFeatures"][3])
              const Text("Mobility", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Divider(thickness: 2),
            Text(_questions["autoNotes"], style: const TextStyle(fontSize: 24))
          ],
        ),
      ),
    );
  }

  Widget getDriveWidget() {
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Drive",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: _images["Drive"]!,
            ),
            const SizedBox(height: 20),
            const Text("Drivetrain Type",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            //What drivedrain type
            Text("${_questions["drivetrainType"]}",
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
  Widget getRobotNotes(){
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Robot Notes",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
           //What drivedrain type
            Text("${_questions["robotNotes"]}",
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
  Widget getIntakeWidget(){
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Intake",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: _images["Intake"]!,
            ),
            const SizedBox(height: 20),

            //intake type
            const Text("Intake Type",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            Text("${_questions["intakeType"]}", style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 20),
            //what game pieces
            const Text("Game Pieces",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            if(_questions["gamePieces"][0] == true)
              const Text("Cone", style: TextStyle(color: Colors.yellowAccent, fontSize: 24, fontWeight: FontWeight.bold),),
            if(_questions["gamePieces"][1] == true)
              const Text("Cube", style: TextStyle(color: Colors.purple, fontSize: 24, fontWeight: FontWeight.bold),),
            if(_questions["gamePieces"][1] == false && _questions["gamePieces"][0] == false)
              const Text("None", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),),


            const SizedBox(height: 20),
            const Text("Nodes",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            if(_questions["nodes"][0] == true)
              const Text("Hybrid", style: TextStyle(fontSize: 24)),
            if(_questions["nodes"][1] == true)
              const Text("Mid", style: TextStyle(fontSize: 24)),
            if(_questions["nodes"][2] == true)
              const Text("High", style: TextStyle(fontSize: 24)),
            if(_questions["nodes"][2] == false && _questions["nodes"][1] == false && _questions["nodes"][0] == false)
              const Text("None", style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );

  }
}
