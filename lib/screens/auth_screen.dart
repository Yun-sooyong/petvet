import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

/*
String name;
String email;
String imageUrl;
*/

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isVisible = false;

  Future<User> _signIn() async {
    //await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    User user = (await auth.signInWithCredential(credential)).user;

    /*if (user != null) {
      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;
    }*/
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var swidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 로그인 페이지 로고
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/flutterwithlogo.png"),
                    fit: BoxFit.fitWidth)),
          ),
          // 로그인 인디케이터
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFB2F2D52)),
                  ),
                  visible: isVisible,
                ),
              ]),
          Container(
            margin: const EdgeInsets.only(
              bottom: 60.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 54.0,
                width: swidth / 1.45,
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      this.isVisible = true;
                    });
                    _signIn().whenComplete(() {
                      /*Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(username: name)),
                          (Route<dynamic> route) => false);*/
                      Navigator.pushReplacementNamed(context, "/home");
                    }).catchError((onError) {
                      Navigator.pushReplacementNamed(context, "/auth");
                    });
                  },
                  child: Text(
                    'G',
                    style: TextStyle(fontSize: 16),
                  ),
                  shape: CircleBorder(),
                  elevation: 5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


