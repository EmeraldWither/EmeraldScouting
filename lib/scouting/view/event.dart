import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldscouting/scouting/scouting_data.dart';

class Event {
  final String name;
  bool fetched = false;
  Map<int, bool> _matches = {};

  Event({required this.name});

  Future<void> fetchEventInfo() async {
    var event = FirebaseFirestore.instance.collection("matches").doc(name);
    var data = await event.get();
    var matches = data.data()!["matches"] as List<dynamic>;
    matches.sort();
    //Check cached versions
    var localMatches = await ScoutingData.scoutings;
    for(var match in localMatches){
      _matches.putIfAbsent(match.matchNumber, () => true);
    }
    //Then check our databaseflut
    for (var element in matches) {
      _matches.putIfAbsent(element, () => false);
    }
    _matches = Map.fromEntries(
        _matches.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    fetched = true;
  }
  bool isMatchCached(int matchNumber){
    return _matches[matchNumber] ?? false;
  }
  get getMatches => _matches.keys.toList();
}
