import 'package:emeraldscouting/scouting/view/event.dart';
import 'package:flutter/material.dart';

class EventDisplay extends StatefulWidget {
  const EventDisplay({Key? key}) : super(key: key);

  @override
  State<EventDisplay> createState() => _EventDisplayState();
}

class _EventDisplayState extends State<EventDisplay> {
  Event event = Event(name: "mount-olive");

  void fetchData() async {
    await event.fetchEventInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!event.fetched) {
      fetchData();
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: event.getMatches.length,
          itemBuilder: (context, index) {
            print(event.getMatches[index]);
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/scouting/event/view/match",
                        arguments: event.getMatches[index]);
                  },
                  child: _getMatchText(event.getMatches[index])
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _getMatchText(int matchNum){
    if(event.isMatchCached(matchNum)){
      return IntrinsicHeight(
        child: Stack(
          children: [
            const Align(alignment: Alignment.centerLeft, child: Icon(Icons.file_download_outlined)),
            Align(alignment: Alignment.center ,child: Text("Match $matchNum")),
          ],
        ),
      );
    }
    return IntrinsicHeight(
      child: Stack(
        children: [
          const Align(alignment: Alignment.centerLeft, child: Icon(Icons.cloud)),
          Align(alignment: Alignment.center ,child: Text("Match $matchNum")),
        ],
      ),
    );
  }
}
