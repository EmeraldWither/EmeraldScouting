import 'package:emeraldscouting/local_uploader.dart';
import 'package:emeraldscouting/pitscouting/PitScoutingAdd.dart';
import 'package:emeraldscouting/pitscouting/PitScoutingMenu.dart';
import 'package:emeraldscouting/pitscouting/view/PitScoutingTeamViewer.dart';
import 'package:emeraldscouting/pitscouting/view/PitScoutingView.dart';
import 'package:emeraldscouting/scouting/scouting.dart';
import 'package:emeraldscouting/scouting/scouting_main.dart';
import 'package:emeraldscouting/scouting/scouting_questions.dart';
import 'package:emeraldscouting/scouting/view/event_display.dart';
import 'package:emeraldscouting/scouting/view/match_display.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(routes: {
    '/upload': (context) => const LocalUploader(),
    '/scouting/event': (context) => const ScoutingEventMain(),
    '/scouting/event/add': (context) => const Scouting(),
    '/scouting/questions': (context) => const ScoutingQuestions(),
    '/scouting/event/view': (context) => const EventDisplay(),
    '/scouting/event/view/match': (context) => const MatchDisplay(),
    '/scouting/pits/': (context) => const PitScoutingMenu(),
    '/scouting/pits/add': (context) => const PitScoutingAdd(),
    '/scouting/pits/view': (context) => const PitScoutingViewer(),
    '/scouting/pits/view/team': (context) => const PitScoutingTeamViewer(),

  }, home: const Home()));

}
