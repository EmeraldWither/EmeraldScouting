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
            .child("mount-olive")
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
            children: [getFeaturesWidget(), getDriveWidget(), getIntakeWidget(),getShooterWidget(), getClimbWidget()],
          ),
        ),
      ),
    );
  }

  Widget getClimbWidget() {
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Climb",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: _images["Climb"]!,
            ),
            //Rungs climable to
            const SizedBox(height: 20),
            const Text("Can Climb To",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            if (_questions["rungs"][3])
              const Text("Traversal", style: TextStyle(fontSize: 24)),
            if (_questions["rungs"][2])
              const Text("High", style: TextStyle(fontSize: 24)),
            if (_questions["rungs"][1])
              const Text("Mid", style: TextStyle(fontSize: 24)),
            if (_questions["rungs"][0])
              const Text("Low", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget getFeaturesWidget() {
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Features",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_questions["features"][0])
              const Text("Limelight", style: TextStyle(fontSize: 24)),
            if (_questions["features"][1])
              const Text("Dual Intake", style: TextStyle(fontSize: 24)),
            if (_questions["features"][2])
              const Text("Auto", style: TextStyle(fontSize: 24))
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
            Text("${_questions["driveType"]}",
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
            const Text("Cargo Capacity",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            //What drivedrain type
            Text("${_questions["cargoCapacity"]}",
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );

  }

  Widget getShooterWidget(){
    return MaterialBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Shooter",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: _images["Shooter"]!,
            ),
            const SizedBox(height: 20),
            const Text("Shooter Cycle Time",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            //What drivedrain type
            Text("${_questions["cycleTime"]} seconds",
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text("Can Shoot To",
                style: TextStyle(fontSize: 32,decoration: TextDecoration.underline, fontWeight: FontWeight.bold)),
            if (_questions["hubs"][1])
              const Text("High", style: TextStyle(fontSize: 24)),
            if (_questions["hubs"][0])
              const Text("Low", style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );

  }
}
