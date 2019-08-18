import 'package:devfest_levante_2019/model/DevFestUser.dart';
import 'package:devfest_levante_2019/ui/HomePage.dart';
import 'package:devfest_levante_2019/repository/UserRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreenPage> {
  bool isLoggedIn;

  @override
  void initState() {
    isLoggedIn = false;

    // Check from Firebase if user is logged in or not
    // Update isLoggedIn value in state
    FirebaseAuth.instance.currentUser().then((user) => user != null
        ? setState(() {
            isLoggedIn = true;
          })
        : null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Return SchedulePage or LoginPage
    return isLoggedIn ? HomePage() : LoginScreen();
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevFest Levante 2019',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreenWidget(),
      ),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/home.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42.0),
              child: Image(
                image: AssetImage('assets/login.png'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/2),// you will get value which is 1/3rd part of height of your device screen
            RaisedButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                textColor: Colors.blueAccent,
                onPressed: () {
                  _handleSignIn(context);
                },
                child: Text("LOGIN WITH GOOGLE",)),
          ],
        ),
      ),
    );
  }

  // We use Future and not a Stream (like in Firestore) because we need
  // to listen for only ONE event.
  // Stream will leave an open connection instead (ex for realtime database).
  // TODO: Maybe consider to use Future when downloading talks too, since they won't change often
  _handleSignIn(context) async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    // Login done, create user in Firestore
    UserRepository repo = UserRepository(user.uid);
    var devFestUser = DevFestUser();
    devFestUser.userId = user.uid;
    devFestUser.email = user.email;
    devFestUser.displayName = user.displayName;
    await repo.createNewUser(devFestUser);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }
}
