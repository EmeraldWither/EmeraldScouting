import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PitScoutingViewer extends StatefulWidget {
  const PitScoutingViewer({Key? key}) : super(key: key);

  @override
  State<PitScoutingViewer> createState() => _PitScoutingViewerState();
}

class _PitScoutingViewerState extends State<PitScoutingViewer> {
  bool fetched = false;
  List<int> teams = [];

  void fetchData() async {
    var storage = await FirebaseStorage.instanceFor(
        bucket: "gs://robo-t-scouting.appspot.com");
    var dir = await storage.ref().child("mount-olive").listAll();
    for (var value in dir.prefixes) {
      String team = value.name.split("/").last;
      teams.add(int.parse(team));
    }
    teams.sort();
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!fetched) {
      fetchData();
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pit Scouting"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/scouting/pits/view/team",
                        arguments: teams[index]);
                  },
                  child: Text("Team ${teams[index]}")
              ),
            );
          },
        ),
      ),
    );
  }
}
