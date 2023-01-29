import 'package:flutter/material.dart';

class ScoutingEventMain extends StatelessWidget {
  const ScoutingEventMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Scouting"),
        ),
        backgroundColor: Colors.black,

        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/event.png"),
                fit: BoxFit.cover,
                opacity: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),

                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/scouting/event/view");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.view_agenda,
                            size: 192,
                          ),
                          Text("View Data", style: TextStyle(fontSize: 52))
                        ],
                      )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/scouting/event/add");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.cloud_upload_sharp,
                            size: 192,
                          ),
                          Text("Post Data", style: TextStyle(fontSize: 52))
                        ],
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
