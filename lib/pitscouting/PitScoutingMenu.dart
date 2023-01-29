import 'package:flutter/material.dart';

class PitScoutingMenu extends StatelessWidget {
  const PitScoutingMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pit Scouting"),
        ),
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/pits.jpg"),
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
                        Navigator.pushNamed(context, "/scouting/pits/view");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image,
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
                        Navigator.pushNamed(context, "/scouting/pits/add");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.content_paste_go,
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
