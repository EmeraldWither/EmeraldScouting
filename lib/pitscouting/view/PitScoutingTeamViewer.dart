import 'package:emeraldscouting/scouting/material_box.dart';
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
    if(!mounted) return;
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!fetched){
      fetchData(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Team ${ModalRoute.of(context)?.settings.arguments as int}"),
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
        body: ListView.builder(
          itemCount: _images.keys.length,
          itemBuilder: (context, index) {
            var key = _images.keys.elementAt(index);
            return MaterialBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(key,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _images[key]!,
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
