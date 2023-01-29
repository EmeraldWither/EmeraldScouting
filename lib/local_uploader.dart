import 'package:emeraldscouting/scouting/scouting_data.dart';
import 'package:emeraldscouting/scouting/scouting_info.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LocalUploader extends StatefulWidget {
  const LocalUploader({Key? key}) : super(key: key);

  @override
  State<LocalUploader> createState() => _LocalUploaderState();
}

class _LocalUploaderState extends State<LocalUploader> {
  int index = 0;

  var stage = 1;
  List<ScoutingInfo> infos = [];
  bool inRange(index) => index >= 0 && index < infos.length;
  void update() async{
    infos = await ScoutingData.scoutings;
    setState(() {
      stage = 2;
    });
  }
  Widget getStageOne(){
    update();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local Uploader"),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget getStageTwo(){
    if(infos.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: const Text("Local Scouting Uploader"),
        ),
        body: const Center(
          child: Text("No scouting data to upload"),
        ),
      );
    }
    ScoutingInfo info = infos[index];
    print(info.toString());
    QrImage image = QrImage(
      data: info.toString(),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text("Local Uploader"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Match ${info.matchNumber}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 3)),
                  Text("Team ${info.teamNum}", style: const TextStyle(fontSize: 32, fontStyle: FontStyle.italic)),
                ],
              ),
              Column(
                children: [
                  image,

                  Text("${index + 1}/${infos.length}", style: const TextStyle(fontSize: 32, fontStyle: FontStyle.italic)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(inRange(index - 1)){
                          index--;
                        }
                      });
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(inRange(index + 1)){
                          index++;
                        }
                      });
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return stage == 1 ? getStageOne() : getStageTwo();
  }
}
