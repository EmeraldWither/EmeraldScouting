import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _controller;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool verifed = false;

  late String name = "Unknown";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.clear();
    signInWithGoogle(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void signInWithGoogle(bool logout) async {
    if (logout) {
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    }
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if(googleUser == null) {
      signInWithGoogle(false);
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    var email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      signInWithGoogle(true);
      return;
    } else if (logout &&
            FirebaseAuth.instance.currentUser?.emailVerified == false ||
        (email.endsWith("@mahwah.k12.nj.us") == false && email != "bikechamp007@gmail.com")) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Invalid email"),
            content: const Text(
                "You have an invalid email. Please login with your school email.\nIf you believe this to be an error, please contact the programming officer."),
            actions: [
              TextButton(
                onPressed: () {
                  signInWithGoogle(true);
                  setState(() {});
                },
                child: const Text("Log in with a different account"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      name = FirebaseAuth.instance.currentUser!.displayName!;
      verifed = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have been logged in successfully")));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (verifed) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleTextStyle: const TextStyle(fontSize: 24),
            title: const Text("Robo-T Scouting", textAlign: TextAlign.center),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, "/upload");
            },
            heroTag: const Key("local_upload"),
            child: const Icon(Icons.qr_code_2),
          ),
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                flex: 9,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/scouting/pits/");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pits.jpg'),
                          fit: BoxFit.cover,
                          opacity: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "PITS",
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/scouting/event');
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/event.png'),
                          fit: BoxFit.cover,
                          opacity: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "MATCH",
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }
    precacheImage(Image.asset("assets/images/event.png").image, context);
    precacheImage(Image.asset("assets/images/pits.jpg").image, context);
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Logging you in...", style: TextStyle(color: Colors.white)),
      )
    );
  }
}
